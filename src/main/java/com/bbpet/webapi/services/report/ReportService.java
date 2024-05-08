package com.bbpet.webapi.services.report;

import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;

import java.time.LocalDateTime;
import java.util.List;

public interface ReportService {

    List<IntervalReport> getIntervalReports(Integer intervalHours, LocalDateTime fromTime, LocalDateTime toTime);

    OverviewReport getOverviewReport();
}
