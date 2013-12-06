package com.tastesync.db.queries;

public interface UserQueries extends TSDBCommonQueries {
    //USERS
    public static final String USER_SELECT_SQL = "SELECT " + " users.USER_ID," +
        " users.TS_USER_ID," + " users.TS_USER_EMAIL," + " users.TS_USER_PW," +
        " users.TS_FIRST_NAME," + " users.TS_LAST_NAME," +
        " users.MAX_INVITES," + " users.USER_CREATED_INITIAL_DATETIME," +
        " users.USER_POINTS," + " users.TWITTER_USR_URL," +
        " users.USER_DISABLED_FLAG," + " users.USER_ACTIVATION_KEY," +
        " users.USER_GENDER," + " users.USER_CITY_ID," + " users.USER_STATE," +
        " users.IS_ONLINE," + " users.USER_COUNTRY," + " users.ABOUT," +
        " users.CURRENT_STATUS," + " users.USER_FB_ID" + " FROM " + " users " +
        "WHERE users.USER_ID= " + " ?";
    public static final String USERS_SELECT_SQL = "SELECT " +
        " users.USER_ID," + " users.TS_USER_ID," + " users.TS_USER_EMAIL," +
        " users.TS_USER_PW," + " users.TS_FIRST_NAME," +
        " users.TS_LAST_NAME," + " users.MAX_INVITES," +
        " users.USER_CREATED_INITIAL_DATETIME," + " users.USER_POINTS," +
        " users.TWITTER_USR_URL," + " users.USER_DISABLED_FLAG," +
        " users.USER_ACTIVATION_KEY," + " users.USER_GENDER," +
        " users.USER_CITY_ID," + " users.USER_STATE," + " users.IS_ONLINE," +
        " users.USER_COUNTRY," + " users.ABOUT," + " users.CURRENT_STATUS," +
        " users.USER_FB_ID" + " FROM " + " users ";
    public static final String USERS_INSERT_SQL = "INSERT INTO users (" +
        " users.USER_ID, " + "users.TS_USER_ID, " + "users.TS_USER_EMAIL, " +
        "users.TS_USER_PW, " + "users.TS_FIRST_NAME, " +
        "users.TS_LAST_NAME, " + "users.MAX_INVITES, " +
        "users.USER_CREATED_INITIAL_DATETIME, " + "users.USER_POINTS, " +
        "users.TWITTER_USR_URL, " + "users.USER_DISABLED_FLAG, " +
        "users.USER_ACTIVATION_KEY, " + "users.USER_GENDER, " +
        "users.USER_CITY_ID, " + "users.USER_STATE, " + "users.IS_ONLINE, " +
        "users.USER_COUNTRY, " + "users.ABOUT, " + "users.CURRENT_STATUS, " +
        "users.USER_FB_ID " + ") VALUES (" + "?," + // users.USER_ID",
        "?," + // "users.TS_USER_ID",
        "?," + // "users.TS_USER_EMAIL",
        "?," + // "users.TS_USER_PW",
        "?," + // "users.TS_FIRST_NAME",
        "?," + // "users.TS_LAST_NAME",
        "?," + // "users.MAX_INVITES",
        "?," + // "users.USER_CREATED_INITIAL_DATETIME",
        "?," + // "users.USER_POINTS",
        "?," + // "users.TWITTER_USR_URL",
        "?," + // "users.USER_DISABLED_FLAG",
        "?," + // "users.USER_ACTIVATION_KEY",
        "?," + // "users.USER_GENDER",
        "?," + // "users.USER_CITY_ID",
        "?," + // "users.USER_STATE",
        "?," + // "users.IS_ONLINE",
        "?," + // "users.USER_COUNTRY",
        "?," + // "users.ABOUT",
        "?," + // "users.CURRENT_STATUS"
        "?" + // "users.USER_FB_ID",
        ")";
    public static String USER_LOGIN_SELECT_SQL = "SELECT " + " users.USER_ID," +
        " users.TS_USER_ID," + " users.TS_USER_EMAIL," + " users.TS_USER_PW," +
        " users.TS_FIRST_NAME," + " users.TS_LAST_NAME," +
        " users.MAX_INVITES," + " users.USER_CREATED_INITIAL_DATETIME," +
        " users.USER_POINTS," + " users.TWITTER_USR_URL," +
        " users.USER_DISABLED_FLAG," + " users.USER_ACTIVATION_KEY," +
        " users.USER_GENDER," + " users.USER_CITY_ID," + " users.USER_STATE," +
        " users.IS_ONLINE," + " users.USER_COUNTRY," + " users.ABOUT," +
        " users.CURRENT_STATUS," + " users.USER_FB_ID" + " FROM " + " users " +
        " WHERE TS_USER_EMAIL = ? " + "AND TS_USER_PW = ?";
    public static String USER_ONLINE_UPDATE_SQL = "UPDATE users " +
        "SET IS_ONLINE = ? , IS_ONLINE_UPDATED_DATETIME = ? " +
        "WHERE USER_ID = ?";
    public static String USER_STATUS_SELECT_SQL = "SELECT * FROM users WHERE USER_ID = ? AND CURRENT_STATUS = ?";
    public static String USER_CHECK_EMAIL_SELECT_SQL = "SELECT * FROM users WHERE TS_USER_EMAIL = ?";
    public static String USER_CHECK_EMAIL_STATUS_SELECT_SQL = "SELECT users.USER_ID, " +
        "users.TS_USER_ID, " + "users.TS_USER_EMAIL, " +
        "users.TS_FIRST_NAME, " + "users.TS_LAST_NAME, " +
        "users.MAX_INVITES, " + "users.USER_CREATED_INITIAL_DATETIME, " +
        "users.USER_POINTS, " + "users.TWITTER_USR_URL, " +
        "users.USER_DISABLED_FLAG, " + "users.USER_ACTIVATION_KEY, " +
        "users.USER_GENDER, " + "users.USER_CITY_ID, " + "users.USER_STATE, " +
        "users.IS_ONLINE, " + "users.USER_COUNTRY, " +
        "users.CURRENT_STATUS, " + "users.ABOUT, " + "users.USER_FB_ID " +
        "FROM users WHERE TS_USER_EMAIL = ? " +
        "AND (CURRENT_STATUS = ? OR CURRENT_STATUS = ?)";
    public static String USER_FBID_SELECT_SQL = "SELECT * FROM users WHERE User_FB_ID = ? AND CURRENT_STATUS = ?";
    public static String USER_FBID_UPDATE_SQL = "UPDATE users SET USER_FB_ID = ? WHERE USER_ID = ?";
    public static String USERID_SELECT_SQL = "SELECT * FROM facebook_user_data WHERE USER_FB_ID IN (SELECT USER_FB_ID FROM users WHERE USER_ID = ?)";
    public static String USER_FACEBOOK_ID_SELECT_SQL = "SELECT users.USER_ID, " +
        "users.TS_USER_ID, " + "users.TS_USER_EMAIL, " +
        "users.TS_FIRST_NAME, " + "users.TS_LAST_NAME, " +
        "users.MAX_INVITES, " + "users.USER_CREATED_INITIAL_DATETIME, " +
        "users.USER_POINTS, " + "users.TWITTER_USR_URL, " +
        "users.USER_DISABLED_FLAG, " + "users.USER_ACTIVATION_KEY, " +
        "users.USER_GENDER, " + "users.USER_CITY_ID, " + "users.USER_STATE, " +
        "users.IS_ONLINE, " + "users.USER_COUNTRY, " +
        "users.CURRENT_STATUS, " + "users.ABOUT, " + "users.USER_FB_ID " +
        " FROM users " + "WHERE USER_ID " +
        "IN (SELECT user_friend_tastesync.FRIEND_ID FROM user_friend_tastesync WHERE USER_ID = ?)";

