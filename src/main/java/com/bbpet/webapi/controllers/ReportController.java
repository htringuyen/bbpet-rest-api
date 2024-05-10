package com.bbpet.webapi.controllers;

import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import com.bbpet.webapi.domain.report.ShoppingReport;
import com.bbpet.webapi.services.report.ReportService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
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

    @RequestMapping("/shoppings")
    public Page<ShoppingReport> getShoppingReport(
            @RequestParam(name = "searchColumn", defaultValue = "N/A") String searchColumn,
            @RequestParam(name = "searchValue", defaultValue = "N/A") String searchValue,
            @RequestParam(name = "sortColumn", defaultValue = "customerId") String sortColumn,
            @RequestParam(name = "sortOrder", defaultValue = "ASC") String sortOrder,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "pageSize", defaultValue = "" + Integer.MAX_VALUE) int pageSize) {

        var sort = Sort.by(
                sortOrder.equals("DESC")
                        ? Sort.Order.desc(sortColumn)
                        : Sort.Order.asc(sortColumn));

        var pageable = PageRequest.of(page, pageSize, sort);
        return reportService.getShoppingReports(searchColumn, searchValue, pageable);
    }
}
