package com.bbpet.services.dbexpose;

import com.bbpet.domain.PlainEntity;
import com.bbpet.domain.order.Order;
import com.bbpet.domain.order.PlainOrder;
import com.bbpet.repos.OrderRepo;
import jakarta.persistence.EntityManager;
import lombok.Data;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Transactional
@Service("plainOrderService")
public class PlainOrderService implements PlainEntityService {

    private final OrderRepo orderRepo;
    private final EntityManager em;

    protected PlainOrderService(OrderRepo orderRepo, EntityManager em) {
        this.orderRepo = orderRepo;
        this.em = em;
    }

    public List<? extends PlainEntity> findAllByParams(Map<String, String> paramMap) {
        var cb = em.getCriteriaBuilder();
        var criteriaQuery = cb.createQuery();
        var orderRoot = criteriaQuery.from(Order.class);
        criteriaQuery.select(orderRoot).distinct(true);

        var criteria = cb.conjunction();
        for (var param: paramMap.entrySet()) {
            var name = param.getKey();
            var value = param.getValue();
            String attributeName = null;
            if ((attributeName = PlainOrder.getCriteriaColumnForParam(name).orElse(null)) != null) {
                var predicate = cb.like(orderRoot.get(attributeName), "%" + value + "%");
                criteria = cb.and(criteria, predicate);
            }

        }

    }
}




