    // public static String USER_ID_UPDATE_SQL = "UPDATE users SET USER_ID = ?"+ ", TS_USER_ID = ?" +" WHERE Auto_User_ID = ?";
    public static String USER_FACEBOOK_INSERT_SQL = "INSERT INTO users " +
        "(TS_USER_EMAIL, " + "USER_CREATED_INITIAL_DATETIME, " +
        "TS_FIRST_NAME, " + "TS_LAST_NAME, " + "USER_GENDER, " +
        "USER_CITY_ID, " + /*"USER_CITY, " +*/
        "USER_STATE, " + "USER_COUNTRY," + " USER_FB_ID," + "USER_ID," +
        "TS_USER_ID)" + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    public static String USER_ABOUT_UPDATE_SQL = "UPDATE users SET ABOUT = ? WHERE USER_ID = ?";

    //FACEBOOK_USER_DATA
    public static String FACEBOOK_SELECT_SQL = "SELECT * FROM facebook_user_data WHERE User_FB_ID = ?";
    public static String FACEBOOK_INSERT_SQL = "INSERT INTO facebook_user_data " +
        "(User_FB_ID, " + "NAME, " + "FIRST_NAME, " + "MIDDLE_NAME, " +
        "LAST_NAME, " + "GENDER, " + "LOCALE, " + "LINK, " + "USERNAME, " +
        "AGE_RANGE, " + "BIRTHDAY, " + "THIRD_PARTY_ID, " + "FRIENDLISTS, " +
        "INSTALLED, " + "TIMEZONE, " + "UPDATE_TIME, " + "VERIFIED, " +
        "DEVICES, " + "EMAIL, " + "HOMETOWN, " + "LOCATION, " + "PICTURE, " +
        "RELATIONSHIP_STATUS, " + "CHECKINS, " + "FRIENDS, " + "LIKES, " +
        "PERMISSIONS, " + "CREATED)" +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    public static String FACEBOOK_UPDATE_SQL = "UPDATE facebook_user_data SET " +
        "NAME = ?, " + "FIRST_NAME = ?, " + "MIDDLE_NAME = ?, " +
        "LAST_NAME = ?, " + "GENDER = ?, " + "LOCALE = ?, " + "LINK = ?, " +
        "USERNAME = ?, " + "AGE_RANGE = ?, " + "BIRTHDAY = ?, " +
        "THIRD_PARTY_ID = ?, " + "FRIENDLISTS = ?, " + "INSTALLED = ?, " +
        "TIMEZONE = ?, " + "UPDATE_TIME = ?, " + "VERIFIED = ?, " +
        "DEVICES = ?, " + "EMAIL = ?, " + "HOMETOWN = ?, " + "LOCATION = ?, " +
        "PICTURE = ?, " + "RELATIONSHIP_STATUS = ?, " + "CHECKINS = ?, " +
        "FRIENDS = ?, " + "LIKES = ?, " + "PERMISSIONS = ?, " + "CREATED = ? " +
        "WHERE User_FB_ID = ?";

