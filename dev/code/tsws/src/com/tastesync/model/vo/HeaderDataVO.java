package com.tastesync.model.vo;

import java.io.Serializable;


public class HeaderDataVO implements Serializable {
    private static final long serialVersionUID = 3876406166936006456L;
    private String identifierForVendor;
    private String inputOauthToken;

    public HeaderDataVO(String identifierForVendor, String inputOauthToken) {
        super();
        this.identifierForVendor = identifierForVendor;
        this.inputOauthToken = inputOauthToken;
    }

    public String getIdentifierForVendor() {
        return identifierForVendor;
    }

    public String getInputOauthToken() {
        return inputOauthToken;
    }

	@Override
	public String toString() {
		return "HeaderDataVO [identifierForVendor=" + identifierForVendor
				+ ", inputOauthToken=" + inputOauthToken + "]";
	}
    
}
