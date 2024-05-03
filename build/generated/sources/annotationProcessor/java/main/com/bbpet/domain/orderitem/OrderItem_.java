package com.bbpet.domain.orderitem;

import com.bbpet.domain.order.Order;
import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(OrderItem.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class OrderItem_ {

	public static final String QUANTITY = "quantity";
	public static final String DISCOUNT_PERCENT = "discountPercent";
	public static final String ID = "id";
	public static final String PRICE_EACH = "priceEach";
	public static final String ORDER = "order";

	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem#quantity
	 **/
	public static volatile SingularAttribute<OrderItem, Integer> quantity;
	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem#discountPercent
	 **/
	public static volatile SingularAttribute<OrderItem, Double> discountPercent;
	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem#id
	 **/
	public static volatile SingularAttribute<OrderItem, Long> id;
	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem
	 **/
	public static volatile EntityType<OrderItem> class_;
	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem#priceEach
	 **/
	public static volatile SingularAttribute<OrderItem, Double> priceEach;
	
	/**
	 * @see com.bbpet.domain.orderitem.OrderItem#order
	 **/
	public static volatile SingularAttribute<OrderItem, Order> order;

}

