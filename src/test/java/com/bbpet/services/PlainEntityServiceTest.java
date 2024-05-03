package com.bbpet.services;

import com.bbpet.TransactionCfg;
import com.bbpet.services.dbexpose.PlainOrderService;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.util.HashMap;

@SpringJUnitConfig(classes = {TransactionCfg.class})
public class PlainEntityServiceTest {
    private static final Logger LOGGER = LoggerFactory.getLogger(PlainEntityServiceTest.class);

    @Autowired
    @Qualifier("plainOrderService")
    private PlainOrderService plainOrderService;

    @Test
    public void testFindAllByParams() {
        var paramMap = new HashMap<String, String>();
        paramMap.put("customerId", "2");
        plainOrderService.findAllByParams(paramMap)
                .forEach(plainEntity -> LOGGER.info(plainEntity.toString()));
    }

}
