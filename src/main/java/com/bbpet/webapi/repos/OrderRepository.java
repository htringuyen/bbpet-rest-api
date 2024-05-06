package com.bbpet.webapi.repos;

import com.bbpet.webapi.domain.shopping.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

}
