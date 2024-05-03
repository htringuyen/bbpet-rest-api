package com.bbpet.webapi.services.dbexpose;

import java.util.List;
import java.util.Map;

public interface PlainEntityTableService {

    List<Map<String, String>> findAllByParams(
            Map<String, String> params, Class<?> entityClass);

    int updateRow(Object id, Map<String, String> params, Class<?> entityClass);

    int createRow(Map<String, String> params, Class<?> entityClass);

    int deleteRow(Object id, Class<?> entityClass);
}
