package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.Order;
import com.bbpet.webapi.domain.shopping.OrderView;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;

public interface OrderService {

    List<Order> findAll();

    Page<OrderView> findAllViewsWithCriteria(
            Long orderId, String status, Long customerId, String customerName,
            String deliveryAddress, String phoneNumber,
            LocalDate afterDate, LocalDate beforeDate,
            Pageable pageable);
}
