package com.bbpet.webapi.domain.shopping;

import com.bbpet.webapi.domain.item.ShopItem;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Stream;

public record Deliverable(Long orderId, ShopItem.Type itemType, List<Long> orderItemIds, Double totalPrice,
                          LocalDateTime createdTime, String customerName, String address, String phoneNumber,
                          Delivery.Status deliveryStatus, String sourceLocation) {

    public Deliverable(Long orderId, ShopItem.Type itemType, String orderItemIds, Double totalPrice,
                       LocalDateTime createdTime, String customerName, String address, String phoneNumber,
                       Delivery.Status deliveryStatus, String sourceLocation) {

        this(orderId, itemType, Stream.of(orderItemIds.split(", ")).map(Long::parseLong).toList(), totalPrice,
                createdTime, customerName, address, phoneNumber, deliveryStatus, sourceLocation);
    }
}
