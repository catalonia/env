package com.tastesync.model.response;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;

import com.tastesync.model.objects.TSCityObj;
import com.tastesync.model.objects.TSFacebookUserDataObj;
import com.tastesync.model.objects.TSUserObj;
import com.tastesync.model.objects.TSUserProfileObj;
import com.tastesync.model.objects.TSUserProfileRestaurantsObj;

public class UserResponse implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String user_log_id;
	private TSUserObj user;
	private String is_have_account;
	private TSUserProfileObj user_profile_obj;
	private TSUserProfileRestaurantsObj user_data;
	private TSFacebookUserDataObj city;
	private TSCityObj fb_user_data;
	private List<TSUserObj> list_user_data;
	private List<TSUserProfileObj> list_user;
	private List<TSUserProfileRestaurantsObj> list_user_follow_data;
	private List<TSFacebookUserDataObj> list_fb_user_data;
	private List<TSCityObj> list_cities;
	
	public UserResponse() {
		
	}

	@XmlElement
	public String getIs_have_account() {
		return is_have_account;
	}
	
	@XmlElement
	public TSUserObj getUser() {
		return user;
	}

	public void setUser(TSUserObj user) {
		this.user = user;
	}
	
	@XmlElement
	public TSUserProfileObj getUser_profile_obj() {
		return user_profile_obj;
	}

	public void setUser_profile_obj(TSUserProfileObj user_profile_obj) {
		this.user_profile_obj = user_profile_obj;
	}

	@XmlElement
	public TSUserProfileRestaurantsObj getUser_data() {
		return user_data;
	}

	public void setUser_data(TSUserProfileRestaurantsObj user_data) {
		this.user_data = user_data;
	}

	@XmlElement
	public TSFacebookUserDataObj getCity() {
		return city;
	}

	public void setCity(TSFacebookUserDataObj city) {
		this.city = city;
	}

	@XmlElement
	public TSCityObj getFb_user_data() {
		return fb_user_data;
	}

	public void setFb_user_data(TSCityObj fb_user_data) {
		this.fb_user_data = fb_user_data;
	}

	@XmlElement
	public List<TSUserObj> getList_user_data() {
		return list_user_data;
	}

	public void setList_user_data(List<TSUserObj> list_user_data) {
		this.list_user_data = list_user_data;
	}

	@XmlElement
	public List<TSUserProfileObj> getList_user() {
		return list_user;
	}

	public void setList_user(List<TSUserProfileObj> list_user) {
		this.list_user = list_user;
	}

	@XmlElement
	public List<TSUserProfileRestaurantsObj> getList_user_follow_data() {
		return list_user_follow_data;
	}

	public void setList_user_follow_data(List<TSUserProfileRestaurantsObj> list_user_follow_data) {
		this.list_user_follow_data = list_user_follow_data;
	}

	@XmlElement
	public List<TSFacebookUserDataObj> getList_fb_user_data() {
		return list_fb_user_data;
	}

	public void setList_fb_user_data(List<TSFacebookUserDataObj> list_fb_user_data) {
		this.list_fb_user_data = list_fb_user_data;
	}

	@XmlElement
	public List<TSCityObj> getList_cities() {
		return list_cities;
	}

	public void setList_cities(List<TSCityObj> list_cities) {
		this.list_cities = list_cities;
	}

	@XmlElement
	public String getUser_log_id() {
		return user_log_id;
	}

	public void setUser_log_id(String user_log_id) {
		this.user_log_id = user_log_id;
	}

	public void setIs_have_account(String is_have_account) {
		this.is_have_account = is_have_account;
	}
}