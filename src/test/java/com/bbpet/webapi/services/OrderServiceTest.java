package com.bbpet.webapi.services;

import com.bbpet.webapi.config.TransactionCfg;
import com.bbpet.webapi.services.order.OrderService;
import com.bbpet.webapi.util.SortUtils;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import static org.junit.jupiter.api.Assertions.assertEquals;
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

    @Test
    void testFindAllViewsWithCriteria() {

        // query string sortby and sortorder for deliveryAddress and customerName
        var sortProperties = "status,price,deliveryAddress,customerName";
        var sortOrders = "ASC,DESC,ASC,DESC";
        var sort = SortUtils.parseSort(sortProperties, sortOrders);

        var page = orderService.findAllViewsWithCriteria(
                null, null, null, null,
                        null, null, null,
                PageRequest.of(0, 9, sort));
        assertEquals(9, page.getContent().size());

        page.forEach(o -> LOGGER.info(o.toString()));

        // do again for status = 'S' and beforeDate = 2023-03-18 and afterDate = 2023-03-11
        page = orderService.findAllViewsWithCriteria(
                null, "S", null, null,
                null,
                java.time.LocalDate.of(2023, 3, 18),
                java.time.LocalDate.of(2023, 3, 11),
                PageRequest.of(1, 2, sort));
        assertEquals(1, page.getContent().size());
        page.forEach(o -> LOGGER.info(o.toString()));
    }


}






















