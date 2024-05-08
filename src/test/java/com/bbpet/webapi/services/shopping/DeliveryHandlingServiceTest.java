package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.config.TransactionCfg;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class DeliveryHandlingServiceTest {

    @Autowired
    private DeliveryHandlingService deliveryHandlingService;

    @Test
    void testGetDeliverablesToProcess() {
        var fromTime = LocalDateTime.of(2022, 1, 1, 0, 0, 0);
        var toTime = LocalDateTime.of(2023, 1, 1, 0, 0, 0);
        var fromPrice = 0.0;
        var toPrice = 500.0;
        var searchColumn = "customerName";
        var searchValue = "John";

        var pageable = PageRequest.of(0, 1000, Sort.by(Sort.Order.asc("address")));

        var deliverables = deliveryHandlingService.getDeliverablesToProcess(fromTime, toTime, fromPrice, toPrice,
                searchColumn, searchValue, pageable);

        assertEquals(504, deliverables.getContent().size());
    }


}
