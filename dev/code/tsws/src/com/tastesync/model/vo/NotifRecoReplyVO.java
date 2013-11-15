package com.tastesync.model.vo;

import java.io.Serializable;

public class NotifRecoReplyVO  implements Serializable {

	private static final long serialVersionUID = -1768138433196719075L;
	private String replyId;
    private String replyActioned;

    public NotifRecoReplyVO() {
        super();
    }

    public String getReplyId() {
        return replyId;
    }

    public String getReplyActioned() {
        return replyActioned;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }

    public void setReplyActioned(String replyActioned) {
        this.replyActioned = replyActioned;
    }
}