    //USERS_LOG
    public static String USER_LOGIN_INSERT_SQL = "INSERT INTO users_log (USER_ID, LOGIN_DATETIME, " +
        "USERS_CREATED_LATEST_DATETIME, LOG_ID) VALUES (?, ?, ?, ?)";
    public static String USERLOG_EMAIL_SELECT_SQL = "SELECT * FROM users_log WHERE USER_ID = ?";
    public static String USER_LOGIN_UPDATE_SQL = "UPDATE users_log " +
        "SET LOGIN_DATETIME = ? " + "WHERE USER_ID = ?";
    public static String USERSLOG_LOGOUT_UPDATE_SQL = "UPDATE users_log " +
        "SET LOGOUT_DATETIME = ? " + "WHERE LOG_ID = ?";
    public static String USER_ID_FROM_USERLOG_SELECT_SQL = "SELECT * FROM users_log WHERE LOG_ID = ?";
    public static String USER_LOGOUT_INSERT_SQL = "" +
        "INSERT INTO `users_log` " + " (`users_log`.`log_id`, " +
        " `users_log`.`login_datetime`, " + " `users_log`.`logout_datetime`, " +
        " `users_log`.`user_id`, " +
        " `users_log`.`users_created_latest_datetime`) " + "VALUES ( ?, " +
        " ?, " + " ?, " + " ?, " + " ? )";
    public static String USER_LOGOUT_UPDATE_SQL = "UPDATE users_log " +
        "SET LOGOUT_DATETIME = ? " + "WHERE USER_ID = ?" +
        " AND LOGOUT_DATETIME IS NULL";
    public static String USERLOG_LOGID_UPDATE_SQL = "UPDATE users_log SET LOG_ID = ? WHERE Auto_Log_ID = ?";

    //STORY
    public static String STORY_INSERT_SQL = "INSERT INTO story (STORY_CREATED_DATETIME, ACTION_ID_TYPE, USER_ID, UPDATED_DATETIME) VALUES (?, ?, ?, ?)";
    public static String STORY_UPDATE_SQL = "UPDATE story SET STORY_ID = ? WHERE Auto_Story_ID = ?";

    //USER_USNC
    public static String USER_SOCIAL_SETTINGS_SELECT_SQL = "" +
        "SELECT `user_usnc`.`usnc_yn`" + "FROM user_usnc " +
        "WHERE `user_usnc`.`user_id` = ? " + " AND -- userId " +
        " `user_usnc`.`usnc_id` = ? ";
    public static String USER_SOCIAL_APID_SETTINGS_SELECT_SQL = "" +
        "SELECT `user_usnc`.`usnc_yn`" + "FROM user_usnc " +
        "WHERE `user_usnc`.`user_id` = ? " + " AND -- userId " +
        " `user_usnc`.`usnc_id` = ? " + "AND `usg_usnc_ap`.`AP_ID` = ?";
    public static String USER_USNC_UPDATE_SQL = "UPDATE user_usnc SET USNC_YN = ? WHERE USER_ID = ? AND USNC_ID = ?";
    public static String USER_USNC_INSERT_SQL = "INSERT INTO user_usnc (USNC_ID, USNC_YN, USER_ID) VALUES (?, ?, ?)";
    public static String USER_USNC_SELECT_SQL = "SELECT * FROM user_usnc WHERE USER_ID = ?";

