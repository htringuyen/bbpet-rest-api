package com.bbpet.webapi.domain.shopping;


import java.time.LocalDateTime;

public record Deliverable(Long orderId, String itemType, String orderItemIds, Double totalPrice,
                          LocalDateTime createdTime, String customerName, String address, String phoneNumber,
                          String deliveryStatus, String sourceLocation) {
}