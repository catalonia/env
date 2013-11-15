package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSUserProfileBasicObj;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurantrecommenders")
public class TSRestaurantRecommendersDetailsObj implements Serializable {
    private static final long serialVersionUID = 8522302350787297163L;
    private String userId;
    private String restaurantId;
    private List<TSUserProfileBasicObj> recommendersDetailsList = new ArrayList<TSUserProfileBasicObj>();

    public TSRestaurantRecommendersDetailsObj() {
        super();
    }

    @XmlElement
    public String getUserId() {
        return userId;
    }

    @XmlElement
    public String getRestaurantId() {
        return restaurantId;
    }

    @XmlElement
    public List<TSUserProfileBasicObj> getRecommendersDetailsList() {
        return recommendersDetailsList;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setRecommendersDetailsList(
        List<TSUserProfileBasicObj> recommendersDetailsList) {
        this.recommendersDetailsList = recommendersDetailsList;
    }
}
