package com.bbpet.webapi.domain.shopping;

import com.bbpet.webapi.domain.Staging;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Data
@Entity
@Table(name = "Delivery")
public class Delivery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Status status;

    @NotNull
    @Column(name = "startTime")
    private LocalDateTime startTime;

    @NotNull
    @Column(name = "endTime")
    private LocalDateTime endTime;

    @Column(name = "reason")
    private String reason;


    /**
     * Status of Delivery and the flow of status
     */
    enum Status implements Staging<Status> {

        PENDING(1, false, true),

        IN_PROGRESS(2, false, true),

        SUCCESS(3, true, true),

        FAILED(3, true, false)
        ;

        private final int order;

        private final boolean terminated;

        private final boolean prioritized;

        Status(int order, boolean terminated, boolean prioritized) {
            this.order = order;
            this.terminated = terminated;
            this.prioritized = prioritized;
        }


        @Override
        public int getOrder() {
            return order;
        }

        @Override
        public boolean isTerminated() {
            return terminated;
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


































