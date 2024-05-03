package com.bbpet.webapi.services;

import com.bbpet.webapi.domain.order.Order;
import com.bbpet.webapi.repos.OrderRepo;
import com.bbpet.webapi.domain.order.OrderView;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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

    private final OrderRepo orderRepo;

    private final EntityManager em;

    public OrderServiceImpl(OrderRepo orderRepo, EntityManager entityManager) {
        this.orderRepo = orderRepo;
        this.em = entityManager;
    }

    @Transactional(readOnly = true)
    public List<Order> findAll() {
        return orderRepo.findAll(Sort.unsorted());
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = true)
    public List<OrderView> findAllViews() {
        return em.createNativeQuery(GET_ALL_VIEWS_NATIVE_QUERY, "orderViewResult")
                .getResultList();
    }
}





































