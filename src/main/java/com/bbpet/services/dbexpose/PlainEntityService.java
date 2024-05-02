package com.bbpet.services.dbexpose;

import com.bbpet.domain.PlainEntity;

import java.util.List;
import java.util.Map;

public interface PlainEntityService {

    List<? extends PlainEntity> findAllByParams(Map<String, String> params);


}
