package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "facebook_user_data")
public class TSFacebookUserDataObj implements Serializable {

	private static final long serialVersionUID = 2332387668816080633L;
		private String userName;
		private String id;
		private String name;
		private String firstName;
		private String middleName;
		private String lastName;
		private String gender;
		private String locale;
		private String link;
		private String ageRange;
		private String birthday;
		private String thirdPartyId;
		private String friendlists;
		private String installed;
		private String timezone;
		private String updatedTime;
		private String verified;
		private String devices;
		private String email;
		private String hometown;
		private String location;
		private String picture;
		private String relationshipStatus;
		private String checkins;
		private String friends;
		private String likes;
		private String permissions;
		private String create;

		@XmlElement
		public String getUserName() {
			return userName;
		}

		@XmlElement
		public String getId() {
			return id;
		}

		@XmlElement
		public String getName() {
			return name;
		}

		@XmlElement
		public String getFirstName() {
			return firstName;
		}

		@XmlElement
		public String getMiddleName() {
			return middleName;
		}

		@XmlElement
		public String getLastName() {
			return lastName;
		}

		@XmlElement
		public String getGender() {
			return gender;
		}

		@XmlElement
		public String getLocale() {
			return locale;
		}
		
		@XmlElement
		public String getLink() {
			return link;
		}

		@XmlElement
		public String getAgeRange() {
			return ageRange;
		}

		@XmlElement
		public String getBirthday() {
			return birthday;
		}

		@XmlElement
		public String getThirdPartyId() {
			return thirdPartyId;
		}

		@XmlElement
		public String getFriendlists() {
			return friendlists;
		}

		@XmlElement
		public String getInstalled() {
			return installed;
		}

		@XmlElement
		public String getTimezone() {
			return timezone;
		}

		@XmlElement
		public String getUpdatedTime() {
			return updatedTime;
		}

		@XmlElement
		public String getVerified() {
			return verified;
		}

		@XmlElement
		public String getDevices() {
			return devices;
		}

		@XmlElement
		public String getEmail() {
			return email;
		}

		@XmlElement
		public String getHometown() {
			return hometown;
		}

		@XmlElement
		public String getLocation() {
			return location;
		}

		@XmlElement
		public String getPicture() {
			return picture;
		}

		@XmlElement
		public String getRelationshipStatus() {
			return relationshipStatus;
		}

		@XmlElement
		public String getCheckins() {
			return checkins;
		}

		@XmlElement
		public String getFriends() {
			return friends;
		}

		@XmlElement
		public String getLikes() {
			return likes;
		}

		@XmlElement
		public String getPermissions() {
			return permissions;
		}
		
		@XmlElement
		public String getCreate() {
			return create;
		}

		public void setUserName(String userName) {
			this.userName = userName;
		}

		public void setId(String id) {
			this.id = id;
		}

		public void setName(String name) {
			this.name = name;
		}

		public void setFirstName(String firstName) {
			this.firstName = firstName;
		}

		public void setMiddleName(String middleName) {
			this.middleName = middleName;
		}

		public void setLastName(String lastName) {
			this.lastName = lastName;
		}

		public void setGender(String gender) {
			this.gender = gender;
		}

		public void setLocale(String locale) {
			this.locale = locale;
		}

		public void setLink(String link) {
			this.link = link;
		}

		public void setAgeRange(String ageRange) {
			this.ageRange = ageRange;
		}

		public void setBirthday(String birthday) {
			this.birthday = birthday;
		}

		public void setThirdPartyId(String thirdPartyId) {
			this.thirdPartyId = thirdPartyId;
		}

		public void setFriendlists(String friendlists) {
			this.friendlists = friendlists;
		}

		public void setInstalled(String installed) {
			this.installed = installed;
		}

		public void setTimezone(String timezone) {
			this.timezone = timezone;
		}

		public void setUpdatedTime(String updatedTime) {
			this.updatedTime = updatedTime;
		}

		public void setVerified(String verified) {
			this.verified = verified;
		}

		public void setDevices(String devices) {
			this.devices = devices;
		}

		public void setEmail(String email) {
			this.email = email;
		}

		public void setHometown(String hometown) {
			this.hometown = hometown;
		}

		public void setLocation(String location) {
			this.location = location;
		}

		public void setPicture(String picture) {
			this.picture = picture;
		}

		public void setRelationshipStatus(String relationshipStatus) {
			this.relationshipStatus = relationshipStatus;
		}

		public void setCheckins(String checkins) {
			this.checkins = checkins;
		}

		public void setFriends(String friends) {
			this.friends = friends;
		}

		public void setLikes(String likes) {
			this.likes = likes;
		}

		public void setPermissions(String permissions) {
			this.permissions = permissions;
		}

		public void setCreate(String create) {
			this.create = create;
		}
	
}
