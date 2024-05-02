package com.bbpet.domain.orderitem;

import com.bbpet.domain.order.Order;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(schema = "orderman", name = "OrderItem")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    protected Long id;

    @Column(name = "quantity")
    protected Integer quantity;

    @Column(name = "priceEach")
    protected Double priceEach;

    @Column(name = "discountPercent")
    protected Double discountPercent;

    @ManyToOne(optional = false)
    @JoinColumn(name = "orderId")
    protected Order order;
}
