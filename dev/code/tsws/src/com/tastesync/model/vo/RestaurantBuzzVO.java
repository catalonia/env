package com.tastesync.model.vo;

import java.io.Serializable;

public class RestaurantBuzzVO implements Serializable {
    private static final long serialVersionUID = -2883739872636630834L;
    private String replyId;
    private String replyText;
    private String recommenderUserUserId;
    private String replyDatetime;
    private String recorequestId;

    public RestaurantBuzzVO(String replyId, String replyText,
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
