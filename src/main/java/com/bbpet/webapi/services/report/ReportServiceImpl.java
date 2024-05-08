package com.bbpet.webapi.services.report;

import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import jakarta.persistence.EntityManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class ReportServiceImpl implements ReportService{

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
}





















