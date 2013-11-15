package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notiffollowupquestion")
public class TSNotifFollowupQuestionObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = -5841007147194904300L;
    private String questionId;
    private String assignedDatetime;
    private String viewed;
    private String actioned;
    private TSUserProfileBasicObj questionUser;
    private String questionText;

    public TSNotifFollowupQuestionObj() {
        super();
    }

    @XmlElement
    public String getQuestionId() {
        return questionId;
    }

    @XmlElement
    public String getAssignedDatetime() {
        return assignedDatetime;
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
    public TSUserProfileBasicObj getQuestionUser() {
        return questionUser;
    }

    @XmlElement
    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public void setAssignedDatetime(String assignedDatetime) {
        this.assignedDatetime = assignedDatetime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public void setActioned(String actioned) {
        this.actioned = actioned;
    }

    public void setQuestionUser(TSUserProfileBasicObj questionUser) {
        this.questionUser = questionUser;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
}
