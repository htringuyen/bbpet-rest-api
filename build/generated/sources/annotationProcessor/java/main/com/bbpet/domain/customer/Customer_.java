package com.bbpet.domain.customer;

import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Customer.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class Customer_ {

	public static final String NAME = "name";
	public static final String ID = "id";

	
	/**
	 * @see com.bbpet.domain.customer.Customer#name
	 **/
	public static volatile SingularAttribute<Customer, String> name;
	
	/**
	 * @see com.bbpet.domain.customer.Customer#id
	 **/
	public static volatile SingularAttribute<Customer, Long> id;
	
	/**
	 * @see com.bbpet.domain.customer.Customer
	 **/
	public static volatile EntityType<Customer> class_;

}

