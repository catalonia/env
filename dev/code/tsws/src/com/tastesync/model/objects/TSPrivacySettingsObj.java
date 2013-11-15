package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "privacy")
public class TSPrivacySettingsObj implements Serializable {
    private static final long serialVersionUID = 4003350715079988113L;
    
    private String privacy_id_order;
	private String privacy_flag;
	
	@XmlElement
	public String getPrivacy_id_order() {
		return privacy_id_order;
	}
	
	public void setPrivacy_id_order(String privacy_id_order) {
		this.privacy_id_order = privacy_id_order;
	}
	
	@XmlElement
	public String getPrivacy_flag() {
		return privacy_flag;
	}
	
	public void setPrivacy_flag(String privacy_flag) {
		this.privacy_flag = privacy_flag;
	}





}
