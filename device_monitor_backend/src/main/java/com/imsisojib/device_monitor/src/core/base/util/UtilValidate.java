package com.imsisojib.device_monitor.src.core.base.util;

import com.imsisojib.device_monitor.src.core.base.model.MetaModel;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.springframework.stereotype.Component;

import javax.persistence.Transient;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;

@Component
public class UtilValidate {

    public static boolean noData(String txt) {
        if (null == txt || txt.trim().isEmpty() || txt.equals("null") || txt.equalsIgnoreCase("null")) return true;
        return false;
    }

    public static boolean noData(Boolean b) {
        return b == null || !b;
    }

    public static boolean noData(Object obj) {
        return obj == null;
    }

    public static boolean noData(Collection<?> c) {
        return c == null || c.isEmpty();
    }

    public boolean isTransient(Class<?> clz, String fieldName) {
        if (new ArrayList<>(Arrays.asList(FieldUtils.getFieldsWithAnnotation(clz, Transient.class))).stream().anyMatch(x -> x.getName().equalsIgnoreCase(fieldName))) return true;
        return false;
    }

    /**
     * @param number
     * @return true if number is grater than equal 0
     */
    public boolean isPositiveNumber(Integer number) {
        if (!noData(number) && number>=0) return true;
        return false;
    }
    public boolean isPositiveNumber(Long number) {
        if (!noData(number) && number>=0) return true;
        return false;
    }
    public boolean isPositiveNumber(Float number) {
        if (!noData(number) && number>=0) return true;
        return false;
    }
    public boolean isPositiveNumber(Double number) {
        if (!noData(number) && number>=0) return true;
        return false;
    }

    /**
     * @param number
     * @return true if number is grater than 0
     */
    public boolean isNonZeroPositiveNumber(Integer number) {
        if (!noData(number) && number>0) return true;
        return false;
    }
    public boolean isNonZeroPositiveNumber(Long number) {
        if (!noData(number) && number>0) return true;
        return false;
    }
    public boolean isNonZeroPositiveNumber(Float number) {
        if (!noData(number) && number>0) return true;
        return false;
    }
    public boolean isNonZeroPositiveNumber(Double number) {
        if (!noData(number) && number>0) return true;
        return false;
    }

//    public boolean isValidMeta(MetaModel meta) {
//        return !noData(meta) && !noData(meta.getLimit()) && !noData(meta.getPage());
//    }

    public boolean isValidDateRange(Date fromDate, Date toDate) {
        return null != fromDate && null != toDate && toDate.after(fromDate);
    }
}