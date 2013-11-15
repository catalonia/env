package com.tastesync.db.queries;

public interface TSDBCommonQueries {
    public static final String RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL = "" +
        "SELECT user_follow_data.id " + "FROM   user_follow_data " +
        "WHERE  user_follow_data.followee_user_id = ? " +
        "       AND user_follow_data.follower_user_id = ? ";
    public static final String COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL = "" +
        "SELECT COUNT(*) " + "FROM   user_follow_data " +
        "WHERE  user_follow_data.followee_user_id = ? " +
        "       AND user_follow_data.follower_user_id = ? ";
    public static final String FB_ID_FRM_USER_ID_SELECT_SQL = "" +
        "SELECT users.user_fb_id " + "FROM   users " +
        "WHERE  users.user_id = ? ";
    public static final String FACEBOOK_USER_DATA_SELECT_SQL = "" +
        "SELECT facebook_user_data.name, " +
        "       facebook_user_data.picture " + "FROM   facebook_user_data " +
        "WHERE  facebook_user_data.user_fb_id = ? ";
    public static final String RECOREQUEST_TS_ASSIGNED_SELECT_SQL = "" +
        "SELECT recorequest_ts_assigned.assigned_usertype " +
        "FROM   recorequest_ts_assigned " +
        "WHERE  recorequest_ts_assigned.recorequest_id = ? " +
        "       AND recorequest_ts_assigned.assigned_user_id = ? ";
    public static final String HISTORICAL_USER_SHARED_DATA_INSERT_SQL = "" +
        "INSERT INTO historical_user_shared_data " +
        "            (historical_user_shared_data.app_user_id, " +
        "             historical_user_shared_data.id, " +
        "             historical_user_shared_data.msg_datetime, " +
        "             historical_user_shared_data.msg_text, " +
        "             historical_user_shared_data.shared_object_type, " +
        "             historical_user_shared_data.user_id) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ? )";
    public static String RESTAURANT_QUESTION_INSERT_SQL = "" +
        "INSERT INTO restaurant_question_user " +
        "            (restaurant_question_user.initiator_user_id, " +
        "             restaurant_question_user.posted_onforum_flag, " +
        "             restaurant_question_user.question_datetime, " +
        "             restaurant_question_user.question_id, " +
        "             restaurant_question_user.question_text, " +
        "             restaurant_question_user.restaurant_id) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?, " + "              ? )";
    public static final String FRIEND_TRUSTED_FLAG_SELECT_SQL = "" +
        "SELECT user_friend_tastesync.friend_trusted_flag, " +
        "       user_friend_tastesync.id " + "FROM   user_friend_tastesync " +
        "WHERE  user_friend_tastesync.user_id = ? " +
        "       AND user_friend_tastesync.friend_id = ?";
    public static String QUESTION_DETAILS_RESTAURANT_SELECT_SQL = "" +
        "SELECT restaurant_question_user.initiator_user_id, " +
        "       restaurant_question_user.restaurant_id, " +
        "       restaurant_question_user.question_text " +
        "FROM   restaurant_question_user " +
        "WHERE  restaurant_question_user.question_id = ? ";
    public static final String RECOREQUEST_USER_FRIEND_SELECT_SQL = "" +
        "SELECT recorequest_user.initiator_user_id, " +
        "       recorequest_user.recorequest_free_text " +
        "FROM   recorequest_user " +
        "WHERE  recorequest_user.recorequest_id = ? ";
    public static final String RECOREQUEST_USER_OTHER_SELECT_SQL = "" +
        "SELECT recorequest_user.initiator_user_id, " +
        "       recorequest_user.reco_request_template_sentences " +
        "FROM   recorequest_user " +
        "WHERE  recorequest_user.recorequest_id = ? ";
    public static String RESTAURANT_FAV_INSERT_SQL = "" +
        "INSERT INTO user_restaurant_fav " +
        "            (user_restaurant_fav.restaurant_id, " +
        "             user_restaurant_fav.user_id, " +
        "             user_restaurant_fav.algo1_ind, " +
        "             user_restaurant_fav.algo2_ind ) " + "VALUES      ( ?, " +
        "              ?, " + "              ?, " + "              ? )" +
        "ON DUPLICATE KEY UPDATE USER_ID=USER_ID";
    public static String RESTAURANT_FAV_DELETE_SQL = "" +
        "DELETE FROM user_restaurant_fav " +
        "WHERE  user_restaurant_fav.restaurant_id = ? " +
        "       AND user_restaurant_fav.user_id = ?";
    public static String REPLYID_RECOMMENDER_USER_SELECT_SQL = "" +
        "SELECT user_restaurant_reco.reply_id, " +
        "       user_restaurant_reco.recommender_user_id " +
        "FROM   user_restaurant_reco " +
        "WHERE  user_restaurant_reco.recommendee_user_id = ? " +
        "       AND user_restaurant_reco.restaurant_id = ? ";
    public static String HISTORICAL_RESTAURANT_FAV_INSERT_SQL = "" +
        "INSERT INTO historical_user_restaurant_fav " +
        "            (historical_user_restaurant_fav.fav_spot_flag, " +
        "             historical_user_restaurant_fav.id, " +
        "             historical_user_restaurant_fav.restaurant_id, " +
        "             historical_user_restaurant_fav.updated_datetime, " +
        "             historical_user_restaurant_fav.user_id) " +
        "VALUES      ( ?, " + "              ?, " + "              ?, " +
        "              ?, " + "              ?)";
        public static String CITY_RESTAURANT_SELECT_SQL = "" +
                "SELECT restaurant.restaurant_name, " +
                "       restaurant.price_range, " +
                "       restaurant.restaurant_city_id, " +
                "       restaurant.restaurant_lat, " +
                "       restaurant.restaurant_lon, " +
                "       restaurant.factual_rating, " + "       cities.city " +
                "FROM   restaurant, " + "       cities " +
                "WHERE  restaurant.restaurant_id = ? " +
                "       AND cities.city_id = restaurant.restaurant_city_id ";
        public static String CUISINE_DESC_ONE_RESTAURANT_SELECT_SQL = "" +
                "SELECT b.cuisine_desc " +
                "FROM   (SELECT restaurant_cuisine.tier2_cuisine_id " +
                "        FROM   restaurant_cuisine " +
                "        WHERE  restaurant_cuisine.restaurant_id = ? " +
                "        LIMIT  1) a, " + "       cuisine_tier2_descriptor b " +
                "WHERE  a.tier2_cuisine_id = b.cuisine_id ";
        public static String RESTAURANT_CITY_SELECT_SQL = "SELECT * " +
        		"FROM restaurant " +
        		"WHERE RESTAURANT_CITY_ID = ? " +
        		"AND RESTAURANT_NAME LIKE ? ";
 
}
