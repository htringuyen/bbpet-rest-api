package com.bbpet.controllers;

import com.bbpet.domain.order.OrderView;
import com.bbpet.services.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

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
}
































