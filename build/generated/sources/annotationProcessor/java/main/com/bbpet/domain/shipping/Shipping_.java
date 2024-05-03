package com.bbpet.domain.shipping;

import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Shipping.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class Shipping_ {

	public static final String ID = "id";
	public static final String STATUS = "status";

	
	/**
	 * @see com.bbpet.domain.shipping.Shipping#id
	 **/
	public static volatile SingularAttribute<Shipping, Long> id;
	
	/**
	 * @see com.bbpet.domain.shipping.Shipping
	 **/
	public static volatile EntityType<Shipping> class_;
	
	/**
	 * @see com.bbpet.domain.shipping.Shipping#status
	 **/
	public static volatile SingularAttribute<Shipping, String> status;

}

