package com.tastesync.model.objects;

import java.io.Serializable;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.tastesync.model.objects.derived.TSRecommendersDetailsObj;

@XmlRootElement(name = "restaurants")
public class TSCurrentRecommendedRestaurantDetailsObj implements Serializable {

	private static final long serialVersionUID = -8726629173325350356L;

	private String userId;
	private String restaurantId;
	private String questionId;
	private List<TSRecommendersDetailsObj> tsRecommendersDetailsObj;
	@XmlElement
	public String getUserId() {
		return userId;
	}
	@XmlElement
	public String getRestaurantId() {
		return restaurantId;
	}
	@XmlElement
	public String getQuestionId() {
		return questionId;
	}
	@XmlElement
	public List<TSRecommendersDetailsObj> getTsRecommendersDetailsObj() {
		return tsRecommendersDetailsObj;
	}	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public void setRestaurantId(String restaurantId) {
		this.restaurantId = restaurantId;
	}
	public void setQuestionId(String questionId) {
		this.questionId = questionId;
	}
	public void setTsRecommendersDetailsObj(
			List<TSRecommendersDetailsObj> tsRecommendersDetailsObj) {
		this.tsRecommendersDetailsObj = tsRecommendersDetailsObj;
	}
}
