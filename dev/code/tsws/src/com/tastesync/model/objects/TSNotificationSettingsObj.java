package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "notifications")
public class TSNotificationSettingsObj implements Serializable {
    private static final long serialVersionUID = 5547698257718238717L;
    private String order_id;
    private String phoneFlag;
    private String emailFlag;
    
    @XmlElement
	public String getOrder_id() {
		return order_id;
	}
    
    @XmlElement
    public String getPhoneFlag() {
        return phoneFlag;
    }

    @XmlElement
    public String getEmailFlag() {
        return emailFlag;
    }

    public void setPhoneFlag(String phoneFlag) {
        this.phoneFlag = phoneFlag;
    }

    public void setEmailFlag(String emailFlag) {
        this.emailFlag = emailFlag;
    }

	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}

}
