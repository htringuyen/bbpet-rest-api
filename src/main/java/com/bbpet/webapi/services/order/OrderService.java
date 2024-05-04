package com.bbpet.webapi.services.order;

import com.bbpet.webapi.domain.order.Order;
import com.bbpet.webapi.domain.order.OrderView;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.SequencedMap;

public interface OrderService {

    List<Order> findAll();

    List<OrderView> findAllViews();

    Page<OrderView> findAllViewsWithCriteria(Long orderId, String status, Long customerId,
                                             String customerName, String deliveryAddress,
                                             LocalDate beforeDate, LocalDate afterDate,
                                             Pageable pageable);
}