    //USG_USNC_AP
    public static String USER_SOCIAL_APID_SETTINGS_UPDATE_SQL = "" +
        "UPDATE `usg_usnc_ap` " +
        "SET `usg_usnc_ap`.`usnc_yn` = ? -- statusFlag " +
        "WHERE `usg_usnc_ap`.`user_id` = ? " + " AND -- userId " +
        " `usg_usnc_ap`.`ap_id` = ? " + " AND -- autoPublishingId " +
        " `usg_usnc_ap`.`usnc_id` = ?-- socialNetworkId " + "";
    public static String USER_SOCIAL_APID_SELECT_SQL = "SELECT * FROM auto_publishing WHERE AP_ORDER = ?";
    public static String USER_SOCIAL_AP_SELECT_SQL = "SELECT * FROM auto_publishing";
    public static String USER_SOCIAL_APID_UPDATE_SQL = "UPDATE usg_usnc_ap SET USNC_YN = ?" +
        " WHERE USER_ID = ? AND USNC_ID = ? AND AP_ID = ?";
    public static String USER_SOCIAL_APID_INSERT_SQL = "INSERT INTO usg_usnc_ap (USNC_ID, AP_ID, USNC_YN, USER_ID) VALUES (?, ?, ?, ?)";
    public static String USER_SOCIAL_APID_USERID_SELECT_SQL = "SELECT * FROM usg_usnc_ap WHERE USER_ID = ?";

    //USER_NOTIFICATION_SETTINGS
    public static String USER_NOTIFICATION_SETTINGS_SELECT_SQL = "" +
        "SELECT `user_notification_settings`.`nsid`,-- notificationSettingsId " +
        " `user_notification_settings`.`ns_mobile_flag`,-- phoneFlag " +
        " `user_notification_settings`.`ns_email_flag` -- emailFlag " +
        "FROM `user_notification_settings` " +
        "WHERE `user_notification_settings`.`user_id` = ? -- userId " + "";
    public static String USER_NOTIFICATION_SETTINGS_UPDATE_SQL = "" +
        "UPDATE `user_notification_settings` " +
        "SET `user_notification_settings`.`ns_mobile_flag` = ?,-- " +
        " `user_notification_settings`.`ns_email_flag` = ? " +
        "WHERE `user_notification_settings`.`user_id` = ? " +
        " AND `user_notification_settings`.`nsid` = ? ";
    public static String USER_NOTIFICATION_SETTINGS_ID_SELECT_SQL = "SELECT * FROM user_notification_settings WHERE USER_ID = ?";
    public static String USER_NOTIFICATION_SETTINGS_INSERT_SQL = "INSERT INTO user_notification_settings (USER_ID, NSID, NS_MOBILE_FLAG, NS_EMAIL_FLAG) VALUES (?, ?, ?, ?)";
    public static String USER_NOTIFICATION_SETTINGS_ID_UPDATE_SQL = "UPDATE user_notification_settings SET NS_MOBILE_FLAG = ?, NS_EMAIL_FLAG = ? WHERE USER_ID = ? AND NSID = ?";

    //NOTIFICATION_DESCRIPTOR
    public static String NOTIFICATION_DESCRIPTOR_SELECT_SQL = "SELECT * FROM notification_descriptor WHERE NSID_ORDER = ?";

    //ABOUT_TASTESYNC_ELEMENT_DESCRIPTOR
    public static String ABOUT_TASTESYNC_ELEMENT_DESCRIPTOR_SELECT_SQL = "SELECT * FROM about_tastesync_element_descriptor WHERE ID_ORDER = ?";
    public static String ABOUT_TASTESYNC_ELEMENT_ALL_DESCRIPTOR_SELECT_SQL = "SELECT * FROM about_tastesync_element_descriptor";

    //USER_PRIVACY_SETTINGS
    public static String USER_PRIVACY_SETTINGS_SELECT_SQL = "" +
        "SELECT `user_privacy_settings`.`privacy_id`,-- privacySettingsId " +
        " `user_privacy_settings`.`privacy_flag` -- privacyUserFlag " +
        "FROM `user_privacy_settings` " +
        "WHERE `user_privacy_settings`.`user_id` = ? -- userId " + "";
    public static String USER_PRIVACY_SETTINGS_UPDATE_SQL = "" +
        "UPDATE `user_privacy_settings` " +
        "SET `user_privacy_settings`.`privacy_flag` = ? " +
        "WHERE `user_privacy_settings`.`user_id` = ? " +
        " `user_privacy_settings`.`privacy_id` = ?" + "";
    public static String USER_PRIVACY_SETTINGS_ID_SELECT_SQL = "SELECT * FROM user_privacy_settings WHERE USER_ID = ?";
    public static String USER_PRIVACY_SETTINGS_INSERT_SQL = "INSERT INTO user_privacy_settings (USER_ID, PRIVACY_ID, PRIVACY_FLAG) VALUES (?, ?, ?)";
    public static String USER_PRIVACY_SETTINGS_ID_UPDATE_SQL = "UPDATE user_privacy_settings SET PRIVACY_FLAG = ?WHERE USER_ID = ? AND PRIVACY_ID = ?";

