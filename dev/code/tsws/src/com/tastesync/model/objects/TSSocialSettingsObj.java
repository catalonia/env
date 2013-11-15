package com.tastesync.model.objects;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "social")
public class TSSocialSettingsObj implements Serializable {
    private static final long serialVersionUID = 6457481134997945030L;
    private String usncORDER;
    private String usncYN;
    private TSSocialAutoPubSettingsObj[] auto_publishing;
    
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
	
	@XmlElement
	public TSSocialAutoPubSettingsObj[] getAuto_publishing() {
		return auto_publishing;
	}
	
	public void setAuto_publishing(TSSocialAutoPubSettingsObj[] auto_publishing) {
		this.auto_publishing = auto_publishing;
	}

}
