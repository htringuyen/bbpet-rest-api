package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.config.TransactionCfg;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class OrderItemServiceTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(OrderItemService.class);

    @Autowired
    private OrderItemService orderItemService;

    @Test
    void testFindViewsByOrder() {
        var orderId = 1L;
        var itemViews = orderItemService.findViewsByOrder(orderId);

        itemViews.forEach(v -> LOGGER.info(v.toString()));

        assertEquals(2, itemViews.size());
    }
}



































