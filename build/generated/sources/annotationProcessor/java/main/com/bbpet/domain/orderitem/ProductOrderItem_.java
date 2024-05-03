package com.bbpet.domain.orderitem;

import com.bbpet.domain.product.Product;
import com.bbpet.domain.shipping.Shipping;
import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(ProductOrderItem.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class ProductOrderItem_ extends com.bbpet.domain.orderitem.OrderItem_ {

	public static final String PRODUCT = "product";
	public static final String SHIPPING = "shipping";

	
	/**
	 * @see com.bbpet.domain.orderitem.ProductOrderItem#product
	 **/
	public static volatile SingularAttribute<ProductOrderItem, Product> product;
	
	/**
	 * @see com.bbpet.domain.orderitem.ProductOrderItem#shipping
	 **/
	public static volatile SingularAttribute<ProductOrderItem, Shipping> shipping;
	
	/**
	 * @see com.bbpet.domain.orderitem.ProductOrderItem
	 **/
	public static volatile EntityType<ProductOrderItem> class_;

}

