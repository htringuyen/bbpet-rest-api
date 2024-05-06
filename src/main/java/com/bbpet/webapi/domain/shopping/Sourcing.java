package com.bbpet.webapi.domain.shopping;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "Sourcing")
public class Sourcing {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @Column(name = "available")
    private Boolean available;

    @Column(name = "reason")
    private String reason;
}
