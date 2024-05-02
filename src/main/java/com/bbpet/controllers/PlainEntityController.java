package com.bbpet.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/dbexpose")
public class PlainEntityController {
    private static final Logger LOGGER = LoggerFactory.getLogger(PlainEntityController.class);

    @RequestMapping(value = "/{entity}", method = RequestMethod.GET)
    public String getAllOrSearch(@PathVariable("entity") String entity,
                                 @RequestParam Map<String, String> paramMap) {
        LOGGER.info("Expose entity: {}", entity);
        LOGGER.info("With param map: {}", paramMap);
        return "Response OK!";
    }

}
