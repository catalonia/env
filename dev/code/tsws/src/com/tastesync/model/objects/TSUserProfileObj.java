package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "userprofile")
public class TSUserProfileObj implements Serializable {
    private static final long serialVersionUID = 3018045967607449545L;
    private String userId;
    private String cityId;
    private String name;
    private String photo;
    private String facebookCity;
    private String facebookUrl;
    private String twitterUrl;
    private String blogUrl;
    private String aboutMeText;
    private String numFollowers;
    private String numFollowees;
    private String numFriendsOnTs;
    private String numPoints;
    private String emailId;
    private List<TSRestaurantView> restaurantList;

    @XmlElement
    public String getEmailId() {
        return emailId;
    }

    @XmlElement
    public String getUserId() {
        return userId;
    }

    @XmlElement
    public String getName() {
        return name;
    }

    @XmlElement
    public String getPhoto() {
        return photo;
    }

    @XmlElement
    public String getFacebookCity() {
        return facebookCity;
    }

    @XmlElement
    public String getFacebookUrl() {
        return facebookUrl;
    }

    @XmlElement
    public String getTwitterUrl() {
        return twitterUrl;
    }

    @XmlElement
    public String getBlogUrl() {
        return blogUrl;
    }

    @XmlElement
    public String getAboutMeText() {
        return aboutMeText;
    }

    @XmlElement
    public String getNumFollowers() {
        return numFollowers;
    }

    @XmlElement
    public String getNumFollowees() {
        return numFollowees;
    }

    @XmlElement
    public String getNumFriendsOnTs() {
        return numFriendsOnTs;
    }

    @XmlElement
    public String getNumPoints() {
        return numPoints;
    }

    @XmlElement
    public List<TSRestaurantView> getRestaurantList() {
        return restaurantList;
    }

    @XmlElement
    public String getCityId() {
        return cityId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public void setFacebookCity(String facebookCity) {
        this.facebookCity = facebookCity;
    }

    public void setFacebookUrl(String facebookUrl) {
        this.facebookUrl = facebookUrl;
    }

    public void setTwitterUrl(String twitterUrl) {
        this.twitterUrl = twitterUrl;
    }

    public void setBlogUrl(String blogUrl) {
        this.blogUrl = blogUrl;
    }

    public void setAboutMeText(String aboutMeText) {
        this.aboutMeText = aboutMeText;
    }

    public void setNumFollowers(String numFollowers) {
        this.numFollowers = numFollowers;
    }

    public void setNumFollowees(String numFollowees) {
        this.numFollowees = numFollowees;
    }

    public void setNumFriendsOnTs(String numFriendsOnTs) {
        this.numFriendsOnTs = numFriendsOnTs;
    }

    public void setNumPoints(String numPoints) {
        this.numPoints = numPoints;
    }

    public void setRestaurantList(List<TSRestaurantView> restaurantList) {
        this.restaurantList = restaurantList;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
    }
}
