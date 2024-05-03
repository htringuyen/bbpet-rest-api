package com.bbpet.domain.order;

import com.bbpet.domain.PlainEntity;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public record PlainOrder(Long id, LocalDateTime createdTime,
                         String deliveryAddress, OrderStatus status,
                         Long customerId, Long confirmedByEmployeeId)
        implements PlainEntity {

    private static final String[] SUPPORTED_CRITERIA_COLUMNS = new String[] {
            Order_.ID,
            Order_.CREATED_TIME,
            Order_.DELIVERY_ADDRESS,
            Order_.STATUS
    };

    private static final Map<String, String> SUPPORTED_CRITERIA_RELATIONS;

    static {
        SUPPORTED_CRITERIA_RELATIONS = new HashMap<>();
        SUPPORTED_CRITERIA_RELATIONS.put("customerId", Order_.CUSTOMER);
        SUPPORTED_CRITERIA_RELATIONS.put("confirmedByEmployeeId", Order_.EMPLOYEE);
    }


    public static Optional<String> getCriteriaColumnForParam(String param) {
        for (var column: SUPPORTED_CRITERIA_COLUMNS) {
            if (column.equals(param)) {
                return Optional.of(column);
            }
        }
        return Optional.empty();
    }

    public static Optional<String> getCriteriaRelationForParam(String param) {
        var relation = SUPPORTED_CRITERIA_RELATIONS.get(param);
        if (relation != null) {
            return Optional.of(relation);
        }
        return Optional.empty();
    }

    public static PlainOrder from(Order order) {
        return new PlainOrder(order.getId(), order.getCreatedTime(),
                order.getDeliveryAddress(), OrderStatus.valueOf("SUCCESS"),
                order.getCustomer().getId(), order.getEmployee().getId());
    }
}

























