package com.tastesync.model.objects.derived;

import com.tastesync.model.objects.TSCuisineTier2Obj;
import com.tastesync.model.objects.TSRestaurantDetailsObj;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurantcuisinetier2")
public class TSRestaurantCusineTier2Obj implements Serializable {
    private static final long serialVersionUID = 3128252231477530017L;
    private TSRestaurantDetailsObj tsRestaurantDetailsObj;
    private TSCuisineTier2Obj tsCuisineTier2Obj;

    @XmlElement
    public TSRestaurantDetailsObj getTsRestaurantDetailsObj() {
        return tsRestaurantDetailsObj;
    }

    @XmlElement
    public TSCuisineTier2Obj getTsCuisineTier2Obj() {
        return tsCuisineTier2Obj;
    }

    public void setTsRestaurantDetailsObj(
        TSRestaurantDetailsObj tsRestaurantDetailsObj) {
        this.tsRestaurantDetailsObj = tsRestaurantDetailsObj;
    }

    public void setTsCuisineTier2Obj(TSCuisineTier2Obj tsCuisineTier2Obj) {
        this.tsCuisineTier2Obj = tsCuisineTier2Obj;
    }
}
