package com.bbpet.services.dbexpose;

public interface PlainEntityColumn {

    boolean isJoinColumn();

    boolean isBasicColumn();

    String getColumnName();

    Class<?> getValueType();

    String getAttributeName();

    String getReferenceIdAttributeName();
}
