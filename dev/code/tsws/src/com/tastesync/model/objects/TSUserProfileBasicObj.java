package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "userprofilebasic")
public class TSUserProfileBasicObj implements Serializable {
    private static final long serialVersionUID = -4536814232029458252L;
    private String userId;
    private String name;
    private String photo;
    private TSPhotoObj photoDetails;

    public TSUserProfileBasicObj() {
		super();
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
    public TSPhotoObj getPhotoDetails() {
		return photoDetails;
	}

	public void setPhotoDetails(TSPhotoObj photoDetails) {
		this.photoDetails = photoDetails;
	}

	public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
}
