package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurantbasic")
public class TSRestaurantBasicObj implements Serializable {
    private static final long serialVersionUID = -2322653278425660959L;
    private String restaurantId;
    private String restaurantName;

    public TSRestaurantBasicObj() {
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

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
}
