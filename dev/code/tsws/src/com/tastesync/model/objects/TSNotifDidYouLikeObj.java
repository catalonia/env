package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "notifdidyoulike")
public class TSNotifDidYouLikeObj extends TSRecoNotificationBaseObj
    implements Serializable {
    private static final long serialVersionUID = -5883813751695112063L;
    private String recorequestId;
    private String datetime;
    private String viewed;
    private List<TSRestaurantBasicObj> restaurantbasic = new ArrayList<TSRestaurantBasicObj>();

    public TSNotifDidYouLikeObj() {
        super();
    }

    @XmlElement
    public String getRecorequestId() {
        return recorequestId;
    }

    @XmlElement
    public String getDatetime() {
        return datetime;
    }

    @XmlElement
    public String getViewed() {
        return viewed;
    }

    @XmlElement
    public List<TSRestaurantBasicObj> getRestaurantbasic() {
        return restaurantbasic;
    }

    public void setRecorequestId(String recorequestId) {
        this.recorequestId = recorequestId;
    }

    public void setDatetime(String datetime) {
        this.datetime = datetime;
    }

    public void setViewed(String viewed) {
        this.viewed = viewed;
    }

    public void setRestaurantbasic(List<TSRestaurantBasicObj> restaurantbasic) {
        this.restaurantbasic = restaurantbasic;
    }
}
