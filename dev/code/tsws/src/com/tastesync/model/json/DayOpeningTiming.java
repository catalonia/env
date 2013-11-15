package com.tastesync.model.json;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class DayOpeningTiming {
    private List<List<String>> monday = new ArrayList<List<String>>();
    private List<List<String>> tuesday = new ArrayList<List<String>>();
    private List<List<String>> wednesday = new ArrayList<List<String>>();
    private List<List<String>> thursday = new ArrayList<List<String>>();
    private List<List<String>> friday = new ArrayList<List<String>>();
    private List<List<String>> saturday = new ArrayList<List<String>>();
    private List<List<String>> sunday = new ArrayList<List<String>>();
    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    public List<List<String>> getMonday() {
        return monday;
    }

    public void setMonday(List<List<String>> monday) {
        this.monday = monday;
    }

    public DayOpeningTiming withMonday(List<List<String>> monday) {
        this.monday = monday;

        return this;
    }

    public List<List<String>> getTuesday() {
        return tuesday;
    }

    public void setTuesday(List<List<String>> tuesday) {
        this.tuesday = tuesday;
    }

    public DayOpeningTiming withTuesday(List<List<String>> tuesday) {
        this.tuesday = tuesday;

        return this;
    }

    public List<List<String>> getWednesday() {
        return wednesday;
    }

    public void setWednesday(List<List<String>> wednesday) {
        this.wednesday = wednesday;
    }

    public DayOpeningTiming withWednesday(List<List<String>> wednesday) {
        this.wednesday = wednesday;

        return this;
    }

    public List<List<String>> getThursday() {
        return thursday;
    }

    public void setThursday(List<List<String>> thursday) {
        this.thursday = thursday;
    }

    public DayOpeningTiming withThursday(List<List<String>> thursday) {
        this.thursday = thursday;

        return this;
    }

    public List<List<String>> getFriday() {
        return friday;
    }

    public void setFriday(List<List<String>> friday) {
        this.friday = friday;
    }

    public DayOpeningTiming withFriday(List<List<String>> friday) {
        this.friday = friday;

        return this;
    }

    public List<List<String>> getSaturday() {
        return saturday;
    }

    public void setSaturday(List<List<String>> saturday) {
        this.saturday = saturday;
    }

    public DayOpeningTiming withSaturday(List<List<String>> saturday) {
        this.saturday = saturday;

        return this;
    }

    public List<List<String>> getSunday() {
        return sunday;
    }

    public void setSunday(List<List<String>> sunday) {
        this.sunday = sunday;
    }

    public DayOpeningTiming withSunday(List<List<String>> sunday) {
        this.sunday = sunday;

        return this;
    }

    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperties(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

	@Override
	public String toString() {
		return "DayOpeningTiming [monday=" + monday + ", tuesday=" + tuesday
				+ ", wednesday=" + wednesday + ", thursday=" + thursday
				+ ", friday=" + friday + ", saturday=" + saturday + ", sunday="
				+ sunday + ", additionalProperties=" + additionalProperties
				+ "]";
	}
    
}
