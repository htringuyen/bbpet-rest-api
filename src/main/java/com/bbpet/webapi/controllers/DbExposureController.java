package com.bbpet.webapi.controllers;

import com.bbpet.webapi.services.dbexpose.PlainEntityTableService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dbexpose")
public class DbExposureController {

    private final PlainEntityTableService tableService;

    public DbExposureController(PlainEntityTableService tableService) {
        this.tableService = tableService;
    }

    @RequestMapping(value = "/{entity}", method = RequestMethod.GET)
    public List<Map<String, String>> getAllOrSearch(@PathVariable("entity") String entity,
                                                    @RequestParam Map<String, String> paramMap) {
        /*if (entity.equals("order")) {
            return tableService.findAllByParams(paramMap, Order.class);
        } else {
            return null;
        }*/
        return null;
    }
}