    //PRIVACY_DESCIPTOR
    public static String PRIVACY_DESCRIPTOR_SELECT_SQL = "SELECT * FROM privacy_descriptor WHERE PRIVACY_ID_ORDER = ?";
    public static String PRIVACY_DESCRIPTOR_ORDER_SELECT_SQL = "SELECT * FROM privacy_descriptor WHERE PRIVACY_ID = ?";

    //CONTACT_SETTINGS_DESCRIPTOR
    public static String CONTACT_SETTINGS_DESCRIPTOR_SELECT_SQL = "SELECT * FROM contact_settings_descriptor WHERE CONTACT_ID_ORDER = ?";

    //USER_REPORTED_INFO
    public static String USER_REPORTED_INFO_INSERT_SQL = "" +
        "INSERT INTO `user_reported_info` " + " (" +
        " `user_reported_info`.`id`, " +
        " `user_reported_info`.`reported_datetime`, " +
        " `user_reported_info`.`reported_reason`, " +
        " `user_reported_info`.`reported_user_id`, " +
        " `user_reported_info`.`user_id`) " + "VALUES ( " + "?," + "?," + "?," +
        "?," + "?" + ")";

    //USER_SOCIAL_NETWORK_CONNECTION
    public static String USER_SOCIAL_NETWORK_CONNECTION_ID_SELECT_SQL = "SELECT * FROM user_social_network_connection WHERE USNC_ORDER = ?";
    public static String USER_SOCIAL_NETWORK_CONNECTION_SELECT_SQL = "SELECT * FROM user_social_network_connection";

    //USER_CONTACT_SETTINGS
    public static String USER_CONTACT_SETTINGS_INSERT_SQL = "INSERT INTO user_contact_settings(UCS_ID, USER_ID, CONTACT_ID, CONTACT_DETAILS_DESC, CONTACT_DATETIME) VALUES (?, ?, ?, ?, ?)";

    // USER_FOLLOW
    public static String USER_FOLLOW_DATA_FOLLOWING_SELECT_SQL = "SELECT users.USER_ID, facebook_user_data.NAME,  facebook_user_data.PICTURE,  facebook_user_data.LINK,  users.TWITTER_USR_URL, users.Blog_Url,  cities.city,  users.USER_POINTS, users.ABOUT, users.TS_USER_EMAIL FROM users, facebook_user_data, cities WHERE  users.USER_FB_ID =  FACEBOOK_USER_DATA.User_FB_ID AND  users.USER_CITY_ID = cities.city_id AND  users.USER_ID IN (SELECT FOLLOWEE_USER_ID FROM user_follow_data WHERE FOLLOWER_USER_ID = ?)";
    public static String USER_FOLLOW_DATA_FOLLOWERS_SELECT_SQL = "SELECT users.USER_ID, facebook_user_data.NAME,  facebook_user_data.PICTURE,  facebook_user_data.LINK,  users.TWITTER_USR_URL, users.Blog_Url,  cities.city,  users.USER_POINTS, users.ABOUT, users.TS_USER_EMAIL FROM users, facebook_user_data, cities WHERE  users.USER_FB_ID =  FACEBOOK_USER_DATA.User_FB_ID AND  users.USER_CITY_ID = cities.city_id AND  users.USER_ID IN (SELECT FOLLOWER_USER_ID FROM user_follow_data WHERE FOLLOWEE_USER_ID = ?)";
    public static String FACEBOOK_USER_DATA_SELECT_SQL = "SELECT user_friend_fb.USER_FRIEND_FB FROM user_friend_fb WHERE INVITATION_SENT_YN = '0' AND USER_ID = ?";
    public static String USER_FOLLOW_DATA_CHECK_SELECT_SQL = "SELECT * FROM user_follow_data WHERE FOLLOWER_USER_ID = ? AND FOLLOWEE_USER_ID = ?";
    public static String USER_FOLLOW_DATA_INSERT_SQL = "INSERT INTO `user_follow_data`" +
        "(`ID`, `FOLLOWER_USER_ID`, `FOLLOWEE_USER_ID`,`ALGO1_IND`)" +
        " VALUES (" + "?" + ",?" + ",?" + ",?)";
    public static String USER_FOLLOW_DATA_DELETE_SQL = "DELETE FROM user_follow_data WHERE FOLLOWER_USER_ID = ? AND FOLLOWEE_USER_ID = ?";
    public static String USER_FOLLOW_DATA_COUNT_FOLLOWING_SELECT_SQL = "SELECT COUNT(*) AS 'count' FROM user_follow_data WHERE FOLLOWER_USER_ID = ?";
    public static String USER_FOLLOW_DATA_COUNT_FOLLOWER_SELECT_SQL = "SELECT COUNT(*) AS 'count' FROM user_follow_data WHERE FOLLOWEE_USER_ID = ?";

