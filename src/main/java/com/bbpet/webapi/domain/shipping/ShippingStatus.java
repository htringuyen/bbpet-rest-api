package com.bbpet.webapi.domain.shipping;

public enum ShippingStatus {

    // each enum constant is associated with a stage in int which present the real-world stage ordinal of the shipping process
    PENDING(1),
    SHIPPED(2),
    DELIVERED(3),
    CANCELLED(3);

    private final int stage;

    ShippingStatus(int stage) {
        this.stage = stage;
    }

    public int getStage() {
        return stage;
    }
}
