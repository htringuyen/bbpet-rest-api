package com.bbpet.webapi.domain.customer;

import com.bbpet.webapi.domain.report.ShoppingReport;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;


@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(
                name = "getCustomerShoppingReports",
                procedureName = "getCustomerShoppingReports",
                parameters = {
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "searchColumn", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "searchValue", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "sortColumn", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "sortOrder", type = String.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "rowsOffset", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.IN, name = "rowsFetch", type = Integer.class),
                        @StoredProcedureParameter(mode = ParameterMode.OUT, name = "totalRows", type = Integer.class)
                }
                , resultSetMappings = {"shoppingReportMapping"}
        )
})


@SqlResultSetMappings({
        @SqlResultSetMapping(
                name = "shoppingReportMapping",
                classes = {
                        @ConstructorResult(
                                targetClass = ShoppingReport.class,
                                columns = {
                                        @ColumnResult(name = "customerId", type = Long.class),
                                        @ColumnResult(name = "customerName", type = String.class),
                                        @ColumnResult(name = "phoneNumber", type = String.class),
                                        @ColumnResult(name = "favoriteItem", type = String.class),
                                        @ColumnResult(name = "totalPayment", type = Double.class),
                                        @ColumnResult(name = "bestOrderValue", type = Double.class),
                                        @ColumnResult(name = "ordersSuccess", type = Integer.class),
                                        @ColumnResult(name = "ordersFailed", type = Integer.class),
                                        @ColumnResult(name = "lastActiveTime", type = LocalDateTime.class)
                                }
                        )
                }
        )
})








@Data
@Entity
@Table(name = "Customer")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @Column(name = "name")
    private String name;

    @NotNull
    @Column(name = "address")
    private String address;

    @NotNull
    @Column(name = "phoneNumber")
    private String phoneNumber;

    @NotNull
    @Column(name = "accumulatedPoints")
    private Integer accumulatedPoints;
}
