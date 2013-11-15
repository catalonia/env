package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "senderuser")
public class TSSenderUserObj implements Serializable {
    private static final long serialVersionUID = -7569614338219147221L;
    private TSUserProfileBasicObj senderUser;
    private String senderUserFolloweeFlag;
    private String message;
    private String unreadCounter;

    @XmlElement
    public String getUnreadCounter() {
        return unreadCounter;
    }

    @XmlElement
    public TSUserProfileBasicObj getSenderUser() {
        return senderUser;
    }

    @XmlElement
    public String getSenderUserFolloweeFlag() {
        return senderUserFolloweeFlag;
    }

    @XmlElement
    public String getMessage() {
        return message;
    }

    public void setSenderUser(TSUserProfileBasicObj senderUser) {
        this.senderUser = senderUser;
    }

    public void setSenderUserFolloweeFlag(String senderUserFolloweeFlag) {
        this.senderUserFolloweeFlag = senderUserFolloweeFlag;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
