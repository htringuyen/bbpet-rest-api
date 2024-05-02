package com.bbpet.services;

import com.bbpet.domain.order.Order;
import com.bbpet.domain.order.OrderView;

import java.util.List;

public interface OrderService {

    List<Order> findAll();

    List<OrderView> findAllViews();
}
