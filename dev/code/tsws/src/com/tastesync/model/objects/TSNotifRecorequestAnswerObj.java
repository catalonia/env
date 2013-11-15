package com.tastesync.model.objects;

import com.tastesync.model.objects.derived.TSRecommendationsForYouObj;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifrecorequestanswer")
public class TSNotifRecorequestAnswerObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = -5467916798784916916L;
    private String recorequestId;

    private String minViewedIndicator;
    private String recoActioned;
    private List<TSNotifRecoReplyObj> recoReply = new ArrayList<TSNotifRecoReplyObj>();
    private TSRecommendationsForYouObj recommendationsForYou;

    public TSNotifRecorequestAnswerObj() {
        super();
    }

    @XmlElement
    public String getRecorequestId() {
        return recorequestId;
    }



    @XmlElement
    public String getMinViewedIndicator() {
        return minViewedIndicator;
    }

    @XmlElement
    public String getRecoActioned() {
        return recoActioned;
    }

    @XmlElement
    public List<TSNotifRecoReplyObj> getRecoReply() {
        return recoReply;
    }

    @XmlElement
    public TSRecommendationsForYouObj getRecommendationsForYou() {
        return recommendationsForYou;
    }

    public void setRecorequestId(String recorequestId) {
        this.recorequestId = recorequestId;
    }

    public void setMinViewedIndicator(String minViewedIndicator) {
        this.minViewedIndicator = minViewedIndicator;
    }

    public void setRecoActioned(String recoActioned) {
        this.recoActioned = recoActioned;
    }

    public void setRecoReply(List<TSNotifRecoReplyObj> recoReply) {
        this.recoReply = recoReply;
    }

    public void setRecommendationsForYou(
        TSRecommendationsForYouObj recommendationsForYou) {
        this.recommendationsForYou = recommendationsForYou;
    }
}