    //USER_FRIEND_TASTESYNC
    public static String USER_FRIEND_TASTESYNC_SELECT_SQL = "SELECT * FROM user_friend_tastesync WHERE USER_ID = ?";
    public static String USER_FRIEND_TASTESYNC_CHECK_SELECT_SQL = "SELECT * FROM user_friend_tastesync WHERE USER_ID = ? AND FRIEND_ID = ?";
    public static String USER_FRIEND_TASTESYNC_INSERT_SQL = "INSERT INTO user_friend_tastesync(ID, USER_ID, FRIEND_ID, FRIEND_TRUSTED_FLAG, FRIEND_TRUSTED_ADDED_DATETIME) VALUES (?, ?, ?, ?, ?)";
    public static String USER_FRIEND_TASTESYNC_UPDATE_SQL = "UPDATE user_friend_tastesync SET FRIEND_TRUSTED_FLAG = ? WHERE USER_ID = ? AND FRIEND_ID = ?";
    public static String USER_FRIEND_TASTESYNC_DELETE_SQL = "DELETE FROM user_friend_tastesync WHERE USER_ID = ?";
    public static String USER_FRIEND_TASTESYNC_DATETIME_UPDATE_SQL = "UPDATE user_friend_tastesync SET FRIEND_TRUSTED_ADDED_DATETIME = ? WHERE USER_ID = ? AND FRIEND_ID = ?";
    public static String USER_FRIEND_TASTESYNC_DATETIME_DELETE_SQL = "DELETE FROM user_friend_tastesync WHERE USER_ID = ? AND FRIEND_TRUSTED_ADDED_DATETIME != ?";

    //USER_MESSAGE
    public static String USER_MESSAGE_INSERT_SQL = "INSERT INTO user_message(MESSAGE_ID, SENDER_ID, RECIPIENT_ID, CONTENT, CREATED) VALUES (?, ?, ?, ?, ?)";

    //CITY_NEIGHOOURHOOD
    public static String CITY_NEIGHOOURHOOD_SELECT_SQL = "SELECT * FROM city_neighbourhood WHERE CITY_ID = ?";

    //USER_CUISINE
    public static String USER_CUISINE_INSERT_SQL = "INSERT INTO user_cuisine(USER_ID, CUISINE_ID) VALUE (?, ?)";
    public static String CUISINE_DESC_CUISINE_TIER2_SELECT_SQL = "" +
        "SELECT CUISINE_DESC " + "FROM   CUISINE_TIER2_DESCRIPTOR " +
        "WHERE  CUISINE_ID = ? ";
    public static String USERS_ABOUT_UPDATE_SQL = "" + "UPDATE USERS " +
        "SET    USERS.ABOUT = ? " + "WHERE  USERS.USER_ID = ?";
    public static String USERS_CURRENT_STATUS_UPDATE_SQL = "" +
        "UPDATE USERS " + "SET    USERS.CURRENT_STATUS = ? " +
        "WHERE  USERS.USER_ID = ? ";

    //USER_FRIEND_FB
    public static String USER_FRIEND_SIGNUP_FB_UPDATE_SQL = "UPDATE user_friend_fb SET INVITATION_SENT_YN = ? WHERE USER_ID = ? AND USER_FRIEND_FB = ?";
    public static String USER_FRIEND_FB_STATUS_UPDATE_SQL = "UPDATE user_friend_fb SET USER_FRIEND_FB_STATUS = ? WHERE USER_ID = ? AND USER_FRIEND_FB = ?";
    public static String USER_FRIEND_FB_DELETE_SQL = "DELETE FROM user_friend_fb WHERE USER_ID = ?";
    public static String USER_FRIEND_FB_SECLECT_SQL = "SELECT * FROM user_friend_fb WHERE USER_ID = ? AND USER_FRIEND_FB_STATUS = ?";
    public static String USER_FRIEND_FB_DELETED_SECLECT_SQL = "SELECT * FROM user_friend_fb WHERE USER_ID = ? AND USER_FRIEND_FB_STATUS = ?";
    public static String USER_FRIEND_FB_DATETIME_DELETE_SQL = "DELETE FROM user_friend_fb WHERE USER_ID = ? AND FB_UPDATE_DATETIME != ?";
    public static String USER_FRIEND_SIGNUP_FB_INSERT_SQL = "INSERT INTO user_friend_fb(USER_ID, USER_FRIEND_FB, FB_UPDATE_DATETIME, INVITATION_SENT_YN, USER_FRIEND_FB_STATUS) VALUES (?, ?, ?, ?, ?)";

