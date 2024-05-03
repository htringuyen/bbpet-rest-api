package com.bbpet.webapi.services;

import com.bbpet.webapi.domain.order.Order;
import com.bbpet.webapi.domain.order.OrderView;

import java.util.List;

public interface OrderService {

    List<Order> findAll();

    List<OrderView> findAllViews();
}
