package com.bbpet.controllers;

import com.bbpet.domain.PlainEntity;
import com.bbpet.services.dbexpose.PlainOrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/plainorder")
public class PlainOrderController {
    private static final Logger LOGGER = LoggerFactory.getLogger(PlainOrderController.class);

    private final PlainOrderService plainOrderService;

    public PlainOrderController(PlainOrderService plainOrderService) {
        this.plainOrderService = plainOrderService;
    }

    @RequestMapping(value = "/{entity}", method = RequestMethod.GET)
    public List<? extends PlainEntity> getAllOrSearch(@PathVariable("entity") String entity,
                                                      @RequestParam Map<String, String> paramMap) {
        LOGGER.info("Expose entity: {}", entity);
        LOGGER.info("With param map: {}", paramMap);

        if (entity.equals("order")) {
            return plainOrderService.findAllByParams(paramMap);
        } else {
            return null;
        }
    }
}
