package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.OrderItemView;
import com.bbpet.webapi.domain.shopping.OrderView;

import java.util.List;

public interface OrderItemService {

    List<OrderItemView> findViewsByOrder(Long orderId);
}
