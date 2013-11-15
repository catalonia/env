package com.tastesync.model.objects;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurant")
public class TSRestaurantObj implements Serializable {
    private static final long serialVersionUID = 2113162995960225661L;
    private String restaurantId;
    private String factualId;
    private String restaurantName;
    private String factualRating;
    private String priceRange;
    private String restaurantCityId;
    private String restaurantHours;
    private String restaurantLat;
    private String restaurantLon;
    private String sumVoteCount;
    private String sumVoteValue;
    private String tbdOpenTableId;
    private String moreInfoFlag;
    private String openNowFlag;
    private List<TSCuisineTier2Obj> cuisineTier2Obj;
    private TSCityObj cityObj;
    
    public TSRestaurantObj() {
        super();
    }

    @XmlElement
    public String getMoreInfoFlag() {
        return moreInfoFlag;
    }

    @XmlElement
    public String getOpenNowFlag() {
        return openNowFlag;
    }

    public void setMoreInfoFlag(String moreInfoFlag) {
        this.moreInfoFlag = moreInfoFlag;
    }

    public void setOpenNowFlag(String openNowFlag) {
        this.openNowFlag = openNowFlag;
    }

    @XmlElement
    public String getRestaurantId() {
        return restaurantId;
    }

    @XmlElement
    public String getFactualId() {
        return factualId;
    }

    @XmlElement
    public String getRestaurantName() {
        return restaurantName;
    }

    @XmlElement
    public String getFactualRating() {
        return factualRating;
    }

    @XmlElement
    public String getPriceRange() {
        return priceRange;
    }

    @XmlElement
    public String getRestaurantCityId() {
        return restaurantCityId;
    }

    @XmlElement
    public String getRestaurantHours() {
        return restaurantHours;
    }

    @XmlElement
    public String getRestaurantLat() {
        return restaurantLat;
    }

    @XmlElement
    public String getRestaurantLon() {
        return restaurantLon;
    }

    @XmlElement
    public String getSumVoteCount() {
        return sumVoteCount;
    }

    @XmlElement
    public String getSumVoteValue() {
        return sumVoteValue;
    }

    @XmlElement
    public String getTbdOpenTableId() {
        return tbdOpenTableId;
    }

    @XmlElement
	public List<TSCuisineTier2Obj> getCuisineTier2Obj() {
		return cuisineTier2Obj;
	}

    @XmlElement
    public TSCityObj getCityObj() {
		return cityObj;
	}
    
    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setFactualId(String factualId) {
        this.factualId = factualId;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public void setFactualRating(String factualRating) {
        this.factualRating = factualRating;
    }

    public void setPriceRange(String priceRange) {
        this.priceRange = priceRange;
    }

    public void setRestaurantCityId(String restaurantCityId) {
        this.restaurantCityId = restaurantCityId;
    }

    public void setRestaurantHours(String restaurantHours) {
        this.restaurantHours = restaurantHours;
    }

    public void setRestaurantLat(String restaurantLat) {
        this.restaurantLat = restaurantLat;
    }

    public void setRestaurantLon(String restaurantLon) {
        this.restaurantLon = restaurantLon;
    }

    public void setSumVoteCount(String sumVoteCount) {
        this.sumVoteCount = sumVoteCount;
    }

    public void setSumVoteValue(String sumVoteValue) {
        this.sumVoteValue = sumVoteValue;
    }

    public void setTbdOpenTableId(String tbdOpenTableId) {
        this.tbdOpenTableId = tbdOpenTableId;
    }

    @Override
    public String toString() {
        return "TSRestaurantObj [restaurantId=" + restaurantId +
        ", factualId=" + factualId + ", restaurantName=" + restaurantName +
        ", factualRating=" + factualRating + ", priceRange=" + priceRange +
        ", restaurantCityId=" + restaurantCityId + ", restaurantHours=" +
        restaurantHours + ", restaurantLat=" + restaurantLat +
        ", restaurantLon=" + restaurantLon + ", sumVoteCount=" + sumVoteCount +
        ", sumVoteValue=" + sumVoteValue + ", tbdOpenTableId=" +
        tbdOpenTableId + "]";
    }

	public void setCuisineTier2Obj(List<TSCuisineTier2Obj> cuisineTier2Obj) {
		this.cuisineTier2Obj = cuisineTier2Obj;
	}

	public void setCityObj(TSCityObj cityObj) {
		this.cityObj = cityObj;
	}
}
