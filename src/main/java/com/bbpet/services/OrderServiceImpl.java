package com.bbpet.services;

import com.bbpet.domain.order.Order;
import com.bbpet.repos.OrderRepo;
import com.bbpet.domain.order.OrderView;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
@Service("orderService")
public class OrderServiceImpl implements OrderService {

    private static final String GET_ALL_VIEWS_NATIVE_QUERY = """
            SELECT o.id as orderId, status, orderman.getTotalOrderPrice(o.id) as totalPrice, createdTime,
                   c.name as customerName, deliveryAddress
            FROM orderman.[Order] o
            LEFT JOIN customerman.Customer c
            ON o.customerId = c.id
            """;

    private static final String ALL_ORDER_BY_NATIVE_QUERY = """
            SELECT id, createdDate, deliveryAddress, status
            FROM orderman.[Order]
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
