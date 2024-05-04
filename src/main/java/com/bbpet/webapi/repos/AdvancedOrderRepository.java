package com.bbpet.webapi.repos;

import com.bbpet.webapi.domain.customer.Customer_;
import com.bbpet.webapi.domain.order.Order;
import com.bbpet.webapi.domain.order.OrderStatus;
import com.bbpet.webapi.domain.order.OrderView;
import com.bbpet.webapi.domain.order.Order_;
import jakarta.persistence.EntityManager;
import jakarta.persistence.criteria.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.SequencedMap;

@Repository
public class AdvancedOrderRepository {
    private static final String GET_ORDER_PRICE_FUNCTION = "dbo.getOrderPrice";

    private static final ArrayList<String> SUPPORTED_ORDER_PROPERTIES =
            new ArrayList<>(List.of("id", "status", "price", "createdTime", "customerName", "deliveryAddress"));

    private final EntityManager em;

    public AdvancedOrderRepository(EntityManager em) {
        this.em = em;
    }

    public Page<OrderView> findOrderViews(Long id, String status, Long customerId,
                                         String customerName, String deliveryAddress,
                                         LocalDate beforeDate, LocalDate afterDate,
                                          Pageable pageable) {

        var cb = em.getCriteriaBuilder();
        var dateQuery = cb.createQuery(Object[].class);
        var orderRoot = dateQuery.from(Order.class);

        // build selections
        var selectionList = new ArrayList<Selection<?>>();

        // select order id
        selectionList.add(orderRoot.get(Order_.ID));

        // select order status
        selectionList.add(orderRoot.get(Order_.STATUS));

        // select order price by function
        var priceExpression = cb.function(GET_ORDER_PRICE_FUNCTION, Double.class, orderRoot.get(Order_.ID));
        selectionList.add(priceExpression);

        // select created time of order
        selectionList.add(orderRoot.get(Order_.CREATED_TIME));

        // select customer name
        selectionList.add(orderRoot.get(Order_.CUSTOMER).get(Customer_.NAME));

        // select customer delivery address
        selectionList.add(orderRoot.get(Order_.DELIVERY_ADDRESS));

        dateQuery.multiselect(selectionList.toArray(new Selection[0]));

        // build search criteria
        var dataCriteria = buildSearchCriteria(id, status, customerId, customerName,
                deliveryAddress, beforeDate, afterDate, cb, orderRoot);

        dateQuery.where(dataCriteria);

        // build order by
        var iterator = pageable.getSortOr(Sort.unsorted()).iterator();
        var sortOrderList = new ArrayList<jakarta.persistence.criteria.Order>();
        while (iterator.hasNext()) {
            var sortOrder = iterator.next();
            var property = sortOrder.getProperty();

            Expression<?> attribute = switch (property) {
                case "id" -> orderRoot.get(Order_.ID);
                case "status" -> orderRoot.get(Order_.STATUS);
                case "price" -> priceExpression;
                case "createdTime" -> orderRoot.get(Order_.CREATED_TIME);
                case "customerName" -> orderRoot.get(Order_.CUSTOMER).get(Customer_.NAME);
                case "deliveryAddress" -> orderRoot.get(Order_.DELIVERY_ADDRESS);
                default -> throw new IllegalArgumentException("Unsupported sort property: " + property);
            };

            sortOrderList.add(sortOrder.isAscending() ? cb.asc(attribute) : cb.desc(attribute));
        }

        dateQuery.orderBy(sortOrderList);

        // query for order views
        var query = em.createQuery(dateQuery);
        query.setFirstResult((int) pageable.getOffset());
        query.setMaxResults(pageable.getPageSize());

        var orderViews = query.getResultStream()
                .map(row -> new OrderView(
                        (Long) row[0],
                        (OrderStatus) row[1],
                        (Double) row[2],
                        (LocalDateTime) row[3],
                        (String) row[4],
                        (String) row[5]
                ))
                .toList();

        // count total records
        var countQuery = cb.createQuery(Long.class);
        countQuery.select(cb.count(countQuery.from(Order.class)));
        var countCriteria = buildSearchCriteria(id, status, customerId, customerName,
                deliveryAddress, beforeDate, afterDate, cb, countQuery.from(Order.class));
        countQuery.where(countCriteria);
        var count = em.createQuery(countQuery).getSingleResult();

        return new PageImpl<>(orderViews, pageable, count);
    }


    private String toWildCard(String value) {
        return "%" + value + "%";
    }

    private Predicate buildSearchCriteria(Long orderId, String status, Long customerId,
                                          String customerName, String deliveryAddress,
                                          LocalDate beforeDate, LocalDate afterDate,
                                          CriteriaBuilder cb, Root<Order> orderRoot) {
        var criteria = cb.conjunction();
        if (orderId != null) {
            criteria = cb.and(criteria, cb.equal(orderRoot.get(Order_.ID), orderId));
        }

        if (status != null) {
            criteria = cb.and(criteria, cb.like(orderRoot.get(Order_.STATUS), toWildCard(status)));
        }

        if (customerId != null) {
            criteria = cb.and(criteria, cb.equal(orderRoot.get(Order_.CUSTOMER).get(Customer_.ID), customerId));
        }

        if (customerName != null) {
            criteria = cb.and(criteria, cb.like(orderRoot.get(Order_.CUSTOMER).get(Customer_.NAME), toWildCard(customerName)));
        }

        if (deliveryAddress != null) {
            criteria = cb.and(criteria, cb.like(orderRoot.get(Order_.DELIVERY_ADDRESS), toWildCard(deliveryAddress)));
        }

        if (beforeDate != null) {
            criteria = cb.and(criteria, cb.lessThanOrEqualTo(orderRoot.get(Order_.CREATED_TIME), beforeDate));
        }

        if (afterDate != null) {
            criteria = cb.and(criteria, cb.greaterThanOrEqualTo(orderRoot.get(Order_.CREATED_TIME), afterDate));
        }

        return criteria;
    }
}























