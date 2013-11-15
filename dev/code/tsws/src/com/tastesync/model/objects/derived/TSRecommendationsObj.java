package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "recommendations4u")
public class TSRecommendationsObj implements Serializable {
    private static final long serialVersionUID = -4855947877898176754L;
    private String replyText;
    private String recommenderUserFolloweeFlag;
    private TSUserProfileBasicObj recommendeeUser;

    public TSRecommendationsObj() {
        super();
    }

    @XmlElement
    public String getReplyText() {
        return replyText;
    }

    @XmlElement
    public String getRecommenderUserFolloweeFlag() {
        return recommenderUserFolloweeFlag;
    }

    @XmlElement
    public TSUserProfileBasicObj getRecommendeeUser() {
        return recommendeeUser;
    }

    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public void setRecommenderUserFolloweeFlag(
        String recommenderUserFolloweeFlag) {
        this.recommenderUserFolloweeFlag = recommenderUserFolloweeFlag;
    }

    public void setRecommendeeUser(TSUserProfileBasicObj recommendeeUser) {
        this.recommendeeUser = recommendeeUser;
    }
}
