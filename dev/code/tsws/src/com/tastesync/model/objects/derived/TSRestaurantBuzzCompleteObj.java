package com.tastesync.model.objects.derived;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restbuzzcomplete")
public class TSRestaurantBuzzCompleteObj implements Serializable {
    private static final long serialVersionUID = 3608839612559182847L;
    List<TSRestaurantBuzzRecoObj> restaurantBuzzRecoList = null;
    List<TSRestaurantBuzzTipObj> restaurantBuzzTipList = null;

    public TSRestaurantBuzzCompleteObj() {
        super();
    }

    @XmlElement
    public List<TSRestaurantBuzzRecoObj> getRestaurantBuzzRecoList() {
        return restaurantBuzzRecoList;
    }

    @XmlElement
    public List<TSRestaurantBuzzTipObj> getRestaurantBuzzTipList() {
        return restaurantBuzzTipList;
    }

    public void setRestaurantBuzzRecoList(
        List<TSRestaurantBuzzRecoObj> restaurantBuzzRecoList) {
        this.restaurantBuzzRecoList = restaurantBuzzRecoList;
    }

    public void setRestaurantBuzzTipList(
        List<TSRestaurantBuzzTipObj> restaurantBuzzTipList) {
        this.restaurantBuzzTipList = restaurantBuzzTipList;
    }
}
