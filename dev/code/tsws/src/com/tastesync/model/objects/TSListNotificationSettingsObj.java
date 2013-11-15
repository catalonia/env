package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "listNotifications")
public class TSListNotificationSettingsObj implements Serializable {
    private static final long serialVersionUID = 1L;
    private String userId;
    private TSNotificationSettingsObj[] notification;
	
    @XmlElement
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	@XmlElement
	public TSNotificationSettingsObj[] getNotification() {
		return notification;
	}

	public void setNotification(TSNotificationSettingsObj[] notification) {
		this.notification = notification;
	}

}