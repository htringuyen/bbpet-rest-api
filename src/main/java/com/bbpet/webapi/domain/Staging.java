package com.bbpet.webapi.domain;

import java.util.List;

public interface Staging<T extends Staging<T>> {

    boolean isTerminated();

    int getOrder();

    boolean isPrioritized();

    List<T> getStages();


    default boolean mayAdvanceTo(T next) {
        return !this.isTerminated() && this.getOrder() < next.getOrder();
    }

    default T getNext() {

        if (this.isTerminated()) {
            throw new IllegalStateException("The staging has terminated at this point: " + this);
        }

        var nextStagesByOrder = getStages().stream()
                .filter(s -> s.getOrder() == this.getOrder() + 1 && s.isPrioritized())
                .toList();

        if (nextStagesByOrder.size() != 1) {
            throw new IllegalStateException(
                    "Cannot get next stage there are " + nextStagesByOrder.size() + " available");
        }

        return nextStagesByOrder.getFirst();
    }
}
