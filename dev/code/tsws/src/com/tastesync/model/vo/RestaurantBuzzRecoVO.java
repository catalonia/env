package com.tastesync.model.vo;

import java.io.Serializable;


public class RestaurantBuzzRecoVO implements Serializable {
    private static final long serialVersionUID = 4636256231706431672L;
    private String replyId;
    private String replyText;
    private String recommenderUserUserId;
    private String replyDatetime;
    private String recorequestId;

    public RestaurantBuzzRecoVO(String replyId, String replyText,
        String recommenderUserUserId, String replyDatetime, String recorequestId) {
        super();
        this.replyId = replyId;
        this.replyText = replyText;
        this.recommenderUserUserId = recommenderUserUserId;
        this.replyDatetime = replyDatetime;
        this.recorequestId = recorequestId;
    }

    public String getReplyId() {
        return replyId;
    }

    public String getReplyText() {
        return replyText;
    }

    public String getRecommenderUserUserId() {
        return recommenderUserUserId;
    }

    public String getReplyDatetime() {
        return replyDatetime;
    }

    public String getRecorequestId() {
        return recorequestId;
    }
}
