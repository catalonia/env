package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "initdata")
public class TSInitDataObj implements Serializable {
    private static final long serialVersionUID = -2237639625417579167L;
    private List<TSInitDescriptorDataObj> ambience;
    private List<TSInitDescriptorDataObj> cuisine1;
    private List<TSInitDescriptorDataObj> cuisine2;
    private List<TSInitDescriptorDataObj> price;
    private List<TSInitDescriptorDataObj> whoAreYou;

    public TSInitDataObj() {
        super();
    }

    @XmlElement
    public List<TSInitDescriptorDataObj> getAmbience() {
        return ambience;
    }

    @XmlElement
    public List<TSInitDescriptorDataObj> getCuisine1() {
        return cuisine1;
    }

    @XmlElement
    public List<TSInitDescriptorDataObj> getCuisine2() {
        return cuisine2;
    }

    @XmlElement
    public List<TSInitDescriptorDataObj> getPrice() {
        return price;
    }

    @XmlElement
    public List<TSInitDescriptorDataObj> getWhoAreYou() {
        return whoAreYou;
    }

    public void setAmbience(List<TSInitDescriptorDataObj> ambience) {
        this.ambience = ambience;
    }

    public void setCuisine1(List<TSInitDescriptorDataObj> cuisine1) {
        this.cuisine1 = cuisine1;
    }

    public void setCuisine2(List<TSInitDescriptorDataObj> cuisine2) {
        this.cuisine2 = cuisine2;
    }

    public void setPrice(List<TSInitDescriptorDataObj> price) {
        this.price = price;
    }

    public void setWhoAreYou(List<TSInitDescriptorDataObj> whoAreYou) {
        this.whoAreYou = whoAreYou;
    }
}
