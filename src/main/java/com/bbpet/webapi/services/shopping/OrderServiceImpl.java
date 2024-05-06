package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.Order;
import com.bbpet.webapi.repos.OrderViewQuery;
import com.bbpet.webapi.repos.OrderRepository;
import com.bbpet.webapi.domain.shopping.OrderView;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Transactional
@Service("orderService")
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    private final OrderViewQuery orderViewQuery;

    public OrderServiceImpl(OrderRepository orderRepository, OrderViewQuery orderViewQuery) {
        this.orderRepository = orderRepository;
        this.orderViewQuery = orderViewQuery;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> findAll() {
        return orderRepository.findAll(Sort.unsorted());
    }

    @Override
    @Transactional(readOnly = true)
    public Page<OrderView> findAllViewsWithCriteria(
            Long id, String status, Long customerId, String customerName,
            String deliveryAddress, String phoneNumber,
            LocalDate afterDate, LocalDate beforeDate,
            Pageable pageable) {

        return orderViewQuery.findOrderViews(
                id, status, customerId, customerName, deliveryAddress,
                phoneNumber, afterDate, beforeDate, pageable);
    }
}





































