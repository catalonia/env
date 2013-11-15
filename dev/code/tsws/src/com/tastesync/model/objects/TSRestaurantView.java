package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;

@XmlRootElement(name = "restaurantsUserProfileHome")
public class TSRestaurantView implements Serializable {
	private static final long serialVersionUID = 787783999243399741L;
	private String id;
	private TSRestaurantPhotoObj photo;
	private TSRestaurantsTileSearchObj information;

	@XmlElement
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@XmlElement
	public TSRestaurantPhotoObj getPhoto() {
		return photo;
	}

	public void setPhoto(TSRestaurantPhotoObj photo) {
		this.photo = photo;
	}

	@XmlElement
	public TSRestaurantsTileSearchObj getInformation() {
		return information;
	}

	public void setInformation(TSRestaurantsTileSearchObj information) {
		this.information = information;
	}

}
