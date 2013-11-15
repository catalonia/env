package com.tastesync.model.objects.derived;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restbuzztip")
public class TSRestaurantBuzzTipObj implements Serializable {
    private static final long serialVersionUID = -4925873798170019680L;
    private String tipId;
    private String tipSource;
    private String tipUserId;
    private String tipUserFirstName;
    private String tipUserLastName;
    private String tipText;
    private String tipUserPhoto;
    private String tipUserfolloweeFlag;

    public TSRestaurantBuzzTipObj() {
        super();
    }

    @XmlElement
    public String getTipId() {
        return tipId;
    }

    @XmlElement
    public String getTipSource() {
        return tipSource;
    }

    @XmlElement
    public String getTipUserId() {
        return tipUserId;
    }

    @XmlElement
    public String getTipUserFirstName() {
        return tipUserFirstName;
    }

    @XmlElement
    public String getTipUserLastName() {
        return tipUserLastName;
    }

    @XmlElement
    public String getTipText() {
        return tipText;
    }

    @XmlElement
    public String getTipUserPhoto() {
        return tipUserPhoto;
    }

    @XmlElement
    public String getTipUserfolloweeFlag() {
        return tipUserfolloweeFlag;
    }

    public void setTipId(String tipId) {
        this.tipId = tipId;
    }

    public void setTipSource(String tipSource) {
        this.tipSource = tipSource;
    }

    public void setTipUserId(String tipUserId) {
        this.tipUserId = tipUserId;
    }

    public void setTipUserFirstName(String tipUserFirstName) {
        this.tipUserFirstName = tipUserFirstName;
    }

    public void setTipUserLastName(String tipUserLastName) {
        this.tipUserLastName = tipUserLastName;
    }

    public void setTipText(String tipText) {
        this.tipText = tipText;
    }

    public void setTipUserPhoto(String tipUserPhoto) {
        this.tipUserPhoto = tipUserPhoto;
    }

    public void setTipUserfolloweeFlag(String tipUserfolloweeFlag) {
        this.tipUserfolloweeFlag = tipUserfolloweeFlag;
    }
}
