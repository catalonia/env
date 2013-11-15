package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "restaurantextendedinfo")
public class TSRestaurantExtendInfoObj implements Serializable {
    private static final long serialVersionUID = 6933222467768293971L;
    private String phoneNumber;
    private String website;
    private String healthyOptionsFlag;
    private String wifiFlag;
    private String payCashonlyFlag;
    private String reservationsFlag;
    private String open24HoursFlag;
    private String attire;
    private String attireRequiredList;
    private String attireProhibitedList;
    private String parkingFlag;
    private String parkingValetFlag;
    private String parkingFreeFlag;
    private String parkingGarageFlag;
    private String parkingLotFlag;
    private String parkingStreetFlag;
    private String parkingValidatedFlag;
    private String smokingFlag;
    private String accessibleWheelchairFlag;
    private String alcoholFlag;
    private String alcoholBarFlag;
    private String alcoholBeerWineFlag;
    private String alcoholByobFlag;
    private String groupsGoodForFlag;
    private String kidsGoodForFlag;
    private String kidsMenuFlag;
    private String mealBreakfastFlag;
    private String mealCaterFlag;
    private String mealDeliverFlag;
    private String mealDinnerFlag;
    private String mealLunchFlag;
    private String mealTakeoutFlag;
    private String optionsGlutenfreeFlag;
    private String optionsLowfatFlag;
    private String optionsOrganicFlag;
    private String optionsVeganFlag;
    private String optionsVegetarianFlag;
    private String roomPrivateFlag;
    private String seatingOutdoorFlag;
    private String address;
    private String lat;
    private String lon;

    @XmlElement
    public String getPhoneNumber() {
        return phoneNumber;
    }

    @XmlElement
    public String getWebsite() {
        return website;
    }

    @XmlElement
    public String getHealthyOptionsFlag() {
        return healthyOptionsFlag;
    }

    @XmlElement
    public String getWifiFlag() {
        return wifiFlag;
    }

    @XmlElement
    public String getPayCashonlyFlag() {
        return payCashonlyFlag;
    }

    @XmlElement
    public String getReservationsFlag() {
        return reservationsFlag;
    }

    @XmlElement
    public String getOpen24HoursFlag() {
        return open24HoursFlag;
    }

    @XmlElement
    public String getAttire() {
        return attire;
    }

    @XmlElement
    public String getAttireRequiredList() {
        return attireRequiredList;
    }

    @XmlElement
    public String getAttireProhibitedList() {
        return attireProhibitedList;
    }

    @XmlElement
    public String getParkingFlag() {
        return parkingFlag;
    }

    @XmlElement
    public String getParkingValetFlag() {
        return parkingValetFlag;
    }

    @XmlElement
    public String getParkingFreeFlag() {
        return parkingFreeFlag;
    }

    @XmlElement
    public String getParkingGarageFlag() {
        return parkingGarageFlag;
    }

    @XmlElement
    public String getParkingLotFlag() {
        return parkingLotFlag;
    }

    @XmlElement
    public String getParkingStreetFlag() {
        return parkingStreetFlag;
    }

    @XmlElement
    public String getParkingValidatedFlag() {
        return parkingValidatedFlag;
    }

    @XmlElement
    public String getSmokingFlag() {
        return smokingFlag;
    }

    @XmlElement
    public String getAccessibleWheelchairFlag() {
        return accessibleWheelchairFlag;
    }

    @XmlElement
    public String getAlcoholFlag() {
        return alcoholFlag;
    }

    @XmlElement
    public String getAlcoholBarFlag() {
        return alcoholBarFlag;
    }

    public String getAlcoholBeerWineFlag() {
        return alcoholBeerWineFlag;
    }

    @XmlElement
    public String getAlcoholByobFlag() {
        return alcoholByobFlag;
    }

    @XmlElement
    public String getGroupsGoodForFlag() {
        return groupsGoodForFlag;
    }

    @XmlElement
    public String getKidsGoodForFlag() {
        return kidsGoodForFlag;
    }

    @XmlElement
    public String getKidsMenuFlag() {
        return kidsMenuFlag;
    }

    @XmlElement
    public String getMealBreakfastFlag() {
        return mealBreakfastFlag;
    }

    @XmlElement
    public String getMealCaterFlag() {
        return mealCaterFlag;
    }

    @XmlElement
    public String getMealDeliverFlag() {
        return mealDeliverFlag;
    }

    @XmlElement
    public String getMealDinnerFlag() {
        return mealDinnerFlag;
    }

    @XmlElement
    public String getMealLunchFlag() {
        return mealLunchFlag;
    }

    @XmlElement
    public String getMealTakeoutFlag() {
        return mealTakeoutFlag;
    }

    @XmlElement
    public String getOptionsGlutenfreeFlag() {
        return optionsGlutenfreeFlag;
    }

    @XmlElement
    public String getOptionsLowfatFlag() {
        return optionsLowfatFlag;
    }

    @XmlElement
    public String getOptionsOrganicFlag() {
        return optionsOrganicFlag;
    }

    @XmlElement
    public String getOptionsVeganFlag() {
        return optionsVeganFlag;
    }

    @XmlElement
    public String getOptionsVegetarianFlag() {
        return optionsVegetarianFlag;
    }

    @XmlElement
    public String getRoomPrivateFlag() {
        return roomPrivateFlag;
    }

