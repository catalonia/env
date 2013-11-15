package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "locationsearchcities")
public class TSLocationSearchCitiesObj implements Serializable {
    private static final long serialVersionUID = 3193754173469005183L;
    private String cityId;
    private String cityName;
    private String neighborhoodId;
    private String neighborhoodName;
    private String state;

    public TSLocationSearchCitiesObj() {
        super();
    }

    @XmlElement
    public String getCityId() {
        return cityId;
    }

    @XmlElement
    public String getCityName() {
        return cityName;
    }

    @XmlElement
    public String getNeighborhoodId() {
        return neighborhoodId;
    }

    @XmlElement
    public String getNeighborhoodName() {
        return neighborhoodName;
    }

    @XmlElement
    public String getState() {
        return state;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public void setNeighborhoodId(String neighborhoodId) {
        this.neighborhoodId = neighborhoodId;
    }

    public void setNeighborhoodName(String neighborhoodName) {
        this.neighborhoodName = neighborhoodName;
    }

    public void setState(String state) {
        this.state = state;
    }
}
