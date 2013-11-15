package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;

public class TSListSocialSettingObj implements Serializable{
	private static final long serialVersionUID = 1L;
    private String userId;
    private TSSocialSettingsObj[] socialSettings;
    
    @XmlElement
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	@XmlElement
	public TSSocialSettingsObj[] getSocialSettings() {
		return socialSettings;
	}

	public void setSocialSettings(TSSocialSettingsObj[] socialSettings) {
		this.socialSettings = socialSettings;
	}
}