    //USER_RESTAURANT_FAV
    public static String USER_RESTAURANT_FAV_INSERT_SQL = "INSERT INTO user_restaurant_fav(USER_ID, RESTAURANT_ID, ALGO1_IND, ALGO2_IND) VALUES (?, ?, ?, ?)";

    // USER_HOME_PROFILE
    public static String USERS_FACEBOOK_USER_DATA_CITIES_SELECT_SQL = "SELECT" +
        " cities.city_id, " + " cities.state, " + " users.USER_ID, " +
        " facebook_user_data.NAME, facebook_user_data.PICTURE, " +
        " facebook_user_data.LINK, users.TWITTER_USR_URL, users.Blog_Url, " +
        " cities.city, users.USER_POINTS, users.ABOUT" +
        " FROM users, facebook_user_data, cities" +
        " WHERE users.USER_FB_ID = FACEBOOK_USER_DATA.User_FB_ID" +
        " AND users.USER_CITY_ID = cities.city_id" + " AND users.USER_ID = ?";

    // USER_RESTAURANT_FAV
    public static String USER_RESTAURANT_FAV_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_fav " + "WHERE USER_ID = ?";
    public static String USER_RESTAURANT_FAV_CHECK_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_fav " +
        "WHERE USER_ID = ? AND RESTAURANT_ID = ?";

    // USER_RESTAURANT_RECO
    public static String USER_RESTAURANT_RECO_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_reco " + "WHERE RECOMMENDER_USER_ID = ? ";
    public static String USER_RESTAURANT_RECO_CHECK_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_reco " +
        "WHERE RECOMMENDER_USER_ID = ? AND RESTAURANT_ID = ?";

    // USER_RESTAURANT_SAVED
    public static String USER_RESTAURANT_SAVED_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_saved " + "WHERE USER_ID = ?";
    public static String USER_RESTAURANT_SAVED_CHECK_SELECT_SQL = "SELECT * " +
        "FROM user_restaurant_saved " +
        "WHERE USER_ID = ? AND RESTAURANT_ID = ?";

    // RESTAURANT_TIPS_TASTESYNC
    public static String RESTAURANT_TIPS_TASTESYNC_SELECT_SQL = "SELECT * " +
        "FROM restaurant_tips_tastesync " + "WHERE USER_ID = ?";
    public static String RESTAURANT_TIPS_TASTESYNC_CHECK_SELECT_SQL = "SELECT * " +
        "FROM restaurant_tips_tastesync " +
        "WHERE USER_ID = ? AND RESTAURANT_ID = ?";

    // RESTAURANT
    public static String RESTAURANT_SELECT_SQL = "SELECT * " +
        "FROM restaurant " + "WHERE RESTAURANT_ID = ?";

    // RESTAURANT_PHOTO
    public static String RESTAURANT_PHOTO_SELECT_SQL = "SELECT * " +
        "FROM restaurant_photo " + "WHERE RESTAURANT_ID = ?";

    // CITIES
    public static String CITIES_SELECT_SQL = "SELECT * FROM cities WHERE CITY_ID = ? ";

    // RESTAURANT_CUISINE
    public static String RESTAURANT_CUISINE_SELECT_SQL = "SELECT * " +
        "FROM restaurant_cuisine " + "WHERE RESTAURANT_ID=?";

    // CUISINE_TIER2_DESCRIPTOR
    public static String CUISINE_TIER2_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM cuisine_tier2_descriptor " + "WHERE CUISINE_ID = ? ";
    public static String CUISINE_TIER2_DESCRIPTOR_ALL_SELECT_SQL = "SELECT * " +
        "FROM cuisine_tier2_descriptor WHERE CUISINE_VALID_CURRENT = '1'";

    // CUISINE_TIER1_DESCRIPTOR
    public static String CUISINE_TIER1_DESCRIPTOR_ALL_SELECT_SQL = "SELECT * " +
        "FROM cuisine_tier1_descriptor WHERE CUISINE_VALID_CURRENT = '1'";

