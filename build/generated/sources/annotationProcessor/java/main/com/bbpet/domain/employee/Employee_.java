package com.bbpet.domain.employee;

import jakarta.annotation.Generated;
import jakarta.persistence.metamodel.EntityType;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Employee.class)
@Generated("org.hibernate.processor.HibernateProcessor")
public abstract class Employee_ {

	public static final String NAME = "name";
	public static final String ID = "id";

	
	/**
	 * @see com.bbpet.domain.employee.Employee#name
	 **/
	public static volatile SingularAttribute<Employee, String> name;
	
	/**
	 * @see com.bbpet.domain.employee.Employee#id
	 **/
	public static volatile SingularAttribute<Employee, Long> id;
	
	/**
	 * @see com.bbpet.domain.employee.Employee
	 **/
	public static volatile EntityType<Employee> class_;

}

