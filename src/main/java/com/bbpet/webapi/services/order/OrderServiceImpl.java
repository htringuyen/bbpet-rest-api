package com.bbpet.webapi.services.order;

import com.bbpet.webapi.domain.order.Order;
import com.bbpet.webapi.repos.AdvancedOrderRepository;
import com.bbpet.webapi.repos.OrderRepository;
import com.bbpet.webapi.domain.order.OrderView;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.SequencedMap;

@Transactional
@Service("orderService")
public class OrderServiceImpl implements OrderService {

    private static final String GET_ALL_VIEWS_NATIVE_QUERY = """
            SELECT o.id as orderId, status, dbo.getOrderPrice(o.id) as totalPrice, createdTime,
                   c.name as customerName, deliveryAddress
            FROM [Order] o
            LEFT JOIN Customer c
            ON o.customerId = c.id
            """;

    private final OrderRepository orderRepository;

    private final AdvancedOrderRepository advancedOrderRepository;

    private final EntityManager em;

    public OrderServiceImpl(OrderRepository orderRepository, AdvancedOrderRepository advancedOrderRepository, EntityManager entityManager) {
        this.orderRepository = orderRepository;
        this.em = entityManager;
        this.advancedOrderRepository = advancedOrderRepository;
    }

    @Transactional(readOnly = true)
    public List<Order> findAll() {
        return orderRepository.findAll(Sort.unsorted());
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = true)
    public List<OrderView> findAllViews() {
        return em.createNativeQuery(GET_ALL_VIEWS_NATIVE_QUERY, "orderViewResult")
                .getResultList();
    }

    public Page<OrderView> findAllViewsWithCriteria(Long id, String status, Long customerId,
                                             String customerName, String deliveryAddress,
                                             LocalDate beforeDate, LocalDate afterDate,
                                                Pageable pageable) {
        return advancedOrderRepository.findOrderViews(
                id, status, customerId, customerName, deliveryAddress, beforeDate, afterDate, pageable);
    }
}





































