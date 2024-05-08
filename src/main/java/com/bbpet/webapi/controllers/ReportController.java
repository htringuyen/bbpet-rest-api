package com.bbpet.webapi.controllers;

import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import com.bbpet.webapi.services.report.ReportService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/report")
public class ReportController {

    private final ReportService reportService;

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @RequestMapping("/intervals")
    public List<IntervalReport> getIntervalReports(
            @RequestParam(name = "intervalHours", required = false) Integer hours,
            @RequestParam(name = "fromTime", required = false) LocalDateTime fromTime,
            @RequestParam(name = "toTime", required = false) LocalDateTime toTime) {
        return reportService.getIntervalReports(hours, fromTime, toTime);
    }

    @RequestMapping("/overview")
    public OverviewReport getOverviewReport() {
        return reportService.getOverviewReport();
    }
}
