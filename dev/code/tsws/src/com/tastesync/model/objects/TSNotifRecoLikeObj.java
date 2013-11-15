package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifrecolike")
public class TSNotifRecoLikeObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = -4709505530739858849L;
    private String likeId;
    private String likeDatetime;
    private String viewed;
    private TSUserProfileBasicObj recommendeeUser;

    public TSNotifRecoLikeObj() {
        super();
    }

    @XmlElement
    public String getLikeId() {
        return likeId;
    }

    @XmlElement
    public String getLikeDatetime() {
        return likeDatetime;
    }

    @XmlElement
    public String getViewed() {
        return viewed;
    }

    @XmlElement
    public TSUserProfileBasicObj getRecommendeeUser() {
        return recommendeeUser;
    }

    public void setLikeId(String likeId) {
        this.likeId = likeId;
    }

    public void setLikeDatetime(String likeDatetime) {
        this.likeDatetime = likeDatetime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public void setRecommendeeUser(TSUserProfileBasicObj recommendeeUser) {
        this.recommendeeUser = recommendeeUser;
    }
}
