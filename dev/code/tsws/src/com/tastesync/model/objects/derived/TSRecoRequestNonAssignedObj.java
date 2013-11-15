package com.tastesync.model.objects.derived;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "recorequestnonassigned")
public class TSRecoRequestNonAssignedObj implements Serializable {
    private static final long serialVersionUID = -8428376283996280440L;
    private String recoRequestId;
    private List<String> nonassignedFacebookIdList = new ArrayList<String>();

    public TSRecoRequestNonAssignedObj() {
        super();
    }

    @XmlElement
    public String getRecoRequestId() {
        return recoRequestId;
    }

    @XmlElement
    public List<String> getNonassignedFacebookIdList() {
        return nonassignedFacebookIdList;
    }

    public void setRecoRequestId(String recoRequestId) {
        this.recoRequestId = recoRequestId;
    }

    public void setNonassignedFacebookIdList(
        List<String> nonassignedFacebookIdList) {
        this.nonassignedFacebookIdList = nonassignedFacebookIdList;
    }
}
