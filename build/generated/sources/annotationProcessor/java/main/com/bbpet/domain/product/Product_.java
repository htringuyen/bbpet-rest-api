package com.bbpet.domain.product;

import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Product.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class Product_ {

	public static final String NAME = "name";
	public static final String ID = "id";

	
	/**
	 * @see com.bbpet.domain.product.Product#name
	 **/
	public static volatile SingularAttribute<Product, String> name;
	
	/**
	 * @see com.bbpet.domain.product.Product#id
	 **/
	public static volatile SingularAttribute<Product, Long> id;
	
	/**
	 * @see com.bbpet.domain.product.Product
	 **/
	public static volatile EntityType<Product> class_;

}

