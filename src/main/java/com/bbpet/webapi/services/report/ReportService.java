package com.bbpet.webapi.services.report;

import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import com.bbpet.webapi.domain.report.ShoppingReport;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;

public interface ReportService {

    List<IntervalReport> getIntervalReports(Integer intervalHours, LocalDateTime fromTime, LocalDateTime toTime);

    OverviewReport getOverviewReport();

    Page<ShoppingReport> getShoppingReports(String searchColumn, String searchValue, Pageable pageable);
}
