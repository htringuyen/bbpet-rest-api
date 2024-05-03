package com.bbpet.domain.order;

import java.time.LocalDateTime;


public record OrderView(Long orderId, String status,
                        Double totalPrice, LocalDateTime createdTime,
                        String customerName, String deliveryAddress) {
}
