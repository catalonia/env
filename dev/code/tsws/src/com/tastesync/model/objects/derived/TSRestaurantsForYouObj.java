package com.tastesync.model.objects.derived;


import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "rests4u")
public class TSRestaurantsForYouObj implements Serializable {
    private static final long serialVersionUID = -4508601988061127809L;
    private String restaurantId;
    private String restaurantName;
    private String cuisineTier2Name;
    private String price;
    private String restaurantCity;
    private String restaurantLat;
    private String restaurantLong;
    private String restaurantDealFlag;
    private String restaurantRating;
    private List<TSRecommendationsObj> recommendationsForYouList = new ArrayList<TSRecommendationsObj>();

    public TSRestaurantsForYouObj() {
        super();
    }

    @XmlElement
    public List<TSRecommendationsObj> getRecommendationsForYouList() {
        return recommendationsForYouList;
    }

    public void setRecommendationsForYouList(
        List<TSRecommendationsObj> recommendationsForYouList) {
        this.recommendationsForYouList = recommendationsForYouList;
    }

    @XmlElement
    public String getRestaurantId() {
        return restaurantId;
    }

    @XmlElement
    public String getRestaurantName() {
        return restaurantName;
    }

    @XmlElement
    public String getCuisineTier2Name() {
        return cuisineTier2Name;
    }

    @XmlElement
    public String getPrice() {
        return price;
    }

    @XmlElement
    public String getRestaurantCity() {
        return restaurantCity;
    }

    @XmlElement
    public String getRestaurantLat() {
        return restaurantLat;
    }

    @XmlElement
    public String getRestaurantLong() {
        return restaurantLong;
    }

    @XmlElement
    public String getRestaurantDealFlag() {
        return restaurantDealFlag;
    }

    @XmlElement
    public String getRestaurantRating() {
        return restaurantRating;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public void setCuisineTier2Name(String cuisineTier2Name) {
        this.cuisineTier2Name = cuisineTier2Name;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public void setRestaurantCity(String restaurantCity) {
        this.restaurantCity = restaurantCity;
    }

    public void setRestaurantLat(String restaurantLat) {
        this.restaurantLat = restaurantLat;
    }

    public void setRestaurantLong(String restaurantLong) {
        this.restaurantLong = restaurantLong;
    }

    public void setRestaurantDealFlag(String restaurantDealFlag) {
        this.restaurantDealFlag = restaurantDealFlag;
    }

    public void setRestaurantRating(String restaurantRating) {
        this.restaurantRating = restaurantRating;
    }
}
