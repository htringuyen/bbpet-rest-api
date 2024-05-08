package com.bbpet.webapi.services.report;

import com.bbpet.webapi.config.TransactionCfg;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class ReportServiceTest {

    private final Logger LOGGER = LoggerFactory.getLogger(ReportServiceTest.class);

    @Autowired
    private ReportService reportService;

    @Test
    void testGetIntervalReport() {
        var intervalHours = 24;
        var fromTime = LocalDateTime.of(1970, 1, 1, 0, 0);
        var toTime = LocalDateTime.of(2050, 1, 1, 0, 0);
        var reports = reportService.getIntervalReports(intervalHours, fromTime, toTime);

        reports.forEach(r -> LOGGER.info(r.toString()));

        assertEquals(730, reports.size());
    }

    @Test
    void testOverviewReport() {
        var report = reportService.getOverviewReport();
        assertNotNull(report);
        LOGGER.info(report.toString());
    }
}



























