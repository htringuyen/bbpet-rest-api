package com.bbpet.webapi.domain.shopping;

import com.bbpet.webapi.domain.Staging;
import com.bbpet.webapi.domain.customer.Customer;
import com.bbpet.webapi.domain.employee.Employee;
import com.bbpet.webapi.domain.report.IntervalReport;
import com.bbpet.webapi.domain.report.OverviewReport;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;


@NamedNativeQueries({
        @NamedNativeQuery(name = "getReportByIntervals", query = """
                SELECT *
                FROM dbo.getReportByIntervals (:intervalHours, :fromTime, :toTime)
                ORDER BY intervalNumber
                """, resultSetMapping = "intervalReportMapping"),


        @NamedNativeQuery(name = "getOverviewReport", query = """
                SELECT
                    SUM(I.quantity * I.priceEach * (1 - discount)) AS totalRevenue,
                    SUM(IIF(I.type = 'PRODUCT', I.quantity, 0)) AS productsSold,
                    SUM(IIF(I.type = 'SERVICE', I.quantity, 0)) AS servicesSold,
                    COUNT(DISTINCT O.customerId) AS customerCount
                FROM
                    [Order] O
                    LEFT JOIN OrderItem I ON I.orderId = O.id
                WHERE O.status = 'SUCCESS'
                """, resultSetMapping = "overviewReportMapping")
})

@SqlResultSetMapping(
        name = "intervalReportMapping",
        classes = {
                @ConstructorResult(
                        targetClass = IntervalReport.class,
                        columns = {
                                @ColumnResult(name = "intervalNumber", type = Integer.class),
                                @ColumnResult(name = "orderCount", type = Integer.class),
                                @ColumnResult(name = "productsOrdered", type = Integer.class),
                                @ColumnResult(name = "servicesOrdered", type = Integer.class),
                                @ColumnResult(name = "totalRevenue", type = Double.class),
                                @ColumnResult(name = "productRevenue", type = Double.class),
                                @ColumnResult(name = "serviceRevenue", type = Double.class),
                                @ColumnResult(name = "discountAmount", type = Double.class),
                                @ColumnResult(name = "deliveriesSuccess", type = Integer.class),
                                @ColumnResult(name = "deliveriesFailed", type = Integer.class),
                                @ColumnResult(name = "meanDeliveryHours", type = Double.class),
                                @ColumnResult(name = "meanPendingHours", type = Double.class),
                        }
                )
        }
)

@SqlResultSetMapping(
        name = "overviewReportMapping",
        classes = {
                @ConstructorResult(
                        targetClass = OverviewReport.class,
                        columns = {
                                @ColumnResult(name = "totalRevenue", type = Double.class),
                                @ColumnResult(name = "productsSold", type = Integer.class),
                                @ColumnResult(name = "servicesSold", type = Integer.class),
                                @ColumnResult(name = "customerCount", type = Integer.class),
                        }
                )
        }
)


@Data
@Entity
@Table(name = "[Order]")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @Column(name = "createdTime")
    private LocalDateTime createdTime;

    @NotNull
    @Column(name = "deliveryAddress")
    private String deliveryAddress;

    @NotNull
    @Column(name = "phoneNumber")
    private String phoneNumber;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Status status;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "customerId")
    private Customer customer;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "employeeId")
    private Employee employee;

    @OneToMany(mappedBy = "order")
    private List<OrderItem> orderItems;


    /**
     * Status of Order and the flow of statuses
     */
    enum Status implements Staging<Status>{

        INITIALIZING(1, false, true),

        PENDING(2, false, true),

        CONFIRMED(3, false, true),

        NOT_ACCEPTED(3, true, false),

        DELIVERING(4, false, true),

        SUCCESS(5, true, true),

        CANCELED(5, true, false),
        ;


        private final int order;

        private final boolean prioritized;

        private final boolean terminated;

        Status(int order, boolean terminated, boolean prioritized) {
            this.order = order;
            this.terminated = terminated;
            this.prioritized = prioritized;
        }

        @Override
        public boolean isTerminated() {
            return terminated;
        }

        @Override
        public int getOrder() {
            return order;
        }

        @Override
        public boolean isPrioritized() {
            return prioritized;
        }

        @Override
        public List<Status> getStages() {
            return Arrays.asList(values());
        }
    }
}




















































