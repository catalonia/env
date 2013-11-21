package com.tastesync.db.queries;

public interface AutoPopulateQueries extends TSDBCommonQueries {
    //auto populate queries
    public static final String CUISINE_TIER1_SELECT_SQL = "" +
        "SELECT cuisine_tier1_descriptor.cuisine_id, " +
        "       cuisine_tier1_descriptor.cuisine_desc " +
        "FROM   cuisine_tier1_descriptor " +
        "WHERE  cuisine_tier1_descriptor.cuisine_valid_current = 1 " +
        "ORDER BY cuisine_tier1_descriptor.cuisine_desc ASC";
    public static final String CUISINE_TIER2_SELECT_SQL = "" +
        "SELECT cuisine_tier2_descriptor.cuisine_id, " +
        "       cuisine_tier2_descriptor.cuisine_desc " +
        "FROM   cuisine_tier2_descriptor " +
        "WHERE  cuisine_tier2_descriptor.cuisine_valid_current = 1 " +
        "ORDER BY cuisine_tier2_descriptor.cuisine_desc ASC";
    public static final String PRICE_SELECT_SQL = "" +
        "SELECT price_descriptor.price_id, " +
        "       price_descriptor.price_desc, " +
        "       price_descriptor.tile_picture " + "FROM   price_descriptor " +
        "WHERE  price_descriptor.price_valid_current = 1 " +
        "ORDER BY price_descriptor.price_desc ASC";
    public static final String WHOAREYOUWITH_SELECT_SQL = "" +
        "SELECT whoareyouwith_descriptor.whoareyouwith_id, " +
        "       whoareyouwith_descriptor.whoareyouwith_desc, " +
        "       whoareyouwith_descriptor.tile_picture " +
        "FROM   whoareyouwith_descriptor " +
        "WHERE  whoareyouwith_descriptor.whoareyouwith_valid_current = 1 " +
        "ORDER BY whoareyouwith_descriptor.whoareyouwith_desc ASC";
    public static final String OCCASION_SELECT_SQL = "" +
        "SELECT occasion_descriptor.occasion_id, " +
        "       occasion_descriptor.occasion_desc, " +
        "       occasion_descriptor.tile_picture, " +
        "       occasion_descriptor.ambience_order " +
        "FROM   occasion_descriptor " +
        "WHERE  occasion_descriptor.occasion_valid_current = 1 " +
        "ORDER BY occasion_descriptor.occasion_desc ASC";
    public static final String THEME_SELECT_SQL = "" +
        "SELECT theme_descriptor.theme_id, " +
        "       theme_descriptor.theme_desc, " +
        "       theme_descriptor.tile_picture, " +
        "       theme_descriptor.ambience_order " + "FROM   theme_descriptor " +
        "WHERE  theme_descriptor.theme_valid_current = 1 " +
        "ORDER BY theme_descriptor.theme_desc ASC";
    public static final String TYPEOFREST_SELECT_SQL = "" +
        "SELECT typeofrest_descriptor.typeofrest_id, " +
        "       typeofrest_descriptor.typeofrest_desc, " +
        "       typeofrest_descriptor.tile_picture, " +
        "       typeofrest_descriptor.ambience_order " +
        "FROM   typeofrest_descriptor " +
        "WHERE  typeofrest_descriptor.typeofrest_valid_current = 1 " +
        "ORDER BY typeofrest_descriptor.typeofrest_desc ASC";
    public static final String LIKE_RESTAURANT_SELECT_SQL = "" +
        "SELECT RESTAURANT_ID, " + "       RESTAURANT_NAME " +
        "FROM   RESTAURANT " + "WHERE  RESTAURANT.RESTAURANT_NAME LIKE '?' " +
        "ORDER  BY RESTAURANT_NAME ASC";
    public static final String LIKE_RESTAURANT_CITY_SELECT_SQL = "" +
        "SELECT RESTAURANT_ID, " + "       RESTAURANT_NAME " +
        "FROM   RESTAURANT " + "WHERE  RESTAURANT.RESTAURANT_CITY_ID = ? " +
        "       AND RESTAURANT.RESTAURANT_NAME LIKE ? " +
        "ORDER  BY RESTAURANT_NAME ASC " + "LIMIT 100";
    public static final String RESTAURANT_SELECT_SQL = "SELECT * FROM restaurant WHERE restaurant.RESTAURANT_NAME LIKE ?";
    public static final String RESTAURANT_CITY_KEY_SELECT_SQL = "SELECT * FROM restaurant WHERE restaurant.RESTAURANT_NAME LIKE ? AND restaurant.RESTAURANT_CITY_ID = ?";
    public static final String RESTAURANT_CITY_SELECT_SQL = "SELECT * FROM restaurant WHERE restaurant.RESTAURANT_CITY_ID = ?";
    public static final String CUISINE_TIE2_RESTAURANT_SELECT_SQL = "SELECT * FROM cuisine_tier2_descriptor WHERE CUISINE_ID IN(SELECT tier2_cuisine_id FROM restaurant_cuisine WHERE RESTAURANT_ID = ?)";
    public static final String CITIES_RESTAURANT_SELECT_SQL = "SELECT * FROM cities WHERE city_id IN(SELECT RESTAURANT_CITY_ID FROM restaurant WHERE RESTAURANT_ID = ?)";
    public static final String CITIES_LOCATION_SELECT_SQL = "" +
        "SELECT cities.state, " + "       city_neighbourhood.city_id, " +
        "       city_neighbourhood.city_name, " +
        "       city_neighbourhood.neighbour_id, " +
        "       city_neighbourhood.neighbourhood_desc " +
        "FROM   city_neighbourhood, " + "       cities " +
        "WHERE  city_neighbourhood.city_id = ? " +
        "       AND cities.city_id = city_neighbourhood.city_id ";
    public static final String POPULATE_USER_SEARCH_TERMS_PART_1_SELECT_SQL = "" +
        "SELECT USERS.USER_ID, " + "       FACEBOOK_USER_DATA.NAME, " +
        "       FACEBOOK_USER_DATA.PICTURE " + "FROM   USERS, " +
        "       FACEBOOK_USER_DATA " +
        "WHERE  FACEBOOK_USER_DATA.NAME LIKE ? " +
        "       AND USERS.USER_FB_ID = FACEBOOK_USER_DATA.USER_FB_ID ";
    public static final String POPULATE_USER_SEARCH_TERMS_PART_2_SELECT_SQL = "" +
        " AND users.USER_ID NOT IN " +
        "(SELECT USER_FOLLOW_DATA.FOLLOWEE_USER_ID " +
        "FROM   USER_FOLLOW_DATA " +
        "WHERE  USER_FOLLOW_DATA.FOLLOWER_USER_ID = ?) ";
    public static final String POPULATE_USER_SEARCH_TERMS_PART_3_SELECT_SQL = " ORDER  BY facebook_user_data.NAME ASC LIMIT 50";
}
