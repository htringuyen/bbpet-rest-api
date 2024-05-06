package com.bbpet.webapi.domain.shopping;

import java.time.LocalDateTime;

public record OrderView(Long id, Order.Status status,
                        Double price, LocalDateTime createdTime,
                        String customerName, String deliveryAddress, String phoneNumber) {

}
