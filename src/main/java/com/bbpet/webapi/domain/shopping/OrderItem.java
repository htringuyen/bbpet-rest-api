package com.bbpet.webapi.domain.shopping;

import com.bbpet.webapi.domain.item.ShopItem;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "OrderItem")
public class OrderItem {

    public enum Type {PRODUCT, SERVICE}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "orderId")
    private Order order;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "shopItemId")
    private ShopItem shopItem;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private Type type;

    @NotNull
    @Column(name = "priceEach")
    private Double priceEach;

    @NotNull
    @Column(name = "quantity")
    private Integer quantity;

    @NotNull
    @Column(name = "discount")
    private Double discount;

    @OneToOne
    @JoinColumn(name = "sourcingId")
    private Sourcing sourcing;

    @ManyToOne
    @JoinColumn(name = "deliveryId")
    private Delivery delivery;
}


































