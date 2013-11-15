package com.tastesync.util;

public enum TSResponseStatusCode {//Define all errors including for custom error cases!
    SUCCESS(200),ERROR_UNAUTHORIZED(401),
    ERROR_NOT_FOUND(404),
    ERROR_CONFLICT(409),
    ERROR(500),INVALIDDATA(400);

    private int value;

    private TSResponseStatusCode(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
