package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "recorequest")
public class TSRecoRequestObj implements Serializable {
    private static final long serialVersionUID = 5456082843562113302L;
    private TSUserProfileBasicObj recommendeeUser;
    private String recorequestText;
    private String recommendeeUserFolloweeFlag;
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
    public String getRecorequestText() {
        return recorequestText;
    }

    @XmlElement
    public String getRecommendeeUserFolloweeFlag() {
        return recommendeeUserFolloweeFlag;
    }

    public void setRecommendeeUser(TSUserProfileBasicObj recommendeeUser) {
        this.recommendeeUser = recommendeeUser;
    }

    public void setRecorequestText(String recorequestText) {
        this.recorequestText = recorequestText;
    }

    public void setRecommendeeUserFolloweeFlag(
        String recommendeeUserFolloweeFlag) {
        this.recommendeeUserFolloweeFlag = recommendeeUserFolloweeFlag;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