    //OCCASION_DESCRIPTOR
    public static String OCCASION_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM occasion_descriptor WHERE Occasion_VALID_CURRENT = '1'";

    //PRICE_DESCRIPTOR
    public static String PRICE_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM price_descriptor WHERE price_VALID_CURRENT = '1'";

    //THEME_DESCRIPTOR
    public static String THEME_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM theme_descriptor WHERE theme_VALID_CURRENT = '1'";

    //TYPEOFREST_DESCRIPTOR
    public static String TYPEOFREST_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM typeofrest_descriptor WHERE typeofrest_VALID_CURRENT = '1'";

    //WHOAREYOUWITH_DESCRIPTOR
    public static String WHOAREYOUWITH_DESCRIPTOR_SELECT_SQL = "SELECT * " +
        "FROM whoareyouwith_descriptor WHERE whoareyouwith_VALID_CURRENT = '1'";

    // USER_FRIEND_FB
    public static String USER_FRIEND_FB_INSERT_SQL = "INSERT INTO `user_friend_fb`(`USER_ID`, `USER_FRIEND_FB`, `FB_UPDATE_DATETIME`, `INVITATION_SENT_YN`)" +
        "VALUES (?,?,?,?)";
    public static String USER_FRIEND_FB_UPDATE_SQL = "UPDATE `user_friend_fb`" +
        " SET `FB_UPDATE_DATETIME`=?,`INVITATION_SENT_YN`=? " +
        "WHERE USER_ID=? AND USER_FRIEND_FB=?";
    public static String USER_FRIEND_FB_CHECK_SELECT_SQL = "SELECT * " +
        "FROM `user_friend_fb` " + "WHERE USER_ID=? AND USER_FRIEND_FB=?";

    //TODO USER_DEVICE
    public static String USER_DEVICE_INSERT_SQL = "INSERT INTO `user_device`(`USER_ID`, `device_token`, `updated_datetime`, `expiration_datetime`)" +
        "VALUES (?,?,?,?)";
    public static String USER_DEVICE_SELECT_SQL = "SELECT * FROM `user_device` " +
        "WHERE USER_ID=?";
    public static String INIT_USER_USNC_INSERT_SQL = "" +
        "INSERT INTO USER_USNC " + " (USER_USNC.USER_ID, " +
        " USER_USNC.USNC_ID, " + " USER_USNC.USNC_YN) " + "VALUES ( ?, " +
        " ?, " + " ? )" + "ON DUPLICATE KEY UPDATE " +
        "USER_USNC.USNC_YN = USER_USNC.USNC_YN";
    public static String INIT_USER_USNC_AP_INSERT_SQL = "" +
        "INSERT INTO USG_USNC_AP " + " (USG_USNC_AP.AP_ID, " +
        " USG_USNC_AP.USER_ID, " + " USG_USNC_AP.USNC_ID, " +
        " USG_USNC_AP.USNC_YN) " + "VALUES ( ?, " + " ?, " + " ?, " + " ? ) " +
        "ON DUPLICATE KEY UPDATE " +
        "USG_USNC_AP.USNC_YN = USG_USNC_AP.USNC_YN";
    public static String INIT_USER_NOTIFICATION_SETTINGS_INSERT_SQL = "" +
        "INSERT INTO USER_NOTIFICATION_SETTINGS " +
        " (USER_NOTIFICATION_SETTINGS.NS_EMAIL_FLAG, " +
        " USER_NOTIFICATION_SETTINGS.NS_MOBILE_FLAG, " +
        " USER_NOTIFICATION_SETTINGS.NSID, " +
        " USER_NOTIFICATION_SETTINGS.NSID_TYPE, " +
        " USER_NOTIFICATION_SETTINGS.USER_ID) " + "VALUES ( ?, " + " ?, " +
        " ?, " + " ?, " + " ? ) " + "ON DUPLICATE KEY UPDATE " +
        "USER_NOTIFICATION_SETTINGS.NSID = USER_NOTIFICATION_SETTINGS.NSID ";
    public static String INIT_USER_PRIVACY_SETTINGS_INSERT_SQL = "" +
        "INSERT INTO USER_PRIVACY_SETTINGS " +
        " (USER_PRIVACY_SETTINGS.PRIVACY_FLAG, " +
        " USER_PRIVACY_SETTINGS.PRIVACY_ID, " +
        " USER_PRIVACY_SETTINGS.USER_ID) " + "VALUES ( ?, " + " ?, " + " ? ) " +
        "ON DUPLICATE KEY UPDATE " +
        "USER_PRIVACY_SETTINGS.PRIVACY_FLAG = USER_PRIVACY_SETTINGS.PRIVACY_FLAG";
}
