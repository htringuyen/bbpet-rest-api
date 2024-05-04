package com.bbpet.webapi.util;

import org.springframework.data.domain.Sort;

public class SortUtils {

    public static Sort parseSort(String strProperties, String strOrders) {
        var sort = Sort.unsorted();

        var sortProperties = strProperties.split(",");
        var sortOrdersArray = new String[sortProperties.length];

        var inputSortOrders = strOrders.split(",");
        for (int i = 0; i < sortProperties.length; i++) {
            if (i < inputSortOrders.length) {
                sortOrdersArray[i] = inputSortOrders[i].strip().equalsIgnoreCase("DESC") ? "DESC" : "ASC";
            } else {
                sortOrdersArray[i] = "ASC";
            }
        }

        for (int i = 0; i < sortProperties.length; i++) {
            sort = sort.and(Sort.by(Sort.Direction.fromString(sortOrdersArray[i]), sortProperties[i].strip()));
        }

        return sort;
    }
}
