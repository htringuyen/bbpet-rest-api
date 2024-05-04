package com.bbpet.webapi.repos;

import com.bbpet.webapi.domain.order.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {

}
