package com.bbpet.domain.customer;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Customer")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    protected Long id;

    @Column(name = "name")
    protected String name;
}
