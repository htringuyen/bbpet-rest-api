package com.bbpet.webapi.domain.orderitem;

import com.bbpet.webapi.domain.product.Product;
import com.bbpet.webapi.domain.shipping.Shipping;
import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@EqualsAndHashCode(callSuper = true)
@Data
@ToString
@Entity
@Table(name = "ProductOrderItem")
public class ProductOrderItem extends OrderItem {

    @ManyToOne
    @JoinColumn(name = "productId")
    protected Product product;

    @ManyToOne
    @JoinColumn(name = "shippingId")
    protected Shipping shipping;
}









































