package com.bbpet.domain.order;

import java.time.LocalDateTime;


public record OrderView(Long orderId, String status,
                        Double totalPrice, LocalDateTime createdDate,
                        String customerName, String deliveryAddress) {
}
