package com.bbpet.webapi.repos;

import com.bbpet.webapi.domain.shopping.OrderItem;
import com.bbpet.webapi.domain.shopping.OrderItemView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {


    @Query(value = """
                SELECT new com.bbpet.webapi.domain.shopping.OrderItemView(
                    oi.id,
                    od.id,
                    oi.type,
                    si.name,
                    oi.quantity,
                    oi.priceEach,
                    oi.discount,
                    dv.id,
                    dv.status)
                FROM OrderItem oi
                JOIN oi.order od
                JOIN oi.shopItem si
                JOIN oi.delivery dv
                WHERE od.id = :orderId
                """)
    List<OrderItemView> findByOrderId(@Param("orderId") Long orderId);
}
