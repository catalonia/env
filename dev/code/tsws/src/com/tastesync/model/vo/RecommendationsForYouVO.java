package com.tastesync.model.vo;

import java.io.Serializable;


public class RecommendationsForYouVO implements Serializable {
    private static final long serialVersionUID = 3143664579907007091L;
    private String restaurantId;
    private String recommenderUserId;
    private String replyText;

    public RecommendationsForYouVO(String restaurantId,
        String recommenderUserId, String replyText) {
        super();
        this.restaurantId = restaurantId;
        this.recommenderUserId = recommenderUserId;
        this.replyText = replyText;
    }

    public RecommendationsForYouVO() {
        super();
    }

    public String getRestaurantId() {
        return restaurantId;
    }

    public String getRecommenderUserId() {
        return recommenderUserId;
    }

    public String getReplyText() {
        return replyText;
    }

    @Override
    public String toString() {
        return "RecommendationsForYouVO [restaurantId=" + restaurantId +
        ", recommenderUserId=" + recommenderUserId + ", replyText=" +
        replyText + "]";
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = (prime * result) +
            ((recommenderUserId == null) ? 0 : recommenderUserId.hashCode());
        result = (prime * result) +
            ((replyText == null) ? 0 : replyText.hashCode());
        result = (prime * result) +
            ((restaurantId == null) ? 0 : restaurantId.hashCode());

        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }

        if (obj == null) {
            return false;
        }

        if (getClass() != obj.getClass()) {
            return false;
        }

        RecommendationsForYouVO other = (RecommendationsForYouVO) obj;

        if (recommenderUserId == null) {
            if (other.recommenderUserId != null) {
                return false;
            }
        } else if (!recommenderUserId.equals(other.recommenderUserId)) {
            return false;
        }

        if (replyText == null) {
            if (other.replyText != null) {
                return false;
            }
        } else if (!replyText.equals(other.replyText)) {
            return false;
        }

        if (restaurantId == null) {
            if (other.restaurantId != null) {
                return false;
            }
        } else if (!restaurantId.equals(other.restaurantId)) {
            return false;
        }

        return true;
    }
}
