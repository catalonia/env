package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;


public class TSCuisineTier2Obj implements Serializable {
    private static final long serialVersionUID = -3628983920237320436L;
    private String cuisineId;
    private String cuisineDesc;
    private String cuisineValidCurrent;

    @XmlElement
    public String getCuisineId() {
        return cuisineId;
    }

    @XmlElement
    public String getCuisineDesc() {
        return cuisineDesc;
    }

    @XmlElement
    public String getCuisineValidCurrent() {
        return cuisineValidCurrent;
    }

    public void setCuisineId(String cuisineId) {
        this.cuisineId = cuisineId;
    }

    public void setCuisineDesc(String cuisineDesc) {
        this.cuisineDesc = cuisineDesc;
    }

    public void setCuisineValidCurrent(String cuisineValidCurrent) {
        this.cuisineValidCurrent = cuisineValidCurrent;
    }
}
