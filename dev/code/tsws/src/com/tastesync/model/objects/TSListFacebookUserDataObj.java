package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "list_user_profile_fb")
public class TSListFacebookUserDataObj implements Serializable {
    private static final long serialVersionUID = 1L;
    private String device_token;
    private String fbAccessToken;

    public TSListFacebookUserDataObj() {
    }

    @XmlElement(name = "devicetoken")
    public String getDevice_token() {
        return device_token;
    }

    @XmlElement(name = "fbAccessToken")
    public String getFbAccessToken() {
        return fbAccessToken;
    }

    public void setDevice_token(String device_token) {
        this.device_token = device_token;
    }

    public void setFbAccessToken(String fbAccessToken) {
        this.fbAccessToken = fbAccessToken;
    }

    @Override
    public String toString() {
        return "TSListFacebookUserDataObj [ device_token=" + device_token +
        ", fbAccessToken=" + fbAccessToken + "]";
    }
}
