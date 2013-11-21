package com.tastesync.db.queries;

public interface RestaurantQueries extends TSDBCommonQueries {
    //selectRestaurants
    public static final String RESTAURANT_SELECT_SQL = "SELECT " +
        "restaurant.RESTAURANT_ID, " + "restaurant.FACTUAL_ID, " +
        "restaurant.RESTAURANT_NAME, " + "restaurant.FACTUAL_RATING, " +
        "restaurant.PRICE_RANGE, " + "restaurant.RESTAURANT_CITY_ID, " +
        "restaurant.RESTAURANT_HOURS, " + "restaurant.RESTAURANT_LAT, " +
        "restaurant.RESTAURANT_LON, " + "restaurant.SUM_VOTE_COUNT, " +
        "restaurant.SUM_VOTE_VALUE, " + "restaurant.TBD_OPENTABLE_ID " +
        "FROM " + "restaurant " + "WHERE restaurant.RESTAURANT_ID= " + " ?";

    //TODO valid ones
    //selectRestaurant
    public static final String RESTAURANTS_SELECT_SQL = "SELECT " +
        "restaurant.RESTAURANT_ID, " + "restaurant.FACTUAL_ID, " +
        "restaurant.RESTAURANT_NAME, " + "restaurant.FACTUAL_RATING, " +
        "restaurant.PRICE_RANGE, " + "restaurant.RESTAURANT_CITY_ID, " +
        "restaurant.RESTAURANT_HOURS, " + "restaurant.RESTAURANT_LAT, " +
        "restaurant.RESTAURANT_LON, " + "restaurant.SUM_VOTE_COUNT, " +
        "restaurant.SUM_VOTE_VALUE, " + "restaurant.TBD_OPENTABLE_ID " +
        "FROM " + "restaurant ";
    public static final String RESTAURANT_MENU_SELECT_SQL = "" +
        "SELECT restaurant_menu.restaurant_id, " +
        "       restaurant_menu.menu_source, " +
        "       restaurant_menu.menu_mobileurl " + "FROM   restaurant_menu " +
        "WHERE  restaurant_menu.restaurant_id = ? ";
    public static final String RESTAURANT_EXTENDED_INFO_SELECT_SQL = "" +
        "SELECT restaurant_extended_info.tel, " +
        "       restaurant_extended_info.website," +
        "       restaurant_extended_info.options_healthy, " +
        "       restaurant_extended_info.wifi, " +
        "       restaurant_extended_info.payment_cashonly, " +
        "       restaurant_extended_info.reservations, " +
        "       restaurant_extended_info.open_24hrs, " +
        "       restaurant_extended_info.attire, " +
        "       restaurant_extended_info.attire_required, " +
        "       restaurant_extended_info.attire_prohibited, " +
        "       restaurant_extended_info.parking, " +
        "       restaurant_extended_info.parking_valet, " +
        "       restaurant_extended_info.parking_free, " +
        "       restaurant_extended_info.parking_garage, " +
        "       restaurant_extended_info.parking_lot, " +
        "       restaurant_extended_info.parking_street, " +
        "       restaurant_extended_info.parking_validated, " +
        "       restaurant_extended_info.smoking, " +
        "       restaurant_extended_info.accessible_wheelchair, " +
        "       restaurant_extended_info.alcohol, " +
        "       restaurant_extended_info.alcohol_bar, " +
        "       restaurant_extended_info.alcohol_beer_wine, " +
        "       restaurant_extended_info.alcohol_byob, " +
        "       restaurant_extended_info.groups_goodfor, " +
        "       restaurant_extended_info.kids_goodfor, " +
        "       restaurant_extended_info.kids_menu, " +
        "       restaurant_extended_info.meal_breakfast, " +
        "       restaurant_extended_info.meal_cater, " +
        "       restaurant_extended_info.meal_deliver, " +
        "       restaurant_extended_info.meal_dinner, " +
        "       restaurant_extended_info.meal_lunch, " +
        "       restaurant_extended_info.meal_takeout, " +
        "       restaurant_extended_info.options_glutenfree, " +
        "       restaurant_extended_info.options_lowfat, " +
        "       restaurant_extended_info.options_organic, " +
        "       restaurant_extended_info.options_vegan, " +
        "       restaurant_extended_info.options_vegetarian, " +
        "       restaurant_extended_info.room_private, " +
        "       restaurant_extended_info.seating_outdoor, " +
        "       restaurant_extended_info.address, " +
        "       restaurant_extended_info.address_extended, " +
        "       restaurant_extended_info.postcode, " +
        "       restaurant.restaurant_lat, " +
        "       restaurant.restaurant_lon " +
        "FROM   restaurant_extended_info, " + "       restaurant " +
        "WHERE  restaurant_extended_info.restaurant_id = ? " +
        "       AND restaurant.restaurant_id = ? ";
    public static String RESTAURANT_EXTENDED_INFO_CITY_SELECT_SQL = "" +
        "SELECT cities.city, " + "       cities.state," +
        "       cities.country " +
        "FROM   (SELECT restaurant.restaurant_city_id " +
        "        FROM   restaurant " +
        "        WHERE  restaurant.restaurant_id = ? " +
        "       ) restcityid, " + "       cities " +
        "WHERE  restcityid.restaurant_city_id = cities.city_id ";
    public static String RESTAURANT_PHOTO_SELECT_SQL = "" +
        "SELECT restaurant_photo.restaurant_id, " +
        "       restaurant_photo.photo_id, " +
        "       restaurant_photo.prefix, " +
        "       restaurant_photo.suffix, " + "       restaurant_photo.width, " +
        "       restaurant_photo.height, " +
        "       restaurant_photo.ultimate_source_name, " +
        "       restaurant_photo.ultimate_source_url, " +
        "       restaurant_photo.photo_source " + "FROM   restaurant_photo " +
        "WHERE  restaurant_photo.restaurant_id = ?";
    public static String RESTAURANT_TIPS_INSERT_SQL = "" +
        "INSERT INTO restaurant_tips_tastesync " + "            (" +
        "             restaurant_tips_tastesync.created, " +
        "             restaurant_tips_tastesync.restaurant_id, " +
        "             restaurant_tips_tastesync.tbd_tip_placeholders, " +
        "             restaurant_tips_tastesync.tip_id, " +
        "             restaurant_tips_tastesync.tip_source, " +
        "             restaurant_tips_tastesync.tip_text, " +
        "             restaurant_tips_tastesync.user_id) " + "VALUES      ( " +
        "?," + "?," + "''," //Phasse 2
         +"?" + "'TS'," //FIXED
         +"?," + "?" + ")";
    public static String USER_RESTAURANT_TIPS_EXIST_SELECT_SQL = "" +
        "SELECT restaurant_tips_tastesync.user_id " +
        "FROM   restaurant_tips_tastesync " +
        "WHERE  restaurant_tips_tastesync.user_id = ? " +
        "       AND restaurant_tips_tastesync.restaurant_id = ? ";
    public static String RESTAURANT_TIPS_AP_SELECT_SQL = "" + "SELECT " +
        "usg_usnc_ap.usnc_yn " + "FROM   usg_usnc_ap " +
        "WHERE  usg_usnc_ap.user_id = ? " + "       AND" +
        "       usg_usnc_ap.usnc_id = ? " + "       AND " +
        "       usg_usnc_ap.ap_id = ? " + "";
    public static String RESTAURANT_DETAIL_TIP_APSETTINGS_SELECT_SQL = "" +
        "SELECT usg_usnc_ap.usnc_yn, " + "       usg_usnc_ap.usnc_id " +
        "FROM   usg_usnc_ap " + "WHERE  usg_usnc_ap.user_id = ? " +
        "       AND ( usg_usnc_ap.usnc_id = 1 " +
        "              OR usg_usnc_ap.usnc_id = 2 ) " +
        "       AND usg_usnc_ap.ap_id = 2 ";

    // test sysdate
    public static String RESTAURANT_TIP_INSERT_SQL = "" +
        "INSERT INTO restaurant_tips_tastesync " +
        "            (restaurant_tips_tastesync.created, " +
        "             restaurant_tips_tastesync.restaurant_id, " +
        "             restaurant_tips_tastesync.tbd_tip_placeholders, " +
        "             restaurant_tips_tastesync.tip_id, " +
        "             restaurant_tips_tastesync.tip_source, " +
        "             restaurant_tips_tastesync.tip_text, " +
        "             restaurant_tips_tastesync.user_id) " +
        "VALUES      ( SYSDATE()," + "              ?, " +
        "              '', " + "              ?, " + "              'TS', " +
        "              ?, " + "              ? )";
    public static String SAVERESTAURANTFAV_INSERT_SQL = "" +
        "INSERT INTO user_restaurant_saved " +
        "            (user_restaurant_saved.restaurant_id, " +
        "             user_restaurant_saved.saved_notes, " +
        "             user_restaurant_saved.user_id) " + "VALUES      ( ?, " +
        "              '', " + "              ? )";
    public static String SAVERESTAURANTFAV_DELETE_SQL = "" +
        "DELETE FROM user_restaurant_saved " +
        "WHERE  user_restaurant_saved.user_id = ? " +
        "       AND user_restaurant_saved.restaurant_id = ?";
    public static String SAVERESTAURANTFAV_HISTORICAL_INSERT_SQL = "" +
        "INSERT INTO historical_user_restaurant_saved " +
        "            (historical_user_restaurant_saved.ID, " +
        "             historical_user_restaurant_saved.restaurant_id, " +
        "             historical_user_restaurant_saved.saved_flag, " +
        "             historical_user_restaurant_saved.saved_notes, " +
        "             historical_user_restaurant_saved.updated_datetime, " +
        "             historical_user_restaurant_saved.user_id) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ? )";
    public static String RESTAURANT_FAV_DATA_EXISTS_SELECT_SQL = "" +
        "SELECT user_restaurant_fav.user_id " + "FROM   user_restaurant_fav " +
        "WHERE  user_restaurant_fav.user_id = ? " +
        "       AND user_restaurant_fav.restaurant_id = ? ";

