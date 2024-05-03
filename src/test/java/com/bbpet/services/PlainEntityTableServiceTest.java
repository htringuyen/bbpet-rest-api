package com.bbpet.services;

import com.bbpet.TransactionCfg;
import com.bbpet.domain.order.Order;
import com.bbpet.services.dbexpose.PlainEntityTableService;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.util.HashMap;
import java.util.LinkedHashMap;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class PlainEntityTableServiceTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(PlainEntityTableService.class);

    @Autowired
    private PlainEntityTableService tableService;

    @Test
    void testFindAllOrSearch() {
        var paramMap = new HashMap<String, String>();
        paramMap.put("customerId", "2");
        tableService.findAllByParams(paramMap, Order.class)
                .forEach(plainEntity -> LOGGER.info(plainEntity.toString()));
    }

    @Test
    void testUpdateRow() {
        var paramMap = new LinkedHashMap<String, String>();
        paramMap.put("deliveryAddress", "123 Main St, Anytown, USA");
        paramMap.put("status", "Completed");
        var rowsUpdated = tableService.updateRow("11", paramMap, Order.class);
        assertEquals(1 , rowsUpdated);
    }

    @Test
    void testCreateRow() {
        var paramMap = new LinkedHashMap<String, String>();
        paramMap.put("createdTime", "2023-03-20 16:30:00.000");
        paramMap.put("deliveryAddress", "123 Main St, Anytown, USA");
        paramMap.put("status", "In Progress");
        paramMap.put("customerId", "3");
        paramMap.put("confirmedByEmployeeId", "2");

        var rowsUpdated = tableService.createRow(paramMap, Order.class);
        assertEquals(rowsUpdated, 1);
    }

    @Test
    void testDeleteRow() {
        int rowsDeleted = tableService.deleteRow("15", Order.class);
        assertEquals(0, rowsDeleted);

        rowsDeleted = tableService.deleteRow("12", Order.class);
        assertEquals(1, rowsDeleted);
    }



}

























