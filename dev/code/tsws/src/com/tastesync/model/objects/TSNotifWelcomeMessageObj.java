package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "notifwelcomemessage")
public class TSNotifWelcomeMessageObj implements Serializable {
    private static final long serialVersionUID = 2339164809458780956L;
    private String message;
    private String unreadCounter;

    public TSNotifWelcomeMessageObj() {
        super();
    }

    @XmlElement
    public String getMessage() {
        return message;
    }

    @XmlElement
    public String getUnreadCounter() {
        return unreadCounter;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
