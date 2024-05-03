package com.bbpet.webapi.services.dbexpose;

import jakarta.persistence.metamodel.Attribute;
import jakarta.persistence.metamodel.EntityType;

import java.util.*;

public class PlainEntityTableImpl implements PlainEntityTable {

    private final Class<?> entityClass;

    private final String idAttributeName;

    private final String tableName;

    private final String schema;

    private final List<PlainEntityColumn> columns;

    public PlainEntityTableImpl(String tableName, String schema, Class<?> entityClass, String idAttributeName, List<PlainEntityColumn> columns) {
        this.tableName = tableName;
        this.schema = schema;
        this.entityClass = entityClass;
        this.idAttributeName = idAttributeName;
        this.columns = columns;
    }

    @Override
    public Class<?> getEntityClass() {
        return entityClass;
    }

    private <X> Attribute<? super X, ?> getAttributeFrom(EntityType<X> entityType, String attrName) {
        try {
            return entityType.getAttribute(attrName);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    @Override
    public Optional<PlainEntityColumn> getPlainColumn(String columnName) {
        for (var column: columns) {
            if (column.getColumnName().equals(columnName)) {
                return Optional.of(column);
            }
        }
        return Optional.empty();
    }

    @Override
    public List<PlainEntityColumn> getPlainColumns() {
        return columns;
    }

    @Override
    public String getTableName() {
        return tableName;
    }

    @Override
    public String getSchema() {
        return schema;
    }

    @Override
    public Map<String, String> createStringRowMap(Object[] values) {
        if (values.length != columns.size()) {
            throw new IllegalStateException("Size of value array not equals to number of columns");
        }

        var result = new LinkedHashMap<String, String>();
        for (int i = 0; i  < columns.size(); i++) {
            result.put(columns.get(i).getColumnName(), values[i].toString());
        }
        return result;
    }

    @Override
    public String getIdAttributeName() {
        return idAttributeName;
    }






}





