    //
    public static String RESTAURANT_FAV_SELECT_SQL = "" +
        "SELECT count(*) from user_restaurant_fav " +
        "WHERE user_restaurant_fav.restaurant_id = ? " +
        "      AND user_restaurant_fav.user_id = ?) ";
    public static String RESTAURANT_PHOTOS_SELECT_SQL = "" +
        "SELECT restaurant_photo.restaurant_id, " +
        "       restaurant_photo.photo_id, " +
        "       restaurant_photo.prefix, " +
        "       restaurant_photo.suffix, " + "       restaurant_photo.width, " +
        "       restaurant_photo.height, " +
        "       restaurant_photo.ultimate_source_name, " +
        "       restaurant_photo.ultimate_source_url, " +
        "       restaurant_photo.photo_source " + "FROM   restaurant_photo " +
        "WHERE  restaurant_photo.restaurant_id = ? ";
    public static String RECOMMENDER_USER_DAY_SELECT_SQL = "" +
        "SELECT user_restaurant_reco.recommender_user_id, " +
        "       user_restaurant_reco.recommendee_user_id, " +
        "       user_restaurant_reco.RESTAURANT_ID " +
        "FROM   user_restaurant_reco " +
        "WHERE  user_restaurant_reco.recommendee_user_id = ? " +
        "       AND user_restaurant_reco.restaurant_id = ? " +
        "       AND user_restaurant_reco.updated_datetime BETWEEN " +
        "           Sysdate() - INTERVAL 90 day AND Sysdate() ";
    public static String RESTAURANT_QUESTION_TS_ASSIGNED_INSERT_SQL = "" +
        "INSERT INTO restaurant_question_ts_assigned " +
        "            (restaurant_question_ts_assigned.assigned_prepopulated_yn, " +
        "             restaurant_question_ts_assigned.assigned_trusted_type, " +
        "             restaurant_question_ts_assigned.assigned_ts_id, " +
        "             restaurant_question_ts_assigned.assigned_usertype, " +
        "             restaurant_question_ts_assigned.assigned_user_id, " +
        "             restaurant_question_ts_assigned.assigned_user_registerd_yn, " +
        "             restaurant_question_ts_assigned.question_id, " +
        "             restaurant_question_ts_assigned.restaurant_id,  " +
        "             restaurant_question_ts_assigned.assigned_datetime ) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ? )";
    public static String RESTAURANT_QUESTION_NON_TS_ASSIGNED_INSERT_SQL = "" +
        "INSERT INTO restaurant_question_non_ts_assigned " +
        "            (restaurant_question_non_ts_assigned.assigned_fb_id, " +
        "             restaurant_question_non_ts_assigned.assigned_prepopulated_yn, " +
        "             restaurant_question_non_ts_assigned.assigned_trusted_type, " +
        "             restaurant_question_non_ts_assigned.assigned_usertype, " +
        "             restaurant_question_non_ts_assigned.assigned_user_registerd_yn, " +
        "             restaurant_question_non_ts_assigned.question_id, " +
        "             restaurant_question_non_ts_assigned.restaurant_id, " +
        "             restaurant_question_non_ts_assigned.assigned_datetime ) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?)";
    public static String USER_RESTAURANT_SAVED_DATA_EXIST_SELECT_SQL = "" +
        "SELECT user_restaurant_saved.user_id " +
        "FROM   user_restaurant_saved " +
        "WHERE  user_restaurant_saved.user_id = ? " +
        "       AND user_restaurant_saved.restaurant_id = ? ";
    public static String USERS_ID_SELECT_SQL = "" + "SELECT users.user_id, " +
        "       users.ts_user_id, " + "       users.user_fb_id " +
        "FROM   users " + "WHERE  user_fb_id = ? ";
    public static String USER_RESTAURANT_ALL_RECO_REPLY_SELECT_SQL = "" +
        "SELECT USER_RESTAURANT_RECO.REPLY_ID, " +
        "       USER_RESTAURANT_RECO.RECOMMENDER_USER_ID, " +
        "       USER_RESTAURANT_RECO.UPDATED_DATETIME, " +
        "       RECOREQUEST_REPLY_USER.RECOREQUEST_ID, " +
        "       RECOREQUEST_REPLY_USER.REPLY_TEXT " +
        "FROM   USER_RESTAURANT_RECO, " + "       RECOREQUEST_REPLY_USER " +
        "WHERE  USER_RESTAURANT_RECO.RECOMMENDEE_USER_ID = ? " +
        "       AND USER_RESTAURANT_RECO.RESTAURANT_ID = ? " +
        "       AND USER_RESTAURANT_RECO.REPLY_ID = RECOREQUEST_REPLY_USER.REPLY_ID " +
        "ORDER BY user_restaurant_reco.UPDATED_DATETIME DESC ";
    public static String USER_RESTAURANT_LATEST_RECO_REPLY_SELECT_SQL = "" +
        "SELECT USER_RESTAURANT_RECO.REPLY_ID, " +
        "       USER_RESTAURANT_RECO.RECOMMENDER_USER_ID, " +
        "       USER_RESTAURANT_RECO.UPDATED_DATETIME, " +
        "       RECOREQUEST_REPLY_USER.RECOREQUEST_ID, " +
        "       RECOREQUEST_REPLY_USER.REPLY_TEXT " +
        "FROM   USER_RESTAURANT_RECO, " + "       RECOREQUEST_REPLY_USER " +
        "WHERE  USER_RESTAURANT_RECO.RECOMMENDEE_USER_ID = ? " +
        "       AND USER_RESTAURANT_RECO.RESTAURANT_ID = ? " +
        "       AND USER_RESTAURANT_RECO.REPLY_ID = RECOREQUEST_REPLY_USER.REPLY_ID " +
        "ORDER BY user_restaurant_reco.UPDATED_DATETIME DESC " + "LIMIT 1 ";
    public static String RESTAURANT_TIPS_TASTESYNC_SELECT_SQL = "" +
        "SELECT RESTAURANT_TIPS_TASTESYNC.TIP_ID, " +
        "       RESTAURANT_TIPS_TASTESYNC.TIP_SOURCE, " +
        "       RESTAURANT_TIPS_TASTESYNC.USER_ID, " +
        "       USERS.TS_FIRST_NAME, " + "       USERS.TS_LAST_NAME, " +
        "       RESTAURANT_TIPS_TASTESYNC.TIP_TEXT, " +
        "       USERS.USER_FB_ID " + "FROM   RESTAURANT_TIPS_TASTESYNC, " +
        "       USERS " +
        "WHERE  RESTAURANT_TIPS_TASTESYNC.RESTAURANT_ID = ? " +
        "       AND RESTAURANT_TIPS_TASTESYNC.USER_ID = USERS.USER_ID ";
    public static String RESTAURANT_TIPS_EXTERNAL_SELECT_SQL = "" +
        "SELECT RESTAURANT_TIPS_EXTERNAL.tip_id, " +
        "       RESTAURANT_TIPS_EXTERNAL.tip_source, " +
        "       RESTAURANT_TIPS_EXTERNAL.tip_user_firstname, " +
        "       RESTAURANT_TIPS_EXTERNAL.tip_user_lastname, " +
        "       RESTAURANT_TIPS_EXTERNAL.tip_user_photo_prefix," +
        "       RESTAURANT_TIPS_EXTERNAL.tip_user_photo_suffix, " +
        "       RESTAURANT_TIPS_EXTERNAL.TIP_TEXT " + "FROM " +
        "       restaurant_tips_external " +
        "WHERE  RESTAURANT_TIPS_EXTERNAL.restaurant_id = ? " +
        "ORDER  BY RESTAURANT_TIPS_EXTERNAL.tip_likes_count DESC ";
}
