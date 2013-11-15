package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "autopub")
public class TSSocialAutoPubSettingsObj implements Serializable {
    private static final long serialVersionUID = -4829873875708388338L;
    private String usncORDER;
    private String usncYN;
    
    @XmlElement
	public String getUsncORDER() {
		return usncORDER;
	}
    
	public void setUsncORDER(String usncORDER) {
		this.usncORDER = usncORDER;
	}
	
	@XmlElement
	public String getUsncYN() {
		return usncYN;
	}
	
	public void setUsncYN(String usncYN) {
		this.usncYN = usncYN;
	}
    
}
