package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;

import java.util.List;

public class TSInitObj implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private List<TSGlobalObj> cuisine1;
	private List<TSGlobalObj> cuisine2;
	private List<TSGlobalObj> occasion;
	private List<TSGlobalObj> price;
	private List<TSGlobalObj> theme;
	private List<TSGlobalObj> typeOfRestaurant;
	private List<TSGlobalObj> whoAreYou;
	
	@XmlElement
	public List<TSGlobalObj> getCuisine1() {
		return cuisine1;
	}
	
	public void setCuisine1(List<TSGlobalObj> cuisine1) {
		this.cuisine1 = cuisine1;
	}
	
	@XmlElement
	public List<TSGlobalObj> getCuisine2() {
		return cuisine2;
	}
	
	public void setCuisine2(List<TSGlobalObj> cuisine2) {
		this.cuisine2 = cuisine2;
	}
	
	@XmlElement
	public List<TSGlobalObj> getOccasion() {
		return occasion;
	}
	
	public void setOccasion(List<TSGlobalObj> occasion) {
		this.occasion = occasion;
	}
	
	@XmlElement
	public List<TSGlobalObj> getPrice() {
		return price;
	}
	
	public void setPrice(List<TSGlobalObj> price) {
		this.price = price;
	}
	
	@XmlElement
	public List<TSGlobalObj> getTheme() {
		return theme;
	}
	
	public void setTheme(List<TSGlobalObj> theme) {
		this.theme = theme;
	}
	
	@XmlElement
	public List<TSGlobalObj> getTypeOfRestaurant() {
		return typeOfRestaurant;
	}
	
	public void setTypeOfRestaurant(List<TSGlobalObj> typeOfRestaurant) {
		this.typeOfRestaurant = typeOfRestaurant;
	}
	
	@XmlElement
	public List<TSGlobalObj> getWhoAreYou() {
		return whoAreYou;
	}
	
	public void setWhoAreYou(List<TSGlobalObj> whoAreYou) {
		this.whoAreYou = whoAreYou;
	}
	
}

