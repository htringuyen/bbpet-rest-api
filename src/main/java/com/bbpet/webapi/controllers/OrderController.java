package com.bbpet.webapi.controllers;

import com.bbpet.webapi.domain.shopping.OrderItemView;
import com.bbpet.webapi.domain.shopping.OrderView;
import com.bbpet.webapi.services.shopping.OrderItemService;
import com.bbpet.webapi.services.shopping.OrderService;
import com.bbpet.webapi.util.SortUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "/api/v1/order")
public class OrderController {

    final Logger LOGGER = LoggerFactory.getLogger(OrderController.class);

    private final OrderService orderService;

    private final OrderItemService orderItemService;

    public OrderController(OrderService orderService, OrderItemService orderItemService) {
        this.orderService = orderService;
        this.orderItemService = orderItemService;
    }


    @RequestMapping(path = {"/views"}, method = RequestMethod.GET)
    @ResponseStatus(HttpStatus.OK)
    public Page<OrderView> getOrderViewsWithCriteria(
            @RequestParam(name = "id", required = false) Long orderId,
            @RequestParam(name = "status", required = false) String status,
            @RequestParam(name = "customerId", required = false) Long customerId,
            @RequestParam(name = "customerName", required = false) String customerName,
            @RequestParam(name = "deliveryAddress", required = false) String deliveryAddress,
            @RequestParam(name = "phoneNumber", required = false) String phoneNumber,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            @RequestParam(name = "afterDate", required = false) LocalDate afterDate,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
            @RequestParam(name = "beforeDate", required = false) LocalDate beforeDate,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "pageSize", defaultValue = "" + Integer.MAX_VALUE) int pageSize,
            @RequestParam(name = "sortProperties", required = false, defaultValue = "id") String sortProperties,
            @RequestParam(name = "sortOrders", required = false, defaultValue = "ASC") String sortOrders) {

        var sort = SortUtils.parseSort(sortProperties, sortOrders);

        return orderService.findAllViewsWithCriteria(
                orderId, status, customerId, customerName,
                deliveryAddress, phoneNumber, afterDate, beforeDate,
                PageRequest.of(page, pageSize, sort));
    }

    @RequestMapping(path = {"/views/{id}/details"})
    @ResponseStatus(HttpStatus.OK)
    public List<OrderItemView> getOrderItemViewFor(@PathVariable(name = "id") Long id) {
        return orderItemService.findViewsByOrder(id);
    }
}
































