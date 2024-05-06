package com.bbpet.webapi.services.shopping;

import com.bbpet.webapi.domain.shopping.OrderItemView;
import com.bbpet.webapi.repos.OrderItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class OrderItemServiceImpl implements OrderItemService {

    private final OrderItemRepository orderItemRepository;

    public OrderItemServiceImpl(OrderItemRepository orderItemRepository) {
        this.orderItemRepository = orderItemRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<OrderItemView> findViewsByOrder(Long orderId) {
        return orderItemRepository.findByOrderId(orderId);
    }

}
