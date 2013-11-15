package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "menu")
public class TSMenuObj implements Serializable {

	private static final long serialVersionUID = 2102340212375291293L;

	private String restaurantId;
	private String menuSource;
	private String menuMobileUrl;
	@XmlElement
	public String getRestaurantId() {
		return restaurantId;
	}
	@XmlElement
	public String getMenuSource() {
		return menuSource;
	}
	@XmlElement
	public String getMenuMobileUrl() {
		return menuMobileUrl;
	}
	public void setRestaurantId(String restaurantId) {
		this.restaurantId = restaurantId;
	}
	public void setMenuSource(String menuSource) {
		this.menuSource = menuSource;
	}
	public void setMenuMobileUrl(String menuMobileUrl) {
		this.menuMobileUrl = menuMobileUrl;
	}
	
	
}
