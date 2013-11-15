package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifrecorequestneeded")
public class TSNotifRecorequestNeededObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = -435811295301468750L;
    private String recorequestId;
    private String assignedDatetime;
    private String recorequestassignedViewed;
    private String recorequestassignedActioned;
    private TSUserProfileBasicObj recommendeeUser;
    private String recorequestText;

    public TSNotifRecorequestNeededObj() {
        super();
    }

    @XmlElement
    public String getRecorequestId() {
        return recorequestId;
    }

    @XmlElement
    public String getAssignedDatetime() {
        return assignedDatetime;
    }

    @XmlElement
    public String getRecorequestassignedViewed() {
        return recorequestassignedViewed;
    }

    @XmlElement
    public String getRecorequestassignedActioned() {
        return recorequestassignedActioned;
    }

    @XmlElement
    public TSUserProfileBasicObj getRecommendeeUser() {
        return recommendeeUser;
    }

    @XmlElement
    public String getRecorequestText() {
        return recorequestText;
    }

    public void setRecorequestId(String recorequestId) {
        this.recorequestId = recorequestId;
    }

    public void setAssignedDatetime(String assignedDatetime) {
        this.assignedDatetime = assignedDatetime;
    }

    public void setRecorequestassignedViewed(String recorequestassignedViewed) {
        this.recorequestassignedViewed = recorequestassignedViewed;
    }

    public void setRecorequestassignedActioned(String recorequestassignedActioned) {
        this.recorequestassignedActioned = recorequestassignedActioned;
    }

    public void setRecommendeeUser(TSUserProfileBasicObj recommendeeUser) {
        this.recommendeeUser = recommendeeUser;
    }

    public void setRecorequestText(String recorequestText) {
        this.recorequestText = recorequestText;
    }
}
