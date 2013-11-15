package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "recosfollowup")
public class TSRecommendationsFollowupObj implements Serializable {
    private static final long serialVersionUID = 4996052609815336144L;
    private TSUserProfileBasicObj questionUser;
    private String questionText;
    private String questionUserFolloweeFlag;
    private TSRestaurantObj questionRestaurant;
    private String unreadCounter;

    @XmlElement
    public String getUnreadCounter() {
        return unreadCounter;
    }

    @XmlElement
    public TSUserProfileBasicObj getQuestionUser() {
        return questionUser;
    }

    @XmlElement
    public String getQuestionText() {
        return questionText;
    }

    @XmlElement
    public String getQuestionUserFolloweeFlag() {
        return questionUserFolloweeFlag;
    }

    @XmlElement
    public TSRestaurantObj getQuestionRestaurant() {
        return questionRestaurant;
    }

    public void setQuestionUser(TSUserProfileBasicObj questionUser) {
        this.questionUser = questionUser;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public void setQuestionUserFolloweeFlag(String questionUserFolloweeFlag) {
        this.questionUserFolloweeFlag = questionUserFolloweeFlag;
    }

    public void setQuestionRestaurant(TSRestaurantObj questionRestaurant) {
        this.questionRestaurant = questionRestaurant;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
