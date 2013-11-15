package com.tastesync.model.vo;

import java.io.Serializable;

import java.util.ArrayList;


public class DescriptorDataVO implements Serializable {
    private static final long serialVersionUID = 7408913874079839987L;
    private ArrayList<String> cuisineTier1IdDescList = new ArrayList<String>();
    private ArrayList<String> cuisineTier2IdDescList = new ArrayList<String>();
    private ArrayList<String> occasionIdDescList = new ArrayList<String>();
    private ArrayList<String> whoareyouwithIdDescList = new ArrayList<String>();
    private ArrayList<String> typeOfRestaurantIdDescList = new ArrayList<String>();
    private ArrayList<String> themeIdDescList = new ArrayList<String>();
    private ArrayList<String> priceIdDescList = new ArrayList<String>();
    private String cityName = null;
    private String neighborhoodName = null;
    

    public DescriptorDataVO(ArrayList<String> cuisineTier1IdDescList,
			ArrayList<String> cuisineTier2IdDescList,
			ArrayList<String> occasionIdDescList,
			ArrayList<String> whoareyouwithIdDescList,
			ArrayList<String> typeOfRestaurantIdDescList,
			ArrayList<String> themeIdDescList,
			ArrayList<String> priceIdDescList, String cityName,
			String neighborhoodName) {
		super();
		this.cuisineTier1IdDescList = cuisineTier1IdDescList;
		this.cuisineTier2IdDescList = cuisineTier2IdDescList;
		this.occasionIdDescList = occasionIdDescList;
		this.whoareyouwithIdDescList = whoareyouwithIdDescList;
		this.typeOfRestaurantIdDescList = typeOfRestaurantIdDescList;
		this.themeIdDescList = themeIdDescList;
		this.priceIdDescList = priceIdDescList;
		this.cityName = cityName;
		this.neighborhoodName = neighborhoodName;
	}

    public ArrayList<String> getCuisineTier1IdDescList() {
        return cuisineTier1IdDescList;
    }

    public ArrayList<String> getCuisineTier2IdDescList() {
        return cuisineTier2IdDescList;
    }

    public ArrayList<String> getOccasionIdDescList() {
        return occasionIdDescList;
    }

    public ArrayList<String> getWhoareyouwithIdDescList() {
        return whoareyouwithIdDescList;
    }

    public ArrayList<String> getTypeOfRestaurantIdDescList() {
        return typeOfRestaurantIdDescList;
    }

    public ArrayList<String> getThemeIdDescList() {
        return themeIdDescList;
    }

    public ArrayList<String> getPriceIdDescList() {
        return priceIdDescList;
    }

	public String getCityName() {
		return cityName;
	}

	public String getNeighborhoodName() {
		return neighborhoodName;
	}
    
}
