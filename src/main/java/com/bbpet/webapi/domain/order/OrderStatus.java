package com.bbpet.webapi.domain.order;

public enum OrderStatus {

    CREATING(1),

    PENDING(2),

    CONFIRMED(3),

    SUCCESS(4)
    ;

    private final int ordinal;

    OrderStatus(int ordinal) {
        this.ordinal = ordinal;
    }

    public int getOrdinal() {
        return ordinal;
    }

}
