package com.tastesync.db.queries;

public interface CityQueries {
    public static String CITY_STATE_SELECT_SQL = "SELECT * FROM cities WHERE state = ? AND city = ?";
    public static String CITY_SELECT_SQL = "SELECT * FROM cities WHERE city_id = ?";
    public static String CITY_KEY_STATE_SELECT_SQL = "SELECT * FROM cities WHERE state LIKE ?";
    public static String CITY_KEY_CITY_SELECT_SQL = "SELECT * FROM cities " +
        "WHERE city LIKE ? " + "AND CITY_ID = 11756"; //for NY only
                                                      //city_neighbourhood
    public static String CITY_NEIGHBOURHOOD_KEY_DESC_SELECT_SQL = "SELECT city_neighbourhood.NEIGHBOUR_ID," +
        "city_neighbourhood.NEIGHBOURHOOD_DESC,city_neighbourhood.CITY_NAME,cities.state," +
        "cities.city, cities.city_id,cities.country,cities.state " +
        " FROM cities, city_neighbourhood " +
        "WHERE city_neighbourhood.NEIGHBOURHOOD_DESC LIKE ? " +
        "AND city_neighbourhood.CITY_ID = cities.city_id " +
        "AND city_neighbourhood.CITY_ID = 11756 " +
        "AND cities.city_id  = 11756 " + "ORDER BY NEIGHBOURHOOD_DESC ASC ";
}
