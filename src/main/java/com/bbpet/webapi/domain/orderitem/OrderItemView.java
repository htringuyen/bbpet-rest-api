package com.bbpet.webapi.domain.orderitem;

public record OrderItemView(Long id, String itemType, String itemName, Integer quantity,
                            Double priceEach, Double discountPercent, String processingStatus) {


}
