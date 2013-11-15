package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifmessageforyou")
public class TSNotifMessageForYouObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = 2332617623513816906L;
    private String messageId;
    private String messageCreatedTime;
    private String viewed;
    private String actioned;
    private TSUserProfileBasicObj senderUser;
    private String message;

    public TSNotifMessageForYouObj() {
        super();

    }

    @XmlElement
    public String getMessageId() {
        return messageId;
    }

    @XmlElement
    public String getMessageCreatedTime() {
        return messageCreatedTime;
    }

    @XmlElement
    public String getViewed() {
        return viewed;
    }

    @XmlElement
    public String getActioned() {
        return actioned;
    }

    @XmlElement
    public TSUserProfileBasicObj getSenderUser() {
        return senderUser;
    }

    @XmlElement
    public String getMessage() {
        return message;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    public void setMessageCreatedTime(String messageCreatedTime) {
        this.messageCreatedTime = messageCreatedTime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public void setActioned(String actioned) {
        this.actioned = actioned;
    }

    public void setSenderUser(TSUserProfileBasicObj senderUser) {
        this.senderUser = senderUser;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
