package com.bbpet.webapi.services.report;

import com.bbpet.webapi.domain.customer.Customer_;
import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import com.bbpet.webapi.domain.report.ShoppingReport;
import jakarta.persistence.EntityManager;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class ReportServiceImpl implements ReportService{

    private static final String QUERY_GET_CUSTOMER_SHOPPING_REPORTS = "getCustomerShoppingReports";

    private final EntityManager em;

    public ReportServiceImpl(EntityManager em) {
        this.em = em;
    }

    @Override
    @Transactional(readOnly = true)
    public List<IntervalReport> getIntervalReports(Integer intervalHours, LocalDateTime fromTime, LocalDateTime toTime) {

        intervalHours = intervalHours == null ? 24 : intervalHours;

        fromTime = fromTime == null
                ? LocalDateTime.of(1970, 1, 1, 0, 0)
                : fromTime;

        toTime = toTime == null
                ? LocalDateTime.of(2050, 1, 1, 0, 0)
                : toTime;

        return em.createNamedQuery("getReportByIntervals", IntervalReport.class)
                .setParameter("intervalHours", intervalHours)
                .setParameter("fromTime", fromTime)
                .setParameter("toTime", toTime)
                .getResultList();
    }

    @Override
    @Transactional(readOnly = true)
    public OverviewReport getOverviewReport() {
        return em.createNamedQuery("getOverviewReport", OverviewReport.class)
                .getSingleResult();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<ShoppingReport> getShoppingReports(String searchColumn, String searchValue, Pageable pageable) {

        var procedureQuery = em.createNamedStoredProcedureQuery(QUERY_GET_CUSTOMER_SHOPPING_REPORTS)
                .setParameter("searchColumn", searchColumn)
                .setParameter("searchValue", searchValue)
                .setParameter("rowsOffset", pageable.getOffset())
                .setParameter("rowsFetch", pageable.getPageSize());

        pageable.getSort().stream().findFirst().ifPresent(order ->
                        procedureQuery
                                .setParameter("sortColumn", order.getProperty())
                                .setParameter("sortOrder", order.isAscending() ? "ASC" : "DESC")
        );

        List<ShoppingReport> shoppingReports;
        if (procedureQuery.execute()) {
            shoppingReports = procedureQuery.getResultList();
        } else {
            throw new IllegalStateException("Result set should be available");
        }

        var totalRows = (Integer) procedureQuery.getOutputParameterValue("totalRows");

        return new PageImpl<>(shoppingReports, pageable, totalRows);
    }
}





















