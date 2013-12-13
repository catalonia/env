package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "notifwelcomemessageforyou")
public class TSNotifWelcomeMessageForYouObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = 8962312587528246273L;
    private String createdDatetime;
    private String viewed;
    private String welcomemessage;

    public TSNotifWelcomeMessageForYouObj() {
        super();
    }

    @XmlElement
    public String getCreatedDatetime() {
        return createdDatetime;
    }

    @XmlElement
    public String getViewed() {
        return viewed;
    }

    @XmlElement
    public String getWelcomemessage() {
        return welcomemessage;
    }

    public void setCreatedDatetime(String createdDatetime) {
        this.createdDatetime = createdDatetime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public void setWelcomemessage(String welcomemessage) {
        this.welcomemessage = welcomemessage;
    }
}
