package com.tastesync.model.objects;

import java.io.Serializable;
import java.util.List;

import com.sun.xml.txw2.annotation.XmlElement;

public class TSAskSubmitLoginObj implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String cuisineId;
	private List<String> restaurandId;
	private String facebookFriendId;
	
	@XmlElement
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	@XmlElement
	public String getCuisineId() {
		return cuisineId;
	}
	
	public void setCuisineId(String cuisineId) {
		this.cuisineId = cuisineId;
	}
	
	@XmlElement
	public List<String> getRestaurandId() {
		return restaurandId;
	}
	
	public void setRestaurandId(List<String> restaurandId) {
		this.restaurandId = restaurandId;
	}
	
	@XmlElement
	public String getFacebookFriendId() {
		return facebookFriendId;
	}
	
	public void setFacebookFriendId(String facebookFriendId) {
		this.facebookFriendId = facebookFriendId;
	}
}
