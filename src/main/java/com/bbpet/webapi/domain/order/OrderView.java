package com.bbpet.webapi.domain.order;

import java.time.LocalDateTime;

public record OrderView(Long id, OrderStatus status,
                        Double price, LocalDateTime createdTime,
                        String customerName, String deliveryAddress) {

}
