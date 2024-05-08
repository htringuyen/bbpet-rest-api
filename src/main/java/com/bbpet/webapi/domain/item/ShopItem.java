package com.bbpet.webapi.domain.item;

import com.bbpet.webapi.domain.Staging;
import com.bbpet.webapi.domain.shopping.OrderItem;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
@Entity
@Table(name = "ShopItem")
public class ShopItem {

    public enum Type {
        PRODUCT,
        SERVICE
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @NotNull
    @Column(name = "name")
    private String name;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private Type type;

    @NotNull
    @Column(name = "price")
    private Double price;
}
