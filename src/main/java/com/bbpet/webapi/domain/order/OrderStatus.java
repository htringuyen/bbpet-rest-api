package com.bbpet.webapi.domain.order;

public enum OrderStatus {

    CREATING(1),

    PENDING(2),

    CONFIRMED(3),

    NOT_ACCEPTED(3),

    SUCCESS(4),
    CANCELED(4),
    ;

    private final int stage;

    OrderStatus(int stage) {
        this.stage = stage;
    }

    public int getStage() {
        return stage;
    }
}
