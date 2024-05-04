package com.bbpet.webapi.domain.svact;

public enum ServiceActivityStatus {

    // each enum constant is associated with a stage in int which present the real-world stage ordinal of the service activity
    PENDING(1),
    IN_PROGRESS(2),
    COMPLETED(3),
    CANCELLED(3);

    private final int stage;

    ServiceActivityStatus(int stage) {
        this.stage = stage;
    }

    public int getStage() {
        return stage;
    }
}
