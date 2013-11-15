package com.tastesync.model.objects;

import com.tastesync.util.JsonDateSerializer;

import org.codehaus.jackson.map.annotate.JsonSerialize;

import java.io.Serializable;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;


public class TSRecoNotificationBaseObj implements Serializable {
    private static final long serialVersionUID = 8264952327098167837L;
    private String recoNotificationType;
    private String unreadCounter;

    //TSNotifRecorequestNeededObj
    //TSNotifRecorequestAnswerObj
    //TSNotifFollowupQuestionObj
    //TSNotifMessageForYouObj
    //TSNotifMessageForYouObj
    //TSNotifRecoLikeObj
    //TSNotifDidYouLikeObj
    /**Assigned_datetime, REPLY_SEND_DATETIME, Assigned_datetime, CREATED, like_datetime, notif_datetime*/
    private Date datetimeBase;

    /**RECOREQUEST_ID,  REPLY_ID, QUESTION_ID, MESSAGE_ID, ID, RECOREQUEST_ID*/
    private String idBase;
    private String maxPaginationId;

    public TSRecoNotificationBaseObj() {
        super();
    }

    @XmlElement
    public String getUnreadCounter() {
        return unreadCounter;
    }

    @XmlElement
    public String getMaxPaginationId() {
        return maxPaginationId;
    }

    @XmlElement
    public String getRecoNotificationType() {
        return recoNotificationType;
    }

    @XmlElement
    @JsonSerialize(using = JsonDateSerializer.class)
    public Date getDatetimeBase() {
        return datetimeBase;
    }

    @XmlElement
    public String getIdBase() {
        return idBase;
    }

    public void setMaxPaginationId(String maxPaginationId) {
        this.maxPaginationId = maxPaginationId;
    }

    public void setRecoNotificationType(String recoNotificationType) {
        this.recoNotificationType = recoNotificationType;
    }

    public void setDatetimeBase(Date datetimeBase) {
        this.datetimeBase = datetimeBase;
    }

    public void setIdBase(String idBase) {
        this.idBase = idBase;
    }

    public void setUnreadCounter(String unreadCounter) {
        this.unreadCounter = unreadCounter;
    }
}
