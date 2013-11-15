package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "restaurantquesionnontsassigned")
public class TSRestaurantQuesionNonTsAssignedObj implements Serializable {
    private static final long serialVersionUID = 481809116742399539L;
    private String questionId;
    private List<String> friendsNonTsUserFacebookId = new ArrayList<String>();

    @XmlElement
    public String getQuestionId() {
        return questionId;
    }

    @XmlElement
    public List<String> getFriendsNonTsUserFacebookId() {
        return friendsNonTsUserFacebookId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public void setFriendsNonTsUserFacebookId(
        List<String> friendsNonTsUserFacebookId) {
        this.friendsNonTsUserFacebookId = friendsNonTsUserFacebookId;
    }
}
