package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


//@XmlRootElement(name = "restauranttipsapsettings")
public class TSRestaurantTipsAPSettingsObj implements Serializable {
    private static final long serialVersionUID = -3475916144296389812L;
    private String userId;
    private String autoPublishingSetting;
    private APSETTINGTYPE apSettingType;

    @XmlElement
    public String getUserId() {
        return userId;
    }

    @XmlElement
    public String getAutoPublishingSetting() {
        return autoPublishingSetting;
    }

    @XmlElement
    public APSETTINGTYPE getApSettingType() {
        return apSettingType;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setAutoPublishingSetting(String autoPublishingSetting) {
        this.autoPublishingSetting = autoPublishingSetting;
    }

    public void setApSettingType(APSETTINGTYPE apSettingType) {
        this.apSettingType = apSettingType;
    }
    public enum APSETTINGTYPE {FACEBOOK,
        TWITTER
    }
}
