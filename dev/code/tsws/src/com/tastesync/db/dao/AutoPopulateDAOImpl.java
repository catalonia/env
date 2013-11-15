package com.tastesync.db.dao;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;
import com.tastesync.db.queries.AutoPopulateQueries;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSCityObj;
import com.tastesync.model.objects.TSCuisineTier2Obj;
import com.tastesync.model.objects.TSLocationSearchCitiesObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;


public class AutoPopulateDAOImpl extends BaseDaoImpl implements AutoPopulateDAO {
    private void mapResultsetRowToJSONArrayVO(JSONObject jsonObject,
        ResultSet resultset, String idColumnName, String valueColumnName)
        throws JSONException, SQLException {
        jsonObject.put("id",
            CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                    idColumnName)));
        jsonObject.put("value",
            CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                    valueColumnName)));
    }

    private void mapResultsetRowToTSLocationSearchCitiesVO(
        TSLocationSearchCitiesObj tsLocationSearchCitiesObj, ResultSet resultset)
        throws SQLException {
        tsLocationSearchCitiesObj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("city_neighbourhood.city_id")));

        tsLocationSearchCitiesObj.setCityName(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("city_neighbourhood.city_name")));

        tsLocationSearchCitiesObj.setNeighborhoodId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("city_neighbourhood.neighbour_id")));

        tsLocationSearchCitiesObj.setNeighborhoodName(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("city_neighbourhood.neighbourhood_desc")));

        tsLocationSearchCitiesObj.setState(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("cities.state")));
    }

    private void mapResultsetRowToTSRestaurantVO(
        TSRestaurantObj tsRestaurantObj, ResultSet resultset)
        throws SQLException {
        tsRestaurantObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_ID")));

        tsRestaurantObj.setFactualId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.FACTUAL_ID")));

        tsRestaurantObj.setRestaurantName(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_NAME")));

        tsRestaurantObj.setFactualRating(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.FACTUAL_RATING")));

        tsRestaurantObj.setPriceRange(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.PRICE_RANGE")));

        tsRestaurantObj.setRestaurantCityId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_CITY_ID")));

        tsRestaurantObj.setRestaurantHours(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_HOURS")));

        //TODO - calculate from restaurantHours
        // e.g. {"monday":[["00:00","24:00"]],"tuesday":[["00:00","24:00"]],"wednesday":[["00:00","24:00"]],"thursday":[["00:00","24:00"]],"friday":[["00:00","24:00"]],"saturday":[["00:00","24:00"]],"sunday":[["00:00","24:00"]]}
        // e.g. {"monday":[["11:30","16:00","Lunch"],["17:00","23:00","Dinner"]],"tuesday":[["11:30","16:00","Lunch"],["17:00","23:00","Dinner"]],"wednesday":[["11:30","16:00","Lunch"],["17:00","23:00","Dinner"]],"thursday":[["11:30","16:00","Lunch"],["17:00","23:00","Dinner"]],"friday":[["11:30","16:00","Lunch"],["17:00","23:00","Dinner"]],"saturday":[["12:00","23:00","Dinner"]],"sunday":[["12:00","23:00","Dinner"]]}
        //FOR NY, Get today day and current time. check whether it falls
        tsRestaurantObj.setOpenNowFlag("1");
        tsRestaurantObj.setRestaurantLat(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_LAT")));

        tsRestaurantObj.setRestaurantLon(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.RESTAURANT_LON")));

        if ((tsRestaurantObj.getRestaurantLat() == null) &&
                (tsRestaurantObj.getRestaurantLon() == null)) {
            tsRestaurantObj.setMoreInfoFlag("1");
        } else {
            tsRestaurantObj.setMoreInfoFlag("0");
        }

        tsRestaurantObj.setSumVoteCount(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.SUM_VOTE_COUNT")));

        tsRestaurantObj.setSumVoteValue(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.SUM_VOTE_VALUE")));

        tsRestaurantObj.setTbdOpenTableId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.TBD_OPENTABLE_ID")));
    }

    @Override
    public JSONArray populateCuisineTier1(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.CUISINE_TIER1_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "cuisine_tier1_descriptor.cuisine_id";
            String valueColumnName = "cuisine_tier1_descriptor.cuisine_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populateCuisineTier2(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.CUISINE_TIER2_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "cuisine_tier2_descriptor.cuisine_id";
            String valueColumnName = "cuisine_tier2_descriptor.cuisine_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSLocationSearchCitiesObj> populateLocationSearchTerms(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        List<TSLocationSearchCitiesObj> tsLocationSearchCitiesObjList = new ArrayList<TSLocationSearchCitiesObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.CITIES_LOCATION_SELECT_SQL);
            statement.setString(1, "11756");
            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSLocationSearchCitiesObj tsLocationSearchCitiesObj = new TSLocationSearchCitiesObj();
                mapResultsetRowToTSLocationSearchCitiesVO(tsLocationSearchCitiesObj,
                    resultset);
                tsLocationSearchCitiesObjList.add(tsLocationSearchCitiesObj);
            }

            statement.close();

            return tsLocationSearchCitiesObjList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populateOccasionDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.OCCASION_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "occasion_descriptor.occasion_id";
            String valueColumnName = "occasion_descriptor.occasion_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populatePriceDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.PRICE_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "price_descriptor.price_id";
            String valueColumnName = "price_descriptor.price_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSRestaurantObj> populateRestaurantSearchTerms(
        TSDataSource tsDataSource, Connection connection, String key,
        String cityId) throws TasteSyncException {
        List<TSRestaurantObj> listRest = new ArrayList<TSRestaurantObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            if ((cityId == null) || cityId.isEmpty()) {
                statement = connection.prepareStatement(AutoPopulateQueries.RESTAURANT_SELECT_SQL);
                statement.setString(1, key + "%");
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSRestaurantObj restaurantObj = new TSRestaurantObj();
                    mapResultsetRowToTSRestaurantVO(restaurantObj, resultset);
                    listRest.add(restaurantObj);
                }

                statement.close();
            } else if ((key == null) || key.isEmpty()) {
                statement = connection.prepareStatement(AutoPopulateQueries.RESTAURANT_CITY_SELECT_SQL);
                statement.setString(1, cityId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSRestaurantObj restaurantObj = new TSRestaurantObj();
                    mapResultsetRowToTSRestaurantVO(restaurantObj, resultset);
                    listRest.add(restaurantObj);
                }

                statement.close();
            } else {
                statement = connection.prepareStatement(AutoPopulateQueries.RESTAURANT_CITY_KEY_SELECT_SQL);
                statement.setString(1, key + "%");
                statement.setString(2, cityId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSRestaurantObj restaurantObj = new TSRestaurantObj();
                    mapResultsetRowToTSRestaurantVO(restaurantObj, resultset);
                    listRest.add(restaurantObj);
                }

                statement.close();
            }

            for (TSRestaurantObj tsRestaurantObj : listRest) {
                List<TSCuisineTier2Obj> cuisineObj = new ArrayList<TSCuisineTier2Obj>();
                statement = connection.prepareStatement(AutoPopulateQueries.CUISINE_TIE2_RESTAURANT_SELECT_SQL);
                statement.setString(1, tsRestaurantObj.getRestaurantId());
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSCuisineTier2Obj obj = new TSCuisineTier2Obj();
                    obj.setCuisineId(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString(
                                "cuisine_tier2_descriptor.CUISINE_ID")));
                    obj.setCuisineDesc(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString(
                                "cuisine_tier2_descriptor.CUISINE_DESC")));
                    obj.setCuisineValidCurrent(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString(
                                "cuisine_tier2_descriptor.CUISINE_VALID_CURRENT")));
                    cuisineObj.add(obj);
                }

                statement.close();
                tsRestaurantObj.setCuisineTier2Obj(cuisineObj);
            }

            for (TSRestaurantObj tsRestaurantObj : listRest) {
                TSCityObj cityObj = new TSCityObj();
                statement = connection.prepareStatement(AutoPopulateQueries.CITIES_RESTAURANT_SELECT_SQL);
                statement.setString(1, tsRestaurantObj.getRestaurantId());
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    cityObj.setCity(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("cities.city")));
                    cityObj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("cities.city_id")));
                    cityObj.setState(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("cities.state")));
                    cityObj.setCountry(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("cities.country")));
                }

                statement.close();
                tsRestaurantObj.setCityObj(cityObj);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return listRest;
    }

    @Override
    public List<TSRestaurantBasicObj> populateSuggestedRestaurantNames(
        TSDataSource tsDataSource, Connection connection, String restaurantKey,
        String cityId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        List<TSRestaurantBasicObj> tsRestaurantBasicObjList = new ArrayList<TSRestaurantBasicObj>();

        try {
            if ((cityId != null) && (restaurantKey != null)) {
                statement = connection.prepareStatement(AutoPopulateQueries.LIKE_RESTAURANT_CITY_SELECT_SQL);
                statement.setString(1, cityId);
                statement.setString(2, restaurantKey + "%");
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSRestaurantBasicObj tsRestaurantBasicObj = new TSRestaurantBasicObj();
                    tsRestaurantBasicObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("RESTAURANT_ID")));

                    tsRestaurantBasicObj.setRestaurantName(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("RESTAURANT_NAME")));

                    tsRestaurantBasicObjList.add(tsRestaurantBasicObj);
                }

                statement.close();
            } else if (((cityId == null) || cityId.isEmpty()) &&
                    (restaurantKey != null)) {
                statement = connection.prepareStatement(AutoPopulateQueries.LIKE_RESTAURANT_SELECT_SQL);
                statement.setString(1, restaurantKey + "%");
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    TSRestaurantBasicObj tsRestaurantBasicObj = new TSRestaurantBasicObj();
                    tsRestaurantBasicObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("RESTAURANT_ID")));

                    tsRestaurantBasicObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString("RESTAURANT_NAME")));

                    tsRestaurantBasicObjList.add(tsRestaurantBasicObj);
                }

                statement.close();
            } else {
                tsRestaurantBasicObjList = null;
            }

            return tsRestaurantBasicObjList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populateThemeDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.THEME_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "theme_descriptor.theme_id";
            String valueColumnName = "theme_descriptor.theme_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populateTypeofrestDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.TYPEOFREST_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "typeofrest_descriptor.typeofrest_id";
            String valueColumnName = "typeofrest_descriptor.typeofrest_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSUserProfileBasicObj> populateUserSearchTerms(
        TSDataSource tsDataSource, Connection connection, String userId,
        String key, String excludeFollowees) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        List<TSUserProfileBasicObj> tsUserProfileBasicObjList = new ArrayList<TSUserProfileBasicObj>();

        try {
            StringBuffer sqlbfr = new StringBuffer();
            sqlbfr.append(AutoPopulateQueries.POPULATE_USER_SEARCH_TERMS_PART_1_SELECT_SQL);

            if ("1".equals(excludeFollowees)) {
                sqlbfr.append(AutoPopulateQueries.POPULATE_USER_SEARCH_TERMS_PART_2_SELECT_SQL);
            }

            sqlbfr.append(AutoPopulateQueries.POPULATE_USER_SEARCH_TERMS_PART_3_SELECT_SQL);

            statement = connection.prepareStatement(sqlbfr.toString());
            statement.setString(1, key + "%");

            if ("1".equals(excludeFollowees)) {
                statement.setString(2, userId);
            }

            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSUserProfileBasicObj tsUserProfileBasicObj = new TSUserProfileBasicObj();
                tsUserProfileBasicObj.setUserId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("USERS.USER_ID")));
                tsUserProfileBasicObj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("FACEBOOK_USER_DATA.NAME")));
                tsUserProfileBasicObj.setPhoto(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("FACEBOOK_USER_DATA.PICTURE")));

                tsUserProfileBasicObjList.add(tsUserProfileBasicObj);
            }

            statement.close();

            return tsUserProfileBasicObjList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public JSONArray populateWhoareyouwithDescriptor(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AutoPopulateQueries.WHOAREYOUWITH_SELECT_SQL);
            resultset = statement.executeQuery();

            JSONArray jsonArray = new JSONArray();
            String idColumnName = "whoareyouwith_descriptor.whoareyouwith_id";
            String valueColumnName = "whoareyouwith_descriptor.whoareyouwith_desc";

            while (resultset.next()) {
                JSONObject jsonObject = new JSONObject();

                mapResultsetRowToJSONArrayVO(jsonObject, resultset,
                    idColumnName, valueColumnName);
                jsonArray.put(jsonObject);
            }

            statement.close();

            return jsonArray;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }
}
