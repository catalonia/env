package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restbuzzreco")
public class TSRestaurantBuzzRecoObj implements Serializable {
    private static final long serialVersionUID = 3548404825329747915L;
    private String recorequestText;
    private String replyText;
    private TSUserProfileBasicObj recommenderUser;
    private String recommenderUserFolloweeFlag;
    private String replyDatetime;

    public TSRestaurantBuzzRecoObj() {
        super();
    }

    @XmlElement
    public String getRecorequestText() {
        return recorequestText;
    }

    @XmlElement
    public String getReplyText() {
        return replyText;
    }

    @XmlElement
    public TSUserProfileBasicObj getRecommenderUser() {
        return recommenderUser;
    }

    @XmlElement
    public String getRecommenderUserFolloweeFlag() {
        return recommenderUserFolloweeFlag;
    }

    @XmlElement
    public String getReplyDatetime() {
        return replyDatetime;
    }

    public void setRecorequestText(String recorequestText) {
        this.recorequestText = recorequestText;
    }

    public void setReplyText(String replyText) {
        this.replyText = replyText;
    }

    public void setRecommenderUser(TSUserProfileBasicObj recommenderUser) {
        this.recommenderUser = recommenderUser;
    }

    public void setRecommenderUserFolloweeFlag(
        String recommenderUserFolloweeFlag) {
        this.recommenderUserFolloweeFlag = recommenderUserFolloweeFlag;
    }

    public void setReplyDatetime(String replyDatetime) {
        this.replyDatetime = replyDatetime;
    }
}
