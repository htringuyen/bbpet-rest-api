package com.bbpet.webapi.domain.shopping;

import com.bbpet.webapi.domain.Staging;
import com.bbpet.webapi.domain.customer.Customer;
import com.bbpet.webapi.domain.employee.Employee;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

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




















































