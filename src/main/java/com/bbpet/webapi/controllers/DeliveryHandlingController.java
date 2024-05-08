package com.bbpet.webapi.controllers;

import com.bbpet.webapi.domain.shopping.Deliverable;
import com.bbpet.webapi.services.shopping.DeliveryHandlingService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/delivery-handling")
public class DeliveryHandlingController {

    private final DeliveryHandlingService deliveryHandlingService;

    public DeliveryHandlingController(DeliveryHandlingService deliveryHandlingService) {
        this.deliveryHandlingService = deliveryHandlingService;
    }


    @RequestMapping(path = "/deliverables", method = RequestMethod.GET)
    public Page<Deliverable> getDeliverablesToProcess(
            @RequestParam(name = "fromTime", defaultValue = "1970-01-01T00:00:00") LocalDateTime fromTime,
            @RequestParam(name = "toTime", defaultValue = "2050-01-01T00:00:00") LocalDateTime toTime,
            @RequestParam(name = "fromPrice", defaultValue = "0.00") Double fromPrice,
            @RequestParam(name = "toPrice", defaultValue = "9999999.00") Double toPrice,
            @RequestParam(name = "searchColumn", defaultValue = "N/A") String searchColumn,
            @RequestParam(name = "searchValue", defaultValue = "N/A") String searchValue,
            @RequestParam(name = "sortColumn", defaultValue = "orderId") String sortColumn,
            @RequestParam(name = "sortOrder", defaultValue = "ASC") String sortOrder,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "pageSize", defaultValue = "" + Integer.MAX_VALUE) int size
    ) {

        var sort = Sort.by(
                sortOrder.equals("DESC")
                        ? Sort.Order.desc(sortColumn)
                        : Sort.Order.asc(sortColumn));

        var pageable = PageRequest.of(page, size, sort);

        return deliveryHandlingService.getDeliverablesToProcess(
                fromTime, toTime, fromPrice, toPrice, searchColumn, searchValue, pageable);
    }

}