    @XmlElement
    public String getSeatingOutdoorFlag() {
        return seatingOutdoorFlag;
    }

    @XmlElement
    public String getAddress() {
        return address;
    }

    @XmlElement
    public String getLat() {
        return lat;
    }

    @XmlElement
    public String getLon() {
        return lon;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public void setHealthyOptionsFlag(String healthyOptionsFlag) {
        this.healthyOptionsFlag = healthyOptionsFlag;
    }

    public void setWifiFlag(String wifiFlag) {
        this.wifiFlag = wifiFlag;
    }

    public void setPayCashonlyFlag(String payCashonlyFlag) {
        this.payCashonlyFlag = payCashonlyFlag;
    }

    public void setReservationsFlag(String reservationsFlag) {
        this.reservationsFlag = reservationsFlag;
    }

    public void setOpen24HoursFlag(String open24HoursFlag) {
        this.open24HoursFlag = open24HoursFlag;
    }

    public void setAttire(String attire) {
        this.attire = attire;
    }

    public void setAttireRequiredList(String attireRequiredList) {
        this.attireRequiredList = attireRequiredList;
    }

    public void setAttireProhibitedList(String attireProhibitedList) {
        this.attireProhibitedList = attireProhibitedList;
    }

    public void setParkingFlag(String parkingFlag) {
        this.parkingFlag = parkingFlag;
    }

    public void setParkingValetFlag(String parkingValetFlag) {
        this.parkingValetFlag = parkingValetFlag;
    }

    public void setParkingFreeFlag(String parkingFreeFlag) {
        this.parkingFreeFlag = parkingFreeFlag;
    }

    public void setParkingGarageFlag(String parkingGarageFlag) {
        this.parkingGarageFlag = parkingGarageFlag;
    }

    public void setParkingLotFlag(String parkingLotFlag) {
        this.parkingLotFlag = parkingLotFlag;
    }

    public void setParkingStreetFlag(String parkingStreetFlag) {
        this.parkingStreetFlag = parkingStreetFlag;
    }

    public void setParkingValidatedFlag(String parkingValidatedFlag) {
        this.parkingValidatedFlag = parkingValidatedFlag;
    }

    public void setSmokingFlag(String smokingFlag) {
        this.smokingFlag = smokingFlag;
    }

    public void setAccessibleWheelchairFlag(String accessibleWheelchairFlag) {
        this.accessibleWheelchairFlag = accessibleWheelchairFlag;
    }

    public void setAlcoholFlag(String alcoholFlag) {
        this.alcoholFlag = alcoholFlag;
    }

    public void setAlcoholBarFlag(String alcoholBarFlag) {
        this.alcoholBarFlag = alcoholBarFlag;
    }

    public void setAlcoholBeerWineFlag(String alcoholBeerWineFlag) {
        this.alcoholBeerWineFlag = alcoholBeerWineFlag;
    }

    public void setAlcoholByobFlag(String alcoholByobFlag) {
        this.alcoholByobFlag = alcoholByobFlag;
    }

    public void setGroupsGoodForFlag(String groupsGoodForFlag) {
        this.groupsGoodForFlag = groupsGoodForFlag;
    }

    public void setKidsGoodForFlag(String kidsGoodForFlag) {
        this.kidsGoodForFlag = kidsGoodForFlag;
    }

    public void setKidsMenuFlag(String kidsMenuFlag) {
        this.kidsMenuFlag = kidsMenuFlag;
    }

    public void setMealBreakfastFlag(String mealBreakfastFlag) {
        this.mealBreakfastFlag = mealBreakfastFlag;
    }

    public void setMealCaterFlag(String mealCaterFlag) {
        this.mealCaterFlag = mealCaterFlag;
    }

    public void setMealDeliverFlag(String mealDeliverFlag) {
        this.mealDeliverFlag = mealDeliverFlag;
    }

    public void setMealDinnerFlag(String mealDinnerFlag) {
        this.mealDinnerFlag = mealDinnerFlag;
    }

    public void setMealLunchFlag(String mealLunchFlag) {
        this.mealLunchFlag = mealLunchFlag;
    }

    public void setMealTakeoutFlag(String mealTakeoutFlag) {
        this.mealTakeoutFlag = mealTakeoutFlag;
    }

    public void setOptionsGlutenfreeFlag(String optionsGlutenfreeFlag) {
        this.optionsGlutenfreeFlag = optionsGlutenfreeFlag;
    }

    public void setOptionsLowfatFlag(String optionsLowfatFlag) {
        this.optionsLowfatFlag = optionsLowfatFlag;
    }

    public void setOptionsOrganicFlag(String optionsOrganicFlag) {
        this.optionsOrganicFlag = optionsOrganicFlag;
    }

    public void setOptionsVeganFlag(String optionsVeganFlag) {
        this.optionsVeganFlag = optionsVeganFlag;
    }

    public void setOptionsVegetarianFlag(String optionsVegetarianFlag) {
        this.optionsVegetarianFlag = optionsVegetarianFlag;
    }

    public void setRoomPrivateFlag(String roomPrivateFlag) {
        this.roomPrivateFlag = roomPrivateFlag;
    }

    public void setSeatingOutdoorFlag(String seatingOutdoorFlag) {
        this.seatingOutdoorFlag = seatingOutdoorFlag;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }
}
