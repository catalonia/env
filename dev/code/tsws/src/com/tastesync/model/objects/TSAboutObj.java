package com.tastesync.model.objects;

import java.io.Serializable;

import com.sun.xml.txw2.annotation.XmlElement;

public class TSAboutObj implements Serializable{
	private static final long serialVersionUID = 1L;
	private String order;
	private String content;
	
	@XmlElement
	public String getOrder() {
		return order;
	}
	
	public void setOrder(String order) {
		this.order = order;
	}
	
	@XmlElement
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}

}
