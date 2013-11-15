package com.tastesync.exception;

public class TasteSyncException extends Exception {
    /**
     *
     */
    private static final long serialVersionUID = -4404730858906707149L;

    public TasteSyncException() {
        super();
    }

    public TasteSyncException(String message, Throwable cause) {
        super(message, cause);
    }

    public TasteSyncException(String message) {
        super(message);
    }

    public TasteSyncException(Throwable cause) {
        super(cause);
    }
}
