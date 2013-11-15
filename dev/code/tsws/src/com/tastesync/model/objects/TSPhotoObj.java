package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "photo")
public class TSPhotoObj implements Serializable {
    private static final long serialVersionUID = 5120124044342985661L;
    private String userId;
    private String name;
    private String photo;

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
