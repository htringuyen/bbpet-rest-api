package com.bbpet.webapi.repos;

import com.bbpet.webapi.domain.customer.Customer_;
import com.bbpet.webapi.domain.shopping.OrderView;
import com.bbpet.webapi.domain.shopping.Order_;
import jakarta.persistence.EntityManager;
import jakarta.persistence.criteria.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Repository;
import com.bbpet.webapi.domain.shopping.Order;

import java.time.LocalDate;
import java.util.ArrayList;

@Repository
public class OrderViewQuery {

    private static final String GET_ORDER_PRICE_FUNCTION = "dbo.getOrderPrice";

    private final EntityManager em;

    public OrderViewQuery(EntityManager em) {
        this.em = em;
    }

    public Page<OrderView> findOrderViews(
            Long id, String status,
            Long customerId, String customerName,
            String deliveryAddress, String phoneNumber,
            LocalDate afterDate, LocalDate beforeDate,
            Pageable pageable) {

        var cb = em.getCriteriaBuilder();
        var dateQuery = cb.createQuery(OrderView.class);
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

        // select phone number
        selectionList.add(orderRoot.get(Order_.PHONE_NUMBER));

        dateQuery.multiselect(selectionList.toArray(new Selection[0]));

        // build search criteria
        var dataCriteria = buildSearchCriteria(id, status, customerId, customerName,
                deliveryAddress, phoneNumber, beforeDate, afterDate, cb, orderRoot);

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

        var orderViews = query.getResultList();

        var totalViews = countTotalViews(id, status, customerId, customerName,
                deliveryAddress, phoneNumber, beforeDate, afterDate);

        return new PageImpl<>(orderViews, pageable, totalViews);
    }


    private String toWildCard(String value) {
        return "%" + value + "%";
    }

    private Predicate buildSearchCriteria(
            Long orderId, String status, Long customerId, String customerName,
            String deliveryAddress, String phoneNumber,
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

        if (phoneNumber != null) {
            criteria = cb.and(criteria, cb.like(orderRoot.get(Order_.PHONE_NUMBER), toWildCard(phoneNumber)));
        }

        if (beforeDate != null) {
            criteria = cb.and(criteria, cb.lessThanOrEqualTo(orderRoot.get(Order_.CREATED_TIME), beforeDate));
        }

        if (afterDate != null) {
            criteria = cb.and(criteria, cb.greaterThanOrEqualTo(orderRoot.get(Order_.CREATED_TIME), afterDate));
        }

        return criteria;
    }

    private int countTotalViews(
            Long id, String status, Long customerId, String customerName,
            String deliveryAddress, String phoneNumber,
            LocalDate beforeDate, LocalDate afterDate) {

        var cb = em.getCriteriaBuilder();

        var countQuery = cb.createQuery(Long.class);

        countQuery.select(cb.count(countQuery.from(Order.class)));

        var countCriteria = buildSearchCriteria(id, status, customerId, customerName, deliveryAddress,
                phoneNumber, beforeDate, afterDate, cb, countQuery.from(Order.class));

        countQuery.where(countCriteria);

        return em.createQuery(countQuery).getSingleResult().intValue();
    }
}























