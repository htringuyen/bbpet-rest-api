package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.Deliverable;
import com.bbpet.webapi.domain.shopping.Delivery_;
import jakarta.persistence.EntityManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class DeliveryHandlingServiceImpl implements DeliveryHandlingService {

    private static final Logger LOGGER = LoggerFactory.getLogger(DeliveryHandlingServiceImpl.class);

    private final EntityManager em;

    public DeliveryHandlingServiceImpl(EntityManager em) {
        this.em = em;
    }

    public Page<Deliverable> getDeliverablesToProcess(LocalDateTime fromTime, LocalDateTime toTime, Double fromPrice, Double toPrice,
                                                      String searchColumn, String searchValue,
                                                      Pageable pageable) {

        var procedureQuery = em.createNamedStoredProcedureQuery(Delivery_.QUERY_GET_DELIVERABLES_TO_PROCESS)
                .setParameter("fromTime", fromTime)
                .setParameter("toTime", toTime)
                .setParameter("fromPrice", fromPrice)
                .setParameter("toPrice", toPrice)
                .setParameter("searchColumn", searchColumn)
                .setParameter("searchValue", searchValue)
                .setParameter("rowsOffset", pageable.getOffset())
                .setParameter("rowsFetch", pageable.getPageSize());

        pageable.getSort().stream().findFirst().ifPresent(
                order -> procedureQuery
                        .setParameter("sortColumn", order.getProperty())
                        .setParameter("sortOrder", order.isAscending() ? "ASC" : "DESC")
        );

        List<Deliverable> deliverables;

        if (procedureQuery.execute()) {
            deliverables = procedureQuery.getResultList();
        } else {
            throw new IllegalStateException("Result set should be available");
        }

        var totalRows = (Integer) procedureQuery.getOutputParameterValue("totalRows");

        return new PageImpl<>(deliverables, pageable, totalRows);
   }
}































