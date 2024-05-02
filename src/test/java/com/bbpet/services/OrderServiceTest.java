package com.bbpet.services;

import com.bbpet.TransactionCfg;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class OrderServiceTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(OrderServiceTest.class);

    @Autowired
    @Qualifier("orderService")
    private OrderService orderService;

    @Test
    void testServiceAvailable() {
        assertNotNull(orderService);
    }

    @Test
    void testNativeMappings() {
        orderService.findAllViews()
                .forEach(o -> LOGGER.info(o.toString()));

        //orderService.findAllByNativeQuery();
    }

    @Test
    void testFindAllOrders() {
        orderService.findAll()
                .forEach(o -> LOGGER.info(o.toString()));
    }


}






















