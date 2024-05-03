package com.bbpet.domain.order;

import com.bbpet.domain.customer.Customer;
import com.bbpet.domain.employee.Employee;
import com.bbpet.domain.orderitem.OrderItem;
import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.time.LocalDateTime;

@StaticMetamodel(Order.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class Order_ {

	public static final String DELIVERY_ADDRESS = "deliveryAddress";
	public static final String CREATED_TIME = "createdTime";
	public static final String MAPPING_ORDER_VIEW_RESULT = "orderViewResult";
	public static final String ID = "id";
	public static final String EMPLOYEE = "employee";
	public static final String ORDER_ITEMS = "orderItems";
	public static final String STATUS = "status";
	public static final String CUSTOMER = "customer";

	
	/**
	 * @see com.bbpet.domain.order.Order#deliveryAddress
	 **/
	public static volatile SingularAttribute<Order, String> deliveryAddress;
	
	/**
	 * @see com.bbpet.domain.order.Order#createdTime
	 **/
	public static volatile SingularAttribute<Order, LocalDateTime> createdTime;
	
	/**
	 * @see com.bbpet.domain.order.Order#id
	 **/
	public static volatile SingularAttribute<Order, Long> id;
	
	/**
	 * @see com.bbpet.domain.order.Order#employee
	 **/
	public static volatile SingularAttribute<Order, Employee> employee;
	
	/**
	 * @see com.bbpet.domain.order.Order
	 **/
	public static volatile EntityType<Order> class_;
	
	/**
	 * @see com.bbpet.domain.order.Order#orderItems
	 **/
	public static volatile ListAttribute<Order, OrderItem> orderItems;
	
	/**
	 * @see com.bbpet.domain.order.Order#status
	 **/
	public static volatile SingularAttribute<Order, String> status;
	
	/**
	 * @see com.bbpet.domain.order.Order#customer
	 **/
	public static volatile SingularAttribute<Order, Customer> customer;

}

