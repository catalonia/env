package com.tastesync.model.objects;

import java.io.Serializable;

import java.util.Comparator;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "initdescriptordata")
public class TSInitDescriptorDataObj implements Serializable {
    private static final long serialVersionUID = -2237639625417579167L;
    private Integer order = 0;
    private String id;
    private String name;
    private String tilePicture = "";
    private String type;

    public TSInitDescriptorDataObj() {
        super();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }

        if (obj == null) {
            return false;
        }

        if (getClass() != obj.getClass()) {
            return false;
        }

        TSInitDescriptorDataObj other = (TSInitDescriptorDataObj) obj;

        if (id == null) {
            if (other.id != null) {
                return false;
            }
        } else if (!id.equals(other.id)) {
            return false;
        }

        if (name == null) {
            if (other.name != null) {
                return false;
            }
        } else if (!name.equals(other.name)) {
            return false;
        }

        if (order == null) {
            if (other.order != null) {
                return false;
            }
        } else if (!order.equals(other.order)) {
            return false;
        }

        if (tilePicture == null) {
            if (other.tilePicture != null) {
                return false;
            }
        } else if (!tilePicture.equals(other.tilePicture)) {
            return false;
        }

        if (type == null) {
            if (other.type != null) {
                return false;
            }
        } else if (!type.equals(other.type)) {
            return false;
        }

        return true;
    }

    @XmlElement
    public String getId() {
        return id;
    }

    @XmlElement
    public String getName() {
        return name;
    }

    @XmlElement
    public String getTilePicture() {
        return tilePicture;
    }

    @XmlElement
    public String getType() {
        return type;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = (prime * result) + ((id == null) ? 0 : id.hashCode());
        result = (prime * result) + ((name == null) ? 0 : name.hashCode());
        result = (prime * result) + ((order == null) ? 0 : order.hashCode());
        result = (prime * result) +
            ((tilePicture == null) ? 0 : tilePicture.hashCode());
        result = (prime * result) + ((type == null) ? 0 : type.hashCode());

        return result;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    public void setTilePicture(String tilePicture) {
        this.tilePicture = tilePicture;
    }

    public void setType(String type) {
        this.type = type;
    }

    public class TSInitDataObjComparator implements Comparator<TSInitDescriptorDataObj> {
        @Override
        public int compare(TSInitDescriptorDataObj o1,
            TSInitDescriptorDataObj o2) {
            return o1.order.compareTo(o2.order);
        }
    }
}
