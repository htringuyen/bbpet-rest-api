package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.Deliverable;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@Transactional
public class DeliveryHandlingService {

    private final EntityManager em;

    public DeliveryHandlingService(EntityManager em) {
        this.em = em;
    }

    public Page<Deliverable> getDeliverablesToProcess(LocalDateTime fromTime, LocalDateTime toTime, Double fromPrice, Double toPrice,
                                                      String searchColumn, String searchValue, String sortColumn, String sortOrder,
                                                      int page, int size) {

        var deliverables = em.createNamedQuery("getDeliverablesToProcess", Deliverable.class)
                .setParameter("fromTime", fromTime)
                .setParameter("toTime", toTime)
                .setParameter("fromPrice", fromPrice)
                .setParameter("toPrice", toPrice)
                .setParameter("searchColumn", searchColumn)
                .setParameter("searchValue", searchValue)
                .setParameter("sortColumn", sortColumn)
                .setParameter("sortOrder", sortOrder)
                .setFirstResult(page * size)
                .setMaxResults(size)
                .getResultList();

        return new PageImpl<>(deliverables);
    }
}
