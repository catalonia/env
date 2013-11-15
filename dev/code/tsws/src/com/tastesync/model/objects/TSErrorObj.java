package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "error")
public class TSErrorObj implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = 1926832758538096389L;
    
    private String errorMsg;

    @XmlElement
    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

	@Override
	public String toString() {
		return "TSErrorObj [errorMsg=" + errorMsg + "]";
	}
    
}
