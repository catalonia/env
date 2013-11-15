package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;

public class TSListPrivacySettingsObj implements Serializable{

	private static final long serialVersionUID = 1L;

    private String userId;
    private TSPrivacySettingsObj[] privacy;//displayLink;
    
    @XmlElement
	public String getUserId() {
		return userId;
	}
    
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	@XmlElement
	public TSPrivacySettingsObj[] getPrivacy() {
		return privacy;
	}

	public void setPrivacy(TSPrivacySettingsObj[] privacy) {
		this.privacy = privacy;
	}
	

}
