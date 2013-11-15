package com.tastesync.util;

public interface TSConstants {
    public static final String TSDB_JNDI = "jdbc/TastesyncDB";
    public static final String EMPTY_STRING = "";
    public static final String[] EMPTY_STRING_ARRAY = new String[] {  };
    public static final String ERROR_USER_SYSTEM_KEY = "error_user_system";
    public static final String ERROR_UNKNOWN_SYSTEM_KEY = "error_system";
    public static final String ERROR_INVALID_INPUT_DATA_KEY = "error_invalid_data";
    public static final String USNC_APP_FACEBOOK = "1";
    public static final String USNC_APP_TWITTER = "2";
    public static final String INT_INSERT="1";
    public static final String INT_DELETE="0";
    public static final String EX_CLASS="EX_CLASS";
    public static final String ERR_CODE="ERR_CODE";
    public static final String EMPTY="EMPTY";
    public static final String RECONOTIFICATION_TYPE_NEEDED="1";

    public static final String RECONOTIFICATION_TYPE_ANSWER="2";

    public static final String RECONOTIFICATION_TYPE_FOLLOWUP="3";

    public static final String RECONOTIFICATION_TYPE_MESSAGE="4";

    public static final String RECONOTIFICATION_TYPE_LIKE="5";
    
    public static final String RECONOTIFICATION_TYPE_DID_LIKE="6";
    
    public static final int PAGINATION_GAP=10;
    
    public static final String SEND_PUSH_NOTIFICATIONS_SCRIPT = "./pushnotification/SendPushNotificationsInstant.sh";

    public static final String BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT = "SendPushNotificationsInstant";

    
    public static final String TRIGGER_ALGO1_SCRIPT = "./algo/TriggerAlgo1.sh";

    public static final String BASENAME_TRIGGER_ALGO1_SCRIPT1 = "TriggerAlgo1";

    //public static final boolean OAUTH_SWTICHED_ON = true;
    public static final boolean OAUTH_SWTICHED_ON = false;

}
