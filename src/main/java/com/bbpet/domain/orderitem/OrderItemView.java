package com.bbpet.domain.orderitem;

public record OrderItemView(Long orderItemId, String itemType, String itemName, Integer quantity,
                            Double priceEach, Double discountPercent, String processingStatus) {


}
