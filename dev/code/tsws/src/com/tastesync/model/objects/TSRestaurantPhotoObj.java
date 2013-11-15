package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "restaurantphoto")
public class TSRestaurantPhotoObj implements Serializable {
    private static final long serialVersionUID = 2415797406344215226L;
    private String restaurantId;
    private String photoId;
    private String prefix;
    private String suffix;
    private String width;
    private String height;
    private String ultimateSourceName;
    private String ultimateSourceUrl;
    private String photoSource;

    @XmlElement
    public String getRestaurantId() {
        return restaurantId;
    }

    @XmlElement
    public String getPhotoId() {
        return photoId;
    }

    @XmlElement
    public String getPrefix() {
        return prefix;
    }

    @XmlElement
    public String getSuffix() {
        return suffix;
    }

    @XmlElement
    public String getWidth() {
        return width;
    }

    @XmlElement
    public String getHeight() {
        return height;
    }

    @XmlElement
    public String getUltimateSourceName() {
        return ultimateSourceName;
    }

    @XmlElement
    public String getUltimateSourceUrl() {
        return ultimateSourceUrl;
    }

    @XmlElement
    public String getPhotoSource() {
        return photoSource;
    }

    public void setRestaurantId(String restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setPhotoId(String photoId) {
        this.photoId = photoId;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }

    public void setWidth(String width) {
        this.width = width;
    }

    public void setHeight(String height) {
        this.height = height;
    }

    public void setUltimateSourceName(String ultimateSourceName) {
        this.ultimateSourceName = ultimateSourceName;
    }

    public void setUltimateSourceUrl(String ultimateSourceUrl) {
        this.ultimateSourceUrl = ultimateSourceUrl;
    }

    public void setPhotoSource(String photoSource) {
        this.photoSource = photoSource;
    }
}
