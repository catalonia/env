package com.tastesync.model.objects;

import org.codehaus.jettison.json.JSONArray;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "jsonkeyvalue")
public class TSJSONArrayObj implements Serializable {
    private static final long serialVersionUID = 5303137087584188626L;
    private String keyJsonArrayName;
    private JSONArray valueJsonArray;

    public TSJSONArrayObj() {
        super();
    }

    @XmlElement
    public String getKeyJsonArrayName() {
        return keyJsonArrayName;
    }

    @XmlElement
    public JSONArray getValueJsonArray() {
        return valueJsonArray;
    }

    public void setKeyJsonArrayName(String keyJsonArrayName) {
        this.keyJsonArrayName = keyJsonArrayName;
    }

    public void setValueJsonArray(JSONArray valueJsonArray) {
        this.valueJsonArray = valueJsonArray;
    }
}
