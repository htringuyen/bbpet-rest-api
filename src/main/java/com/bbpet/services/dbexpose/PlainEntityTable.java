package com.bbpet.services.dbexpose;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface PlainEntityTable {

    Class<?> getEntityClass();

    Optional<PlainEntityColumn> getPlainColumn(String columnName);

    List<PlainEntityColumn> getPlainColumns();

    Map<String, String> createStringRowMap(Object[] values);

    String getIdAttributeName();

    String getTableName();

    String getSchema();

}
