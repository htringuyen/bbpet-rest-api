package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.Deliverable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;

public interface DeliveryHandlingService {

    Page<Deliverable> getDeliverablesToProcess(LocalDateTime fromTime, LocalDateTime toTime, Double fromPrice, Double toPrice,
                                               String searchColumn, String searchValue,
                                               Pageable pageable);
}
