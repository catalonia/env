package com.tastesync.model.objects;

import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONTokener;

import java.io.Serializable;
import java.util.Map;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "keyvalue")
public class TSKeyValueObj extends JSONObject implements Serializable {
    private static final long serialVersionUID = -4654745503303978299L;
    public static String KEY = "key";
    public static String VALUE = "value";
    private String keyName;
    private String keyNameValue;
    private String valueName;
    private String valueNameValue;



    public TSKeyValueObj() {
		super();
	}

	public TSKeyValueObj(JSONObject arg0, String[] arg1) throws JSONException {
		super(arg0, arg1);
	}

	public TSKeyValueObj(JSONTokener x) throws JSONException {
		super(x);
	}

	public TSKeyValueObj(Map arg0) {
		super(arg0);
	}

	public TSKeyValueObj(Object arg0, String[] arg1) {
		super(arg0, arg1);
	}

	public TSKeyValueObj(String string) throws JSONException {
		super(string);
	}

	@XmlElement
    public String getKeyName() {
        return keyName;
    }

    public void setKeyName(String keyName) {
        this.keyName = keyName;
    }

    @XmlElement
    public String getKeyNameValue() {
        return keyNameValue;
    }

    public void setKeyNameValue(String keyNameValue) {
        this.keyNameValue = keyNameValue;
    }

    @XmlElement
    public String getValueName() {
        return valueName;
    }

    public void setValueName(String valueName) {
        this.valueName = valueName;
    }

    @XmlElement
    public String getValueNameValue() {
        return valueNameValue;
    }

    public void setValueNameValue(String valueNameValue) {
        this.valueNameValue = valueNameValue;
    }
}
