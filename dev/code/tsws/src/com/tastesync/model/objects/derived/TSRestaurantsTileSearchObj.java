package com.tastesync.model.objects.derived;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "reststilesearch")
public class TSRestaurantsTileSearchObj implements Serializable {
    private static final long serialVersionUID = 5798071799106644490L;
    private String restaurantId;
    private String restaurantName;
    private String cuisineTier2Name;
    private String price;
    private String restaurantCity;
    private String restaurantLat;
    private String restaurantLong;
    private String restaurantDealFlag;
    private String restaurantRating;

    public TSRestaurantsTileSearchObj() {
        super();
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
