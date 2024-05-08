package com.bbpet.webapi.domain.report;




public record IntervalReport(Integer intervalNumber, Integer orderCount,
                             Integer productsOrdered, Integer servicesOrdered,
                             Double totalRevenue, Double productRevenue, Double serviceRevenue, Double discountAmount,
                             Integer deliveriesSuccess, Integer deliveriesFailed, Double meanDeliveryHours, Double meanPendingHours
                             ) {


}
