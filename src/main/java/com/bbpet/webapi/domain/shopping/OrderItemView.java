package com.bbpet.webapi.domain.shopping;

public record OrderItemView(
        Long id, Long orderId, OrderItem.Type type,
        String itemName, Integer quantity,
        Double priceEach, Double discount,
        Long deliveryId, Delivery.Status deliveryStatus) {

}
