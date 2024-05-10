package com.bbpet.webapi.domain.report;

import java.time.LocalDateTime;

public record ShoppingReport(Long customerId, String customerName, String phoneNumber,
                             String favoriteItem, Double totalPayment, Double bestOrderValue,
                             Integer ordersSuccess, Integer ordersFailed, LocalDateTime lastActiveTime) {
}
