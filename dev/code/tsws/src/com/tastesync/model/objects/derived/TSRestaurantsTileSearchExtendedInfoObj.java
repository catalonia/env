package com.tastesync.model.objects.derived;

import java.io.Serializable;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "reststilesearchextendedinfo")
public class TSRestaurantsTileSearchExtendedInfoObj implements Serializable {
    private static final long serialVersionUID = 2724451893739842735L;
    private String maxPaginationId;
    private List<TSRestaurantsTileSearchObj> restaurantsSearchListTileObj = null;

    public TSRestaurantsTileSearchExtendedInfoObj() {
        super();
    }

    @XmlElement
    public String getMaxPaginationId() {
        return maxPaginationId;
    }

    @XmlElement
    public List<TSRestaurantsTileSearchObj> getRestaurantsSearchListTileObj() {
        return restaurantsSearchListTileObj;
    }

    public void setMaxPaginationId(String maxPaginationId) {
        this.maxPaginationId = maxPaginationId;
    }

    public void setTsRestaurantsTileSearchObjList(
        List<TSRestaurantsTileSearchObj> restaurantsSearchListTileObj) {
        this.restaurantsSearchListTileObj = restaurantsSearchListTileObj;
    }
}
