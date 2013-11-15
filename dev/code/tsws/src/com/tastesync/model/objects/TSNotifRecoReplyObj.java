package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifrecoreply")
public class TSNotifRecoReplyObj implements Serializable {
    private static final long serialVersionUID = -2924784723536826201L;
    private String replyId;
    private String repliedDatetime;
    private String viewed;

    public TSNotifRecoReplyObj() {
        super();
    }

    @XmlElement
    public String getReplyId() {
        return replyId;
    }

    @XmlElement
    public String getRepliedDatetime() {
        return repliedDatetime;
    }

    @XmlElement
    public String getViewed() {
        return viewed;
    }



    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }

    public void setRepliedDatetime(String repliedDatetime) {
        this.repliedDatetime = repliedDatetime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }


}
