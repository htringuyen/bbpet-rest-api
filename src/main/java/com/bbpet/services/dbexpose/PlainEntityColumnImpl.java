package com.bbpet.services.dbexpose;

public class PlainEntityColumnImpl implements PlainEntityColumn {

    private final boolean isJoinColumn;
    private final Class<?> valueType;
    private final String columnName;
    private final String attributeName;
    private final String referenceIdAttributeName;

    public PlainEntityColumnImpl(boolean isJoinColumn, Class<?> valueType, String columnName, String attributeName, String referenceIdAttributeName) {
        this.isJoinColumn = isJoinColumn;
        this.valueType = valueType;
        this.columnName = columnName;
        this.attributeName = attributeName;
        this.referenceIdAttributeName = referenceIdAttributeName;
    }

    @Override
    public boolean isBasicColumn() {
        return !isJoinColumn();
    }

    @Override
    public Class<?> getValueType() {
        return valueType;
    }

    @Override
    public String getColumnName() {
        return columnName;
    }

    @Override
    public boolean isJoinColumn() {
        return isJoinColumn;
    }

    @Override
    public String getAttributeName() {
        return attributeName;
    }

    @Override
    public String getReferenceIdAttributeName() {
        return referenceIdAttributeName;
    }

}
