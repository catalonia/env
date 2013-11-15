package com.tastesync.model.objects;

import com.tastesync.model.objects.derived.TSRestaurantBuzzCompleteObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurantdetails")
public class TSRestaurantDetailsObj implements Serializable {
    private static final long serialVersionUID = 1521205761276319693L;
    private String openNowFlag;
    private String dealHeadline;
    private List<TSRestaurantPhotoObj> photoList;
    private String moreInfoFlag;
    private String menuFlag;
    private String userRestaurantSavedFlag;
    private String userRestaurantFavFlag;
    private String userRestaurantTipFlag;
    private TSRestaurantBuzzCompleteObj restaurantBuzzComplete;
    private TSRestaurantExtendInfoObj restaurantExtendInfoObj;
    private TSRestaurantsTileSearchObj restaurantsTileSearch;

    @XmlElement
    public TSRestaurantBuzzCompleteObj getRestaurantBuzzComplete() {
        return restaurantBuzzComplete;
    }

    @XmlElement
    public TSRestaurantExtendInfoObj getRestaurantExtendInfoObj() {
        return restaurantExtendInfoObj;
    }

    @XmlElement
    public String getOpenNowFlag() {
        return openNowFlag;
    }

    @XmlElement
    public String getDealHeadline() {
        return dealHeadline;
    }

    @XmlElement
    public List<TSRestaurantPhotoObj> getPhotoList() {
        return photoList;
    }

    @XmlElement
    public String getMoreInfoFlag() {
        return moreInfoFlag;
    }

    @XmlElement
    public String getMenuFlag() {
        return menuFlag;
    }

    @XmlElement
    public String getUserRestaurantSavedFlag() {
        return userRestaurantSavedFlag;
    }

    @XmlElement
    public String getUserRestaurantFavFlag() {
        return userRestaurantFavFlag;
    }

    @XmlElement
    public String getUserRestaurantTipFlag() {
        return userRestaurantTipFlag;
    }

    @XmlElement
    public TSRestaurantsTileSearchObj getRestaurantsTileSearch() {
        return restaurantsTileSearch;
    }

    public void setOpenNowFlag(String openNowFlag) {
        this.openNowFlag = openNowFlag;
    }

    public void setDealHeadline(String dealHeadline) {
        this.dealHeadline = dealHeadline;
    }

    public void setPhotoList(List<TSRestaurantPhotoObj> photoList) {
        this.photoList = photoList;
    }

    public void setMoreInfoFlag(String moreInfoFlag) {
        this.moreInfoFlag = moreInfoFlag;
    }

    public void setMenuFlag(String menuFlag) {
        this.menuFlag = menuFlag;
    }

    public void setUserRestaurantSavedFlag(String userRestaurantSavedFlag) {
        this.userRestaurantSavedFlag = userRestaurantSavedFlag;
    }

    public void setUserRestaurantFavFlag(String userRestaurantFavFlag) {
        this.userRestaurantFavFlag = userRestaurantFavFlag;
    }

    public void setUserRestaurantTipFlag(String userRestaurantTipFlag) {
        this.userRestaurantTipFlag = userRestaurantTipFlag;
    }

    public void setRestaurantExtendInfoObj(
        TSRestaurantExtendInfoObj restaurantExtendInfoObj) {
        this.restaurantExtendInfoObj = restaurantExtendInfoObj;
    }

    public void setRestaurantBuzzComplete(
        TSRestaurantBuzzCompleteObj restaurantBuzzComplete) {
        this.restaurantBuzzComplete = restaurantBuzzComplete;
    }

    public void setRestaurantsTileSearch(
        TSRestaurantsTileSearchObj restaurantsTileSearch) {
        this.restaurantsTileSearch = restaurantsTileSearch;
    }
}
