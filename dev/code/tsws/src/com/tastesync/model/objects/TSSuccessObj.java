package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "success")
public class TSSuccessObj implements Serializable {
    private static final long serialVersionUID = -8101624355208353751L;
    private String successMsg;

    public TSSuccessObj() {
        super();
    }

    @XmlElement
    public String getSuccessMsg() {
        return successMsg;
    }

    public void setSuccessMsg(String successMsg) {
        this.successMsg = successMsg;
    }
}
