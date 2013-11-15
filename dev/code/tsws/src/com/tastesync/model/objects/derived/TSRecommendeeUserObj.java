package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "recommendeeusers")
public class TSRecommendeeUserObj implements Serializable {
    private static final long serialVersionUID = -2581565894037866670L;
    private TSUserProfileBasicObj recommendeeUser;
    private String replyId;
    private String replyText;
    private String addedPoints;
    private String unreadCounter;

    @XmlElement
    public String getUnreadCounter() {
        return unreadCounter;
    }

    @XmlElement
    public TSUserProfileBasicObj getRecommendeeUser() {
        return recommendeeUser;
    }

    @XmlElement
    public String getReplyId() {
        return replyId;
    }

    @XmlElement
    public String getReplyText() {
        return replyText;
    }

    @XmlElement
    public String getAddedPoints() {
        return addedPoints;
    }

    public void setRecommendeeUser(TSUserProfileBasicObj recommendeeUser) {
        this.recommendeeUser = recommendeeUser;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }

    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public void setAddedPoints(String addedPoints) {
        this.addedPoints = addedPoints;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
