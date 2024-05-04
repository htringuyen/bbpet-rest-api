package com.bbpet.webapi.controllers;

import com.bbpet.webapi.domain.order.OrderView;
import com.bbpet.webapi.services.order.OrderService;
import com.bbpet.webapi.util.SortUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "order")
public class OrderController {
    final Logger LOGGER = LoggerFactory.getLogger(OrderController.class);

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @RequestMapping(path = {"/view"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public List<OrderView> getOrderViews() {
        return orderService.findAllViews();
    }


    @RequestMapping(path = {"/views"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public Page<OrderView> getOrderViewsWithCriteria(@RequestParam(name = "id", required = false) Long orderId,
                                                     @RequestParam(name = "status", required = false) String status,
                                                     @RequestParam(name = "customerId", required = false) Long customerId,
                                                     @RequestParam(name = "customerName", required = false) String customerName,
                                                     @RequestParam(name = "deliveryAddress", required = false) String deliveryAddress,
                                                     @RequestParam(name = "beforeDate", required = false) LocalDate beforeDate,
                                                     @RequestParam(name = "afterDate", required = false) LocalDate afterDate,
                                                     @RequestParam(name = "page", defaultValue = "0") int page,
                                                     @RequestParam(name = "pageSize", defaultValue = "" + Integer.MAX_VALUE) int pageSize,
                                                     @RequestParam(name = "sortProperties", required = false, defaultValue = "status,price,deliveryAddress,customerName") String sortProperties,
                                                     @RequestParam(name = "sortOrders", required = false, defaultValue = "ASC,DESC,ASC,DESC") String sortOrders
                                                     ) {
        var sort = SortUtils.parseSort(sortProperties, sortOrders);

        return orderService.findAllViewsWithCriteria(
                orderId, status, customerId, customerName, deliveryAddress, beforeDate, afterDate,
                PageRequest.of(page, pageSize, sort));
    }
}
































