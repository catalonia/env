package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "user")
public class TSUserObj implements Serializable {
    private static final long serialVersionUID = 6547379190857211071L;

    // private String authtoken;
    // private Timestamp authtoken_expiration;
    private String userId;
    private String tsUserId;
    private String tsUserEmail;

    //private String tsUserPw;
    private String tsFirstName;
    private String tsLastName;
    private String maxInvites;
    private String userCreatedInitialDatetime;
    private String userPoints;
    private String twitterUsrUrl;
    private String userDisabledFlag;
    private String userActivationKey;
    private String userGender;
    private String userCityId;
    private String userState;
    private String isOnline;
    private String userCountry;
    private String about;
    private String currentStatus;
    private String userFbId;
    private String photo;

    public TSUserObj() {
        super();
    }

    @XmlElement
    public String getUserId() {
        return userId;
    }

    @XmlElement
    public String getTsUserId() {
        return tsUserId;
    }

    @XmlElement
    public String getTsUserEmail() {
        return tsUserEmail;
    }

    @XmlElement
    public String getTsFirstName() {
        return tsFirstName;
    }

    @XmlElement
    public String getTsLastName() {
        return tsLastName;
    }

    @XmlElement
    public String getMaxInvites() {
        return maxInvites;
    }

    @XmlElement
    public String getUserCreatedInitialDatetime() {
        return userCreatedInitialDatetime;
    }

    @XmlElement
    public String getUserPoints() {
        return userPoints;
    }

    @XmlElement
    public String getTwitterUsrUrl() {
        return twitterUsrUrl;
    }

    @XmlElement
    public String getUserDisabledFlag() {
        return userDisabledFlag;
    }

    @XmlElement
    public String getUserActivationKey() {
        return userActivationKey;
    }

    @XmlElement
    public String getUserGender() {
        return userGender;
    }

    @XmlElement
    public String getUserCityId() {
        return userCityId;
    }

    @XmlElement
    public String getUserState() {
        return userState;
    }

    @XmlElement
    public String getIsOnline() {
        return isOnline;
    }

    @XmlElement
    public String getUserCountry() {
        return userCountry;
    }

    @XmlElement
    public String getUserFbId() {
        return userFbId;
    }

    @XmlElement
    public String getAbout() {
        return about;
    }

    @XmlElement
    public String getCurrentStatus() {
        return currentStatus;
    }

    @XmlElement
    public String getPhoto() {
        return photo;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setTsUserId(String tsUserId) {
        this.tsUserId = tsUserId;
    }

    public void setTsUserEmail(String tsUserEmail) {
        this.tsUserEmail = tsUserEmail;
    }

    public void setTsFirstName(String tsFirstName) {
        this.tsFirstName = tsFirstName;
    }

    public void setTsLastName(String tsLastName) {
        this.tsLastName = tsLastName;
    }

    public void setMaxInvites(String maxInvites) {
        this.maxInvites = maxInvites;
    }

    public void setUserCreatedInitialDatetime(String userCreatedInitialDatetime) {
        this.userCreatedInitialDatetime = userCreatedInitialDatetime;
    }

    public void setUserPoints(String userPoints) {
        this.userPoints = userPoints;
    }

    public void setTwitterUsrUrl(String twitterUsrUrl) {
        this.twitterUsrUrl = twitterUsrUrl;
    }

    public void setUserDisabledFlag(String userDisabledFlag) {
        this.userDisabledFlag = userDisabledFlag;
    }

    public void setUserActivationKey(String userActivationKey) {
        this.userActivationKey = userActivationKey;
    }

    public void setUserGender(String userGender) {
        this.userGender = userGender;
    }

    public void setUserCityId(String userCityId) {
        this.userCityId = userCityId;
    }

    public void setUserState(String userState) {
        this.userState = userState;
    }

    public void setIsOnline(String isOnline) {
        this.isOnline = isOnline;
    }

    public void setUserCountry(String userCountry) {
        this.userCountry = userCountry;
    }

    public void setUserFbId(String userFbId) {
        this.userFbId = userFbId;
    }

    public void setAbout(String about) {
        this.about = about;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    @Override
    public String toString() {
        return "TSUserObj [userId=" + userId + ", tsUserId=" + tsUserId +
        ", tsUserEmail=" + tsUserEmail + ", tsFirstName=" + tsFirstName +
        ", tsLastName=" + tsLastName + ", maxInvites=" + maxInvites +
        ", userCreatedInitialDatetime=" + userCreatedInitialDatetime +
        ", userPoints=" + userPoints + ", twitterUsrUrl=" + twitterUsrUrl +
        ", userDisabledFlag=" + userDisabledFlag + ", userActivationKey=" +
        userActivationKey + ", userGender=" + userGender + ", userCityId=" +
        userCityId + ", userState=" + userState + ", isOnline=" + isOnline +
        ", userCountry=" + userCountry + ", about=" + about +
        ", currentStatus=" + currentStatus + ", userFbId=" + userFbId + "]";
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
}
