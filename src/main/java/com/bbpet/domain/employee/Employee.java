package com.bbpet.domain.employee;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(schema = "empman", name = "Employee")
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    protected Long id;

    @Column(name = "name")
    protected String name;
}
