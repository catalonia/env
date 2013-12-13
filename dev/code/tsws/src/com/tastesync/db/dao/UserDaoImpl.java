package com.tastesync.db.dao;

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;

import com.tastesync.common.GlobalVariables;
import com.tastesync.common.MySQL;
import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;
import com.tastesync.db.queries.CityQueries;
import com.tastesync.db.queries.TSDBCommonQueries;
import com.tastesync.db.queries.UserQueries;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.fb.json.FBLocation;
import com.tastesync.fb.model.fqlmodel.FqlFriend;
import com.tastesync.fb.model.fqlmodel.FqlUser;
import com.tastesync.fb.process.TsFacebookRestFb;

import com.tastesync.model.objects.TSAboutObj;
import com.tastesync.model.objects.TSAskSubmitLoginObj;
import com.tastesync.model.objects.TSCityObj;
import com.tastesync.model.objects.TSFacebookUserDataObj;
import com.tastesync.model.objects.TSGlobalObj;
import com.tastesync.model.objects.TSInitObj;
import com.tastesync.model.objects.TSListFacebookUserDataObj;
import com.tastesync.model.objects.TSListNotificationSettingsObj;
import com.tastesync.model.objects.TSListPrivacySettingsObj;
import com.tastesync.model.objects.TSListSocialSettingObj;
import com.tastesync.model.objects.TSNotificationSettingsObj;
import com.tastesync.model.objects.TSPrivacySettingsObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSRestaurantPhotoObj;
import com.tastesync.model.objects.TSRestaurantView;
import com.tastesync.model.objects.TSSocialAutoPubSettingsObj;
import com.tastesync.model.objects.TSSocialSettingsObj;
import com.tastesync.model.objects.TSUserObj;
import com.tastesync.model.objects.TSUserProfileObj;
import com.tastesync.model.objects.TSUserProfileRestaurantsObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;
import com.tastesync.model.response.UserResponse;

import com.tastesync.oauth.dao.OAuthDAO;
import com.tastesync.oauth.dao.OAuthDAOImpl;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import org.joda.time.DateTime;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.Dictionary;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;


public class UserDaoImpl extends BaseDaoImpl implements UserDao {
    OAuthDAO oauthDAO = new OAuthDAOImpl();

    @Override
    public void followUserStatusChange(TSDataSource tsDataSource,
        Connection connection, String followeeUserId, String followerUserId,
        String statusFlag) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        int isExist = 0;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_CHECK_SELECT_SQL);
            statement.setString(1, followerUserId);
            statement.setString(2, followeeUserId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                isExist = 2;
            } else {
                isExist = 1;
            }

            statement.close();

            if (statusFlag.equalsIgnoreCase("1") && (isExist == 1)) {
                statement.close();

                statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_INSERT_SQL);
                statement.setString(1,
                    followeeUserId + "-" +
                    CommonFunctionsUtil.generateUniqueKey());

                statement.setString(2, followerUserId);
                statement.setString(3, followeeUserId);
                statement.setInt(4, 1);
                statement.executeUpdate();
                statement.close();
            } else if (statusFlag.equalsIgnoreCase("0") && (isExist == 2)) {
                statement.close();

                statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_DELETE_SQL);

                statement.setString(1, followerUserId);
                statement.setString(2, followeeUserId);
                statement.executeUpdate();
                statement.close();
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSInitObj getAllData(TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.CUISINE_TIER1_DESCRIPTOR_ALL_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> cuisine1 = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "cuisine_tier1_descriptor.CUISINE_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "cuisine_tier1_descriptor.CUISINE_DESC")));
                cuisine1.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.CUISINE_TIER2_DESCRIPTOR_ALL_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> cuisine2 = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "cuisine_tier2_descriptor.CUISINE_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "cuisine_tier2_descriptor.CUISINE_DESC")));
                cuisine2.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.OCCASION_DESCRIPTOR_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> occasion = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("occasion_descriptor.Occasion_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("occasion_descriptor.Occasion_DESC")));
                occasion.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.PRICE_DESCRIPTOR_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> price = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("price_descriptor.price_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("price_descriptor.price_DESC")));
                price.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.THEME_DESCRIPTOR_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> theme = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("theme_descriptor.theme_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("theme_descriptor.theme_DESC")));
                theme.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.TYPEOFREST_DESCRIPTOR_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> typeOfRest = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "typeofrest_descriptor.typeofrest_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "typeofrest_descriptor.typeofrest_DESC")));
                typeOfRest.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.WHOAREYOUWITH_DESCRIPTOR_SELECT_SQL);
            resultset = statement.executeQuery();

            List<TSGlobalObj> whoareyou = new ArrayList<TSGlobalObj>();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "whoareyouwith_descriptor.whoareyouwith_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "whoareyouwith_descriptor.whoareyouwith_DESC")));
                whoareyou.add(obj);
            }

            statement.close();

            TSInitObj data = new TSInitObj();
            data.setCuisine1(cuisine1);
            data.setCuisine2(cuisine2);
            data.setOccasion(occasion);
            data.setPrice(price);
            data.setTheme(theme);
            data.setTypeOfRestaurant(typeOfRest);
            data.setWhoAreYou(whoareyou);

            return data;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public String getAutoUserLogByUserId(TSDataSource tsDataSource,
        Connection connection, String userLogId) throws TasteSyncException {
        String userId = "";
        PreparedStatement statement = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_ID_FROM_USERLOG_SELECT_SQL);
            statement.setString(1, userLogId);

            ResultSet resultset = statement.executeQuery();

            if (resultset.next()) {
                userId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users_log.USER_ID"));
            }

            statement.close();

            return userId;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public List<TSGlobalObj> getCity(TSDataSource tsDataSource,
        Connection connection, String key) throws TasteSyncException {
        List<TSGlobalObj> listCityObj = new ArrayList<TSGlobalObj>();
        List<String> listCityID = new ArrayList<String>();
        List<TSGlobalObj> listName = new ArrayList<TSGlobalObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(CityQueries.CITY_KEY_CITY_SELECT_SQL);
            statement.setString(1, key + "%");
            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city_id")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")) + ", " +
                    CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));

                TSCityObj cityObj = new TSCityObj();
                cityObj.setCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")));
                cityObj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city_id")));
                cityObj.setCountry(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.country")));
                cityObj.setState(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));
                obj.setCity(cityObj);

                listCityObj.add(obj);
            }

            statement.close();

            statement = connection.prepareStatement(CityQueries.CITY_NEIGHBOURHOOD_KEY_DESC_SELECT_SQL);
            statement.setString(1, key + "%");
            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSGlobalObj obj = new TSGlobalObj();
                obj.setId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("city_neighbourhood.NEIGHBOUR_ID")));
                obj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "city_neighbourhood.NEIGHBOURHOOD_DESC")) + ", " +
                    CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("city_neighbourhood.CITY_NAME")) +
                    ", " +
                    CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));

                //                listName.add(obj);
                TSCityObj cityObj = new TSCityObj();
                cityObj.setCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")));
                cityObj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city_id")));
                cityObj.setCountry(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.country")));
                cityObj.setState(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));
                obj.setCity(cityObj);

                listCityObj.add(obj);
            }

            statement.close();

            return listCityObj;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSCityObj> getCityName(TSDataSource tsDataSource,
        Connection connection, String key) throws TasteSyncException {
        List<TSCityObj> listCityObj = new ArrayList<TSCityObj>();

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(CityQueries.CITY_KEY_CITY_SELECT_SQL);
            statement.setString(1, key + "%");
            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSCityObj obj = new TSCityObj();

                obj.setCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")));
                obj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city_id")));
                obj.setCountry(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.country")));
                obj.setState(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));

                listCityObj.add(obj);
            }

            statement.close();

            return listCityObj;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public boolean getFollowStatus(TSDataSource tsDataSource,
        Connection connection, String followeeUserId, String followerUserId)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_CHECK_SELECT_SQL);
            statement.setString(1, followerUserId);
            statement.setString(2, followeeUserId);
            resultset = statement.executeQuery();

            boolean followStatus = false;

            if (resultset.next()) {
                followStatus = true;
            }

            statement.close();

            return followStatus;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    private List<TSRestaurantView> getRestaurantListHomeProfile(
        Connection connection, String userId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            List<TSRestaurantView> restaurantList = new ArrayList<TSRestaurantView>();
            List<String> restaurantIDList = new ArrayList<String>();
            statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_FAV_SELECT_SQL +
                    " LIMIT 0 , 3");
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                //
                restaurantIDList.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                        resultset.getString("RESTAURANT_ID")));
            }

            statement.close();

            if (restaurantIDList.size() < 3) {
                statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_RECO_SELECT_SQL +
                        " LIMIT 0 , " + (3 - restaurantIDList.size()));
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantIDList.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            if (restaurantIDList.size() < 3) {
                statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_SAVED_SELECT_SQL +
                        " LIMIT 0 , " + (3 - restaurantIDList.size()));
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantIDList.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            if (restaurantIDList.size() < 3) {
                statement = connection.prepareStatement(UserQueries.RESTAURANT_TIPS_TASTESYNC_SELECT_SQL +
                        " LIMIT 0 , " + (3 - restaurantIDList.size()));
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantIDList.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            statement = connection.prepareStatement(UserQueries.RESTAURANT_PHOTO_SELECT_SQL +
                    " LIMIT 0,1");

            for (String restaurantID : restaurantIDList) {
                TSRestaurantView restaurant = new TSRestaurantView();
                restaurant.setId(restaurantID);

                statement.setString(1, restaurantID);
                resultset = statement.executeQuery();

                TSRestaurantPhotoObj photo = new TSRestaurantPhotoObj();

                if (resultset.next()) {
                    photo.setRestaurantId(restaurantID);
                    photo.setPhotoSource(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("PHOTO_SOURCE")));
                    photo.setPrefix(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("PREFIX")));
                    photo.setPhotoId(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("PHOTO_ID")));
                    photo.setSuffix(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("SUFFIX")));
                    photo.setWidth(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("WIDTH")));
                    photo.setHeight(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("HEIGHT")));
                    photo.setUltimateSourceName(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("ULTIMATE_SOURCE_NAME")));
                    photo.setUltimateSourceUrl(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("ULTIMATE_SOURCE_URL")));
                }

                restaurant.setPhoto(photo);

                restaurantList.add(restaurant);
            }

            statement.close();

            for (TSRestaurantView restaurant : restaurantList) {
                TSRestaurantsTileSearchObj obj = getRestaurantTileSearchReslt(connection,
                        restaurant.getId());
                restaurant.setInformation(obj);
            }

            return restaurantList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            if (resultset != null) {
                try {
                    resultset.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if (statement != null) {
                try {
                    statement.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public TSUserProfileObj getUserHomeProfile(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        TSUserProfileObj userProfileObj;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USERS_FACEBOOK_USER_DATA_CITIES_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();
            userProfileObj = new TSUserProfileObj();

            while (resultset.next()) {
                userProfileObj.setUserId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_ID")));
                userProfileObj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.NAME")));
                userProfileObj.setPhoto(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.PICTURE")));
                userProfileObj.setFacebookUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.LINK")));
                userProfileObj.setTwitterUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.TWITTER_USR_URL")));
                userProfileObj.setBlogUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.Blog_Url")));
                userProfileObj.setCityId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city_id")));
                userProfileObj.setFacebookCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")) + ", " +
                    CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.state")));
                userProfileObj.setNumPoints(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_POINTS")));
                userProfileObj.setAboutMeText(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.ABOUT")));
            }

            statement.close();
            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_COUNT_FOLLOWING_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                userProfileObj.setNumFollowers(String.valueOf(resultset.getInt(
                            "count")));
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_COUNT_FOLLOWER_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                userProfileObj.setNumFollowees(String.valueOf(resultset.getInt(
                            "count")));
            }

            statement.close();
            statement = connection.prepareStatement(UserQueries.USER_FRIEND_TASTESYNC_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            int count = 0;

            while (resultset.next()) {
                count++;
            }

            statement.close();
            userProfileObj.setNumFriendsOnTs(count + "");
            userProfileObj.setRestaurantList(getRestaurantListHomeProfile(
                    connection, userId));

            return userProfileObj;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSFacebookUserDataObj getUserId(TSDataSource tsDataSource,
        Connection connection, String userID) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        TSFacebookUserDataObj obj = new TSFacebookUserDataObj();

        try {
            statement = connection.prepareStatement(UserQueries.USERID_SELECT_SQL);
            statement.setString(1, userID);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                MySQL.mapResultsetRowToTSFacebookVO(obj, resultset);
            }

            statement.close();

            return obj;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSUserProfileRestaurantsObj> getUserProfileRestaurants(
        TSDataSource tsDataSource, Connection connection, String userId,
        int type, int from, int to) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            List<TSUserProfileRestaurantsObj> subRestaurantList = new ArrayList<TSUserProfileRestaurantsObj>();
            List<String> restaurantListId = new ArrayList<String>();

            if ((type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_ALL) ||
                    (type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_FAV)) {
                statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_FAV_SELECT_SQL);

                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantListId.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            if ((type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_ALL) ||
                    (type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_RECO)) {
                if (statement != null) {
                    statement.close();
                }

                statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_RECO_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantListId.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            if ((type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_ALL) ||
                    (type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_SAVED)) {
                if (statement != null) {
                    statement.close();
                }

                statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_SAVED_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantListId.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            if ((type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_ALL) ||
                    (type == GlobalVariables.RESTAURANT_PROFILE_DETAIL_TYPE_TIPS)) {
                if (statement != null) {
                    statement.close();
                }

                statement = connection.prepareStatement(UserQueries.RESTAURANT_TIPS_TASTESYNC_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    restaurantListId.add(CommonFunctionsUtil.converStringAsNullIfNeeded(
                            resultset.getString("RESTAURANT_ID")));
                }

                statement.close();
            }

            for (String restaurantId : restaurantListId) {
                if (statement != null) {
                    statement.close();
                }

                statement = connection.prepareStatement(UserQueries.RESTAURANT_SELECT_SQL);
                statement.setString(1, restaurantId);
                resultset = statement.executeQuery();

                TSUserProfileRestaurantsObj restaurant = null;

                if (resultset.next()) {
                    restaurant = MySQL.getTSUserProfileRestaurantsObjFromRS(connection,
                            resultset);
                }

                statement.close();

                if (restaurant != null) {
                    statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_FAV_CHECK_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, restaurantId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        restaurant.setUserFavFlag("1");
                    } else {
                        restaurant.setUserFavFlag("0");
                    }

                    statement.close();

                    statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_RECO_CHECK_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, restaurantId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        restaurant.setUserRecommendedFlag("1");
                    } else {
                        restaurant.setUserRecommendedFlag("0");
                    }

                    statement.close();
                    statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_SAVED_CHECK_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, restaurantId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        restaurant.setUserSavedFlag("1");
                    } else {
                        restaurant.setUserSavedFlag("0");
                    }

                    statement.close();
                    statement = connection.prepareStatement(UserQueries.RESTAURANT_TIPS_TASTESYNC_CHECK_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, restaurantId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        restaurant.setUserTipFlag("1");
                    } else {
                        restaurant.setUserTipFlag("0");
                    }

                    statement.close();

                    subRestaurantList.add(restaurant);
                }
            }

            return subRestaurantList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void initUserSettings(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(UserQueries.INIT_USER_USNC_INSERT_SQL);
            statement.setString(1, userId);
            statement.setInt(2, 1);

            statement.setString(3, "1");
            statement.addBatch();

            statement.setString(1, userId);
            statement.setInt(2, 2);

            statement.setString(3, "0");
            statement.addBatch();

            statement.setString(1, userId);
            statement.setInt(2, 3);

            statement.setString(3, "0");

            statement.addBatch();

            statement.setString(1, userId);
            statement.setInt(2, 4);

            statement.setString(3, "0");

            statement.addBatch();

            statement.executeBatch();
            statement.close();

            statement = connection.prepareStatement(UserQueries.INIT_USER_USNC_AP_INSERT_SQL);

            statement.setInt(1, 1);
            statement.setString(2, userId);
            statement.setInt(3, 1);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 2);
            statement.setString(2, userId);
            statement.setInt(3, 1);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 3);
            statement.setString(2, userId);
            statement.setInt(3, 1);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 1);
            statement.setString(2, userId);
            statement.setInt(3, 2);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 2);
            statement.setString(2, userId);
            statement.setInt(3, 2);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 3);
            statement.setString(2, userId);
            statement.setInt(3, 2);
            statement.setString(4, "0");
            statement.executeUpdate();

            statement.setInt(1, 1);
            statement.setString(2, userId);
            statement.setInt(3, 3);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 2);
            statement.setString(2, userId);
            statement.setInt(3, 3);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 3);
            statement.setString(2, userId);
            statement.setInt(3, 3);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 1);
            statement.setString(2, userId);
            statement.setInt(3, 4);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 2);
            statement.setString(2, userId);
            statement.setInt(3, 4);
            statement.setString(4, "0");
            statement.addBatch();

            statement.setInt(1, 3);
            statement.setString(2, userId);
            statement.setInt(3, 4);
            statement.setString(4, "0");
            statement.addBatch();
            statement.executeBatch();

            statement.close();

            statement = connection.prepareStatement(UserQueries.INIT_USER_NOTIFICATION_SETTINGS_INSERT_SQL);

            statement.setString(1, "0");
            statement.setString(2, "0");
            statement.setInt(3, 1);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "1");
            statement.setInt(3, 2);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "1");
            statement.setInt(3, 3);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "1");
            statement.setInt(3, 4);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "1");
            statement.setInt(3, 5);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "1");
            statement.setInt(3, 6);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "0");
            statement.setInt(3, 7);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "0");
            statement.setString(2, "0");
            statement.setInt(3, 8);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setString(2, "0");
            statement.setInt(3, 9);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setString(2, "0");
            statement.setInt(3, 10);
            statement.setString(4, null);
            statement.setString(5, userId);
            statement.addBatch();
            statement.executeBatch();
            statement.close();

            statement = connection.prepareStatement(UserQueries.INIT_USER_PRIVACY_SETTINGS_INSERT_SQL);
            statement.setString(1, "1");
            statement.setInt(2, 1);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 2);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 3);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 4);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 5);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 6);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 7);
            statement.setString(3, userId);
            statement.addBatch();

            statement.setString(1, "1");
            statement.setInt(2, 8);
            statement.setString(3, userId);
            statement.addBatch();

            statement.executeBatch();

            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException("Error while creating reco request " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void inviteFriend(TSDataSource tsDataSource, Connection connection,
        String userId, String friendFBId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(UserQueries.USER_FRIEND_FB_CHECK_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, friendFBId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                statement.close();
                statement = connection.prepareStatement(UserQueries.USER_FRIEND_FB_UPDATE_SQL);
                statement.setTimestamp(1,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(2, "1");
                statement.setString(3, userId);
                statement.setString(4, friendFBId);
                statement.executeUpdate();
                statement.close();
            } else {
                statement.close();
                statement = connection.prepareStatement(UserQueries.USER_FRIEND_FB_INSERT_SQL);
                statement.setString(1, userId);
                statement.setString(2, friendFBId);
                statement.setTimestamp(3,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(4, "1");
                statement.executeUpdate();
                statement.close();
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public UserResponse login(TSDataSource tsDataSource, Connection connection,
        String email, String password) throws TasteSyncException {
        TSUserObj tsUserObj = null;

        PreparedStatement statement = null;
        ResultSet resultset = null;
        String id = null;
        UserResponse userResponse = null;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(UserQueries.USER_LOGIN_SELECT_SQL);
            statement.setString(1, email);
            statement.setString(2, password);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                tsUserObj = new TSUserObj();
                MySQL.mapResultsetRowToTSUserVO(tsUserObj, resultset);
            }

            statement.close();

            if (tsUserObj != null) {
                statement = connection.prepareStatement(UserQueries.USER_ONLINE_UPDATE_SQL);
                statement.setString(1, "Y");
                statement.setTimestamp(2,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(3, tsUserObj.getUserId());
                statement.executeUpdate();
                statement.close();

                statement = connection.prepareStatement(UserQueries.USER_LOGIN_INSERT_SQL,
                        Statement.RETURN_GENERATED_KEYS);
                statement.setString(1, tsUserObj.getUserId());

                String dateNow = CommonFunctionsUtil.getCurrentDatetime();
                statement.setString(2, dateNow);
                statement.setString(3, dateNow);
                statement.executeUpdate();

                resultset = statement.getGeneratedKeys();

                int risultato = 0;

                if (resultset.next()) {
                    risultato = resultset.getInt(1);
                }

                statement.close();

                String auto_id = String.valueOf(risultato);
                String dateNowAppend = CommonFunctionsUtil.getCurrentDatetimeAppendField();
                id = dateNowAppend + "-" + tsUserObj.getUserId() + "-" +
                    risultato;

                statement = connection.prepareStatement(UserQueries.USERLOG_LOGID_UPDATE_SQL);
                statement.setString(1, id);
                statement.setString(2, auto_id);
                statement.executeUpdate();
                statement.close();

                userResponse = new UserResponse();
                userResponse.setUser(tsUserObj);
                userResponse.setUser_log_id(id);
            }

            tsDataSource.commit();

            return userResponse;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public String loginAccount(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        String dateNow = CommonFunctionsUtil.getCurrentDatetime();
        PreparedStatement statement = null;

        String id = CommonFunctionsUtil.generateUniqueKey();

        //Update login time (users_log table)
        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(UserQueries.USER_LOGIN_INSERT_SQL);
            statement.setString(1, userId);
            statement.setString(2, dateNow);
            statement.setString(3, dateNow);
            statement.setString(4, id);
            statement.execute();
            statement.close();
            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }

        return id;
    }

    @Override
    public UserResponse login_fb(TSDataSource tsDataSource,
        Connection connection,
        TSListFacebookUserDataObj tsListFacebookUserDataObj,
        String identifierForVendor) throws TasteSyncException {
        UserResponse userResponse = null;
        String dateNow = CommonFunctionsUtil.getCurrentDatetime();
        MySQL mySQL = new MySQL();

        List<TSUserObj> list_friends_using_TasteSync = new ArrayList<TSUserObj>();

        PreparedStatement statement = null;
        tsDataSource.begin();

        try {
            FacebookClient facebookClient = new DefaultFacebookClient(tsListFacebookUserDataObj.getFbAccessToken());

            List<FqlUser> users = facebookClient.executeFqlQuery(TsFacebookRestFb.USER_QUERY,
                    FqlUser.class);

            System.out.println("Users: " + users);

            if ((users == null) || users.isEmpty()) {
                logger.info(
                    "No User data found using Facebook Query data using accessToken=" +
                    tsListFacebookUserDataObj.getFbAccessToken());

                // delete also oauth related data which is invalid
                return userResponse;
            }

            //TODO set offline criteria

            //String userFbId = users.get(0).uid;
            FqlUser currentUserFB = users.get(0);

            //improve - count
            TSUserObj currentUser = mySQL.getUserInformationByFacebookID(connection,
                    currentUserFB.uid);

            ObjectMapper mapper = new ObjectMapper();

            FBLocation currentLocation = null;
            String cityFB = null;
            String userCityId = null;
            String stateFB = null;
            String countryFB = null;

            if (currentUserFB.current_location != null) {
                currentLocation = mapper.readValue(currentUserFB.current_location,
                        FBLocation.class);
                stateFB = currentLocation.getState();
                countryFB = currentLocation.getCountry();
                cityFB = currentLocation.getCity();

                if ((stateFB != null) && !stateFB.isEmpty() &&
                        (cityFB != null) && !cityFB.isEmpty()) {
                    TSCityObj cityInfoObj = mySQL.getCityInforByStateAndCityName(connection,
                            countryFB, cityFB);

                    if (cityInfoObj != null) {
                        userCityId = cityInfoObj.getCityId();
                    }
                }
            }

            if (userCityId == null) {
                cityFB = null;
                userCityId = null;
                stateFB = null;
                countryFB = null;

                FBLocation hometownLocation = null;

                if (currentUserFB.hometown_location != null) {
                    hometownLocation = mapper.readValue(currentUserFB.hometown_location,
                            FBLocation.class);
                    stateFB = hometownLocation.getState();
                    countryFB = hometownLocation.getCountry();
                    cityFB = hometownLocation.getCity();

                    if ((stateFB != null) && !stateFB.isEmpty() &&
                            (cityFB != null) && !cityFB.isEmpty()) {
                        TSCityObj cityInfoObj = mySQL.getCityInforByStateAndCityName(connection,
                                stateFB, cityFB);

                        if (cityInfoObj != null) {
                            userCityId = cityInfoObj.getCityId();
                        }
                    }
                }
            }

            String state = (userCityId == null) ? GlobalVariables.DEFAULT_STATE
                                                : stateFB;
            String country = (userCityId == null)
                ? GlobalVariables.DEFAULT_COUNTRY : countryFB;

            String user_city_id = (userCityId == null)
                ? GlobalVariables.DEFAULT_CITY_ID : userCityId;

            String userID = null;

            if (currentUser != null) {
                userID = currentUser.getUserId();
            } else {
                userID = user_city_id + "-" +
                    CommonFunctionsUtil.generateUniqueKey();
            }

            //Create a new user
            if (currentUser == null) {
                statement = connection.prepareStatement(UserQueries.USER_FACEBOOK_INSERT_SQL);
                statement.setString(1, currentUserFB.email);
                statement.setString(2, dateNow);
                statement.setString(3, currentUserFB.first_name);
                statement.setString(4, currentUserFB.last_name);
                statement.setString(5, currentUserFB.sex);
                statement.setString(6, user_city_id);
                statement.setString(7, state);
                statement.setString(8, country);
                statement.setString(9, currentUserFB.uid);
                statement.setString(10, userID);
                statement.setString(11, userID);
                statement.execute();
                statement.close();

                currentUser = mySQL.getUserInformationByFacebookID(connection,
                        currentUserFB.uid);
            } else {
                statement = connection.prepareStatement(UserQueries.USER_ONLINE_UPDATE_SQL);
                statement.setString(1, String.valueOf("y"));
                statement.setTimestamp(2,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(3, currentUser.getUserId());
                statement.executeUpdate();
                statement.close();
            }

            // insert data into user_fb_access table!!
            statement = connection.prepareStatement(UserQueries.USER_FB_ACCESS_INSERT_SQL);
            statement.setString(1, tsListFacebookUserDataObj.getFbAccessToken());
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            String fbAccessTokenId = CommonFunctionsUtil.generateUniqueKey();
            statement.setString(3, fbAccessTokenId);
            statement.setString(4, "0");
            statement.setTimestamp(5,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(6, currentUser.getUserFbId());
            statement.setString(7, currentUser.getUserId());
            statement.setString(8, identifierForVendor);

            statement.setTimestamp(9,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(10, identifierForVendor);

            statement.executeUpdate();
            statement.close();

            // Get friends list
            List<FqlFriend> friends = facebookClient.executeFqlQuery(TsFacebookRestFb.FRIENDS_USER_QUERY,
                    FqlFriend.class);

            if ((friends != null) && !friends.isEmpty()) {
                for (FqlFriend fqlFriend : friends) {
                    System.out.println("fqlFriend=" + fqlFriend);

                    //Check user' friends using TasteSync
                    TSUserObj user_fb = mySQL.getUserInformationByFacebookID(connection,
                            fqlFriend.uid);

                    if (user_fb != null) {
                        list_friends_using_TasteSync.add(user_fb);
                    }
                }
            }

            if (statement != null) {
                statement.close();
            }

            if ((list_friends_using_TasteSync != null) &&
                    !list_friends_using_TasteSync.isEmpty()) {
                statement = connection.prepareStatement(UserQueries.USER_FRIEND_TASTESYNC_TRUST_INSERT_UPDATE_SQL);

                for (TSUserObj tsUserObj : list_friends_using_TasteSync) {
                    statement.setString(1, tsUserObj.getUserId());
                    statement.setString(2, userID);
                    statement.execute();
                }

                statement.close();
            }

            String deviceToken = tsListFacebookUserDataObj.getDevice_token();

            if ((deviceToken != null) && !deviceToken.equals("")) {
                statement = connection.prepareStatement(UserQueries.USER_DEVICE_INSERT_SQL);
                statement.setString(1, userID);
                statement.setString(2, deviceToken);

                DateTime currentDateTime = new DateTime();
                statement.setTimestamp(3,
                    new Timestamp(currentDateTime.toDate().getTime()));
                statement.setTimestamp(4,
                    new Timestamp(currentDateTime.plusMonths(12).toDate()
                                                 .getTime()));
                statement.setTimestamp(5,
                    new Timestamp(currentDateTime.toDate().getTime()));
                statement.setTimestamp(6,
                    new Timestamp(currentDateTime.plusMonths(12).toDate()
                                                 .getTime()));

                statement.execute();
                statement.close();
            }

            tsDataSource.commit();
            userResponse = new UserResponse();

            if ((currentUserFB.uid != null) &&
                    "e".equals(currentUser.getCurrentStatus())) {
                userResponse.setIs_have_account("1");
            } else {
                userResponse.setIs_have_account("0");
            }

            userResponse.setUser(currentUser);

            return userResponse;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException("login_fb " + e.getMessage());
        } catch (JsonParseException e) {
            e.printStackTrace();
            throw new TasteSyncException("login_fb " + e.getMessage());
        } catch (JsonMappingException e) {
            e.printStackTrace();
            throw new TasteSyncException("login_fb " + e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
            throw new TasteSyncException("login_fb " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void logout(TSDataSource tsDataSource, Connection connection,
        String userLogId, String userId) throws TasteSyncException {
        TSUserObj user = null;
        MySQL mySQL = new MySQL();
        String dateNow = CommonFunctionsUtil.getCurrentDatetime();
        PreparedStatement statement = null;
        boolean logoutSuccess = false;

        try {
            tsDataSource.begin();
            user = mySQL.getUserInformation(connection, userId);

            if (user != null) {
                //Update IS_ONLINE status 
                statement = connection.prepareStatement(UserQueries.USER_ONLINE_UPDATE_SQL);
                statement.setString(1, String.valueOf("n"));
                statement.setTimestamp(2,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(3, userId);
                statement.executeUpdate();
                statement.close();

                statement = connection.prepareStatement(UserQueries.USERSLOG_LOGOUT_UPDATE_SQL);
                statement.setString(1, dateNow);
                statement.setString(2, userLogId);
                statement.executeUpdate();
                statement.close();

                logoutSuccess = true;
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            if (!logoutSuccess) {
                System.out.println(
                    "For some reasons, logout was not a success!!");
            }

            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public TSUserObj selectUser(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        TSUserObj tsUserObj = new TSUserObj();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            //only one result
            if (resultset.next()) {
                MySQL.mapResultsetRowToTSUserVO(tsUserObj, resultset);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsUserObj;
    }

    public List<TSUserObj> selectUsers(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        List<TSUserObj> tsUserObjs = new ArrayList<TSUserObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USERS_SELECT_SQL);
            resultset = statement.executeQuery();

            //only one result
            while (resultset.next()) {
                TSUserObj tsUserObj = new TSUserObj();
                //if bug check here
                MySQL.mapResultsetRowToTSUserVO(tsUserObj, resultset);
                tsUserObjs.add(tsUserObj);
            }

            statement.close();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsUserObjs;
    }

    @Override
    public void sendMessageToUser(TSDataSource tsDataSource,
        Connection connection, String sender_ID, String recipient_ID,
        String content) throws TasteSyncException {
        String dayTime = CommonFunctionsUtil.getCurrentDatetime();
        String id = sender_ID + "-" + CommonFunctionsUtil.generateUniqueKey();

        PreparedStatement statement = null;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(UserQueries.USER_MESSAGE_INSERT_SQL);
            statement.setString(1, id);
            statement.setString(2, sender_ID);
            statement.setString(3, recipient_ID);
            statement.setString(4, content);
            statement.setString(5, dayTime);
            statement.execute();
            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void setStatus(TSDataSource tsDataSource, Connection connection,
        String userId, String status) throws TasteSyncException {
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            //Update IS_ONLINE status 
            statement = connection.prepareStatement(UserQueries.USER_ONLINE_UPDATE_SQL);
            statement.setString(1, status);
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(3, userId);
            statement.executeUpdate();
            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public TSAboutObj showAboutTastesync(TSDataSource tsDataSource,
        Connection connection, String aboutId) throws TasteSyncException {
        MySQL mySQL = new MySQL();
        TSAboutObj obj = new TSAboutObj();
        obj.setOrder(aboutId);
        obj.setContent(mySQL.getDescAbout(connection, Integer.parseInt(aboutId)));

        return obj;
    }

    @Override
    public List<String> showInviteFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        List<String> list_data = new ArrayList<String>();

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.FACEBOOK_USER_DATA_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                String data = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_friend_fb.USER_FRIEND_FB"));
                list_data.add(data);
            }

            statement.close();

            return list_data;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSUserProfileObj> showProfileFollowers(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        ArrayList<TSUserProfileObj> fbUsers = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_FOLLOWERS_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();
            fbUsers = new ArrayList<TSUserProfileObj>();

            while (resultset.next()) {
                TSUserProfileObj userProfileObj = new TSUserProfileObj();
                userProfileObj.setUserId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_ID")));
                userProfileObj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.NAME")));
                userProfileObj.setPhoto(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.PICTURE")));
                userProfileObj.setFacebookUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.LINK")));
                userProfileObj.setTwitterUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.TWITTER_USR_URL")));
                userProfileObj.setBlogUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.Blog_Url")));
                userProfileObj.setFacebookCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")));
                userProfileObj.setNumPoints(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_POINTS")));
                userProfileObj.setAboutMeText(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.ABOUT")));
                userProfileObj.setEmailId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.TS_USER_EMAIL")));
                fbUsers.add(userProfileObj);
            }

            statement.close();

            return fbUsers;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSUserProfileObj> showProfileFollowing(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        ArrayList<TSUserProfileObj> fbUsers = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_FOLLOW_DATA_FOLLOWING_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();
            fbUsers = new ArrayList<TSUserProfileObj>();

            while (resultset.next()) {
                TSUserProfileObj userProfileObj = new TSUserProfileObj();
                userProfileObj.setUserId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_ID")));
                userProfileObj.setName(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.NAME")));
                userProfileObj.setPhoto(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.PICTURE")));
                userProfileObj.setFacebookUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("facebook_user_data.LINK")));
                userProfileObj.setTwitterUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.TWITTER_USR_URL")));
                userProfileObj.setBlogUrl(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.Blog_Url")));
                userProfileObj.setFacebookCity(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("cities.city")));
                userProfileObj.setNumPoints(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.USER_POINTS")));
                userProfileObj.setAboutMeText(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.ABOUT")));
                userProfileObj.setEmailId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("users.TS_USER_EMAIL")));
                fbUsers.add(userProfileObj);
            }

            statement.close();

            return fbUsers;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSUserObj> showProfileFriends(TSDataSource tsDataSource,
        Connection connection, String userId) throws TasteSyncException {
        List<TSUserObj> tsUserObjList = new ArrayList<TSUserObj>();

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(UserQueries.USER_FACEBOOK_ID_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            PreparedStatement statementInner = null;
            ResultSet resultsetInner = null;

            statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);

            String tipUserPhoto;

            while (resultset.next()) {
                TSUserObj userObj = new TSUserObj();
                MySQL.mapResultsetRowToTSUserVO(userObj, resultset);
                //get photo
                statementInner.setString(1, userObj.getUserFbId());
                resultsetInner = statementInner.executeQuery();
                tipUserPhoto = null;

                if (resultsetInner.next()) {
                    tipUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "facebook_user_data.picture"));
                }

                userObj.setPhoto(tipUserPhoto);

                tsUserObjList.add(userObj);
            }

            statementInner.close();
            statement.close();

            return tsUserObjList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSRestaurantObj> showRestaurantSuggestion(
        TSDataSource tsDataSource, Connection connection, String key,
        String userId) throws TasteSyncException {
        MySQL mySQL = new MySQL();
        List<TSRestaurantObj> listData = new ArrayList<TSRestaurantObj>();
        List<String> cityData = new ArrayList<String>();

        ResultSet resultset = null;
        PreparedStatement statement = null;

        try {
            TSUserObj userObj = mySQL.getUserInformation(connection, userId);

            if (userObj != null) {
                statement = connection.prepareStatement(UserQueries.CITY_NEIGHOOURHOOD_SELECT_SQL);
                statement.setString(1, userObj.getUserCityId());
                cityData.add(userObj.getUserCityId());
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    String cityId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "city_neighbourhood.NEIGHBOUR_ID"));
                    String[] arrayID = cityId.split("-");
                    cityData.add(arrayID[1]);
                }

                statement.close();
                statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_CITY_SELECT_SQL);

                for (String cityDataId : cityData) {
                    statement.setString(1, cityDataId);
                    statement.setString(2, key + "%");
                    resultset = statement.executeQuery();

                    while (resultset.next()) {
                        TSRestaurantObj obj = new TSRestaurantObj();
                        mySQL.mapResultsetRowToTSRestaurantVO(obj, resultset);
                        listData.add(obj);
                    }
                }

                statement.close();
            }

            return listData;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public TSListNotificationSettingsObj showSettingsNotifications(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        TSListNotificationSettingsObj notifycation = null;

        ResultSet resultset = null;
        PreparedStatement statement = null;

        try {
            MySQL mySQL = new MySQL();
            boolean isCheck = mySQL.checkNotificationDescriptor(connection,
                    userId);
            Dictionary<Integer, Integer> array = new Hashtable<Integer, Integer>();

            int count = 0;

            int idNotificationDescriptor = -1;

            for (int i = 1; idNotificationDescriptor != 0; i++) {
                idNotificationDescriptor = mySQL.getIDNotificationDescriptor(connection,
                        i);

                if (idNotificationDescriptor == 0) {
                    break;
                }

                count++;
                array.put(idNotificationDescriptor, i);
            }

            if (!isCheck) {
                return notifycation;
            } else {
                notifycation = new TSListNotificationSettingsObj();
                notifycation.setUserId(userId);

                TSNotificationSettingsObj[] arrayNotification = new TSNotificationSettingsObj[count];

                for (int i = 1; i <= count; i++) {
                    TSNotificationSettingsObj obj = new TSNotificationSettingsObj();
                    obj.setOrder_id(String.valueOf(i));
                    arrayNotification[i - 1] = obj;
                }

                statement = connection.prepareStatement(UserQueries.USER_NOTIFICATION_SETTINGS_ID_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    String index_str = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_notification_settings.NSID"));
                    int index = Integer.parseInt(index_str);
                    String mobile_flag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_notification_settings.NS_MOBILE_FLAG"));
                    String email_flag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_notification_settings.NS_EMAIL_FLAG"));
                    TSNotificationSettingsObj obj = arrayNotification[array.get(index) -
                        1];
                    obj.setEmailFlag(email_flag);
                    obj.setPhoneFlag(mobile_flag);
                }

                statement.close();
                notifycation.setNotification(arrayNotification);

                return notifycation;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSListPrivacySettingsObj showSettingsPrivacy(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        TSListPrivacySettingsObj privacySettingsObj = null;

        ResultSet resultset = null;
        PreparedStatement statement = null;

        try {
            MySQL mySQL = new MySQL();
            Dictionary<Integer, Integer> array = new Hashtable<Integer, Integer>();
            boolean isCheck = mySQL.checkPrivacyDescriptor(connection, userId);

            int count = 0;

            int idPrivacySettings = -1;

            for (int i = 1; idPrivacySettings != 0; i++) {
                idPrivacySettings = mySQL.getIDPrivacySettings(connection, i);

                if (idPrivacySettings == 0) {
                    break;
                }

                count++;
                array.put(idPrivacySettings, i);
            }

            if (!isCheck) {
                return privacySettingsObj;
            } else {
                privacySettingsObj = new TSListPrivacySettingsObj();

                TSPrivacySettingsObj[] arrayPrivacy = new TSPrivacySettingsObj[count];

                for (int i = 1; i <= count; i++) {
                    TSPrivacySettingsObj obj = new TSPrivacySettingsObj();
                    obj.setPrivacy_id_order(String.valueOf(i));
                    arrayPrivacy[i - 1] = obj;
                }

                privacySettingsObj.setUserId(userId);
                statement = connection.prepareStatement(UserQueries.USER_PRIVACY_SETTINGS_ID_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    String index_str = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_privacy_settings.PRIVACY_ID"));
                    int index = Integer.parseInt(index_str);
                    String privacy_flag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_privacy_settings.PRIVACY_FLAG"));

                    TSPrivacySettingsObj obj = arrayPrivacy[array.get(index) -
                        1];
                    obj.setPrivacy_flag(privacy_flag);
                }

                statement.close();
                privacySettingsObj.setPrivacy(arrayPrivacy);

                return privacySettingsObj;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSListSocialSettingObj showSettingsSocial(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        //TODO need to rewrite
        TSListSocialSettingObj social = null;
        ResultSet resultset = null;
        PreparedStatement statement = null;

        try {
            MySQL mySQL = new MySQL();
            boolean isCheckUSNC = mySQL.checkUserUSNC(connection, userId);
            boolean isCheckUSNC_AP = mySQL.checkUserUSNC_AP(connection, userId);

            //TODO calculate arrayUSNC, arrayUSNC_AP
            int count = 0;

            Dictionary<Integer, Integer> arrayUSNC = new Hashtable<Integer, Integer>();

            int key;

            for (int i = 1; i > 0; ++i) {
                key = mySQL.getIDUserSocialNetworkConnection(connection, i);

                if (key == 0) {
                    break;
                }

                arrayUSNC.put(key, i);
                ++count;
            }

            Dictionary<Integer, Integer> arrayUSNC_AP = new Hashtable<Integer, Integer>();
            int count_AP = 0;

            for (int i = 1; i > 0; ++i) {
                key = mySQL.getIDAutoPublishing(connection, i);

                if (key == 0) {
                    break;
                }

                arrayUSNC_AP.put(key, i);
                ++count_AP;
            }

            if (!isCheckUSNC_AP && !isCheckUSNC) {
                return social;
            } else {
                social = new TSListSocialSettingObj();
                social.setUserId(userId);

                TSSocialSettingsObj[] arraySocial = new TSSocialSettingsObj[count];

                for (int i = 0; i < arraySocial.length; i++) {
                    TSSocialSettingsObj obj = new TSSocialSettingsObj();
                    TSSocialAutoPubSettingsObj[] obj_AP = new TSSocialAutoPubSettingsObj[count_AP];
                    obj.setAuto_publishing(obj_AP);
                    arraySocial[i] = obj;
                }

                statement = connection.prepareStatement(UserQueries.USER_USNC_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    String s = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_usnc.USNC_YN"));
                    String index_str = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_usnc.USNC_ID"));
                    int index = Integer.parseInt(index_str);

                    TSSocialSettingsObj obj = arraySocial[arrayUSNC.get(index) -
                        1];
                    obj.setUsncYN(s);
                    obj.setUsncORDER(arrayUSNC.get(index).toString());
                }

                statement.close();
                statement = connection.prepareStatement(UserQueries.USER_SOCIAL_APID_USERID_SELECT_SQL);
                statement.setString(1, userId);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    String s = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "usg_usnc_ap.USNC_YN"));
                    String index_str = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "usg_usnc_ap.USNC_ID"));
                    int index = Integer.parseInt(index_str);
                    String indexAP_str = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "usg_usnc_ap.AP_ID"));
                    int indexAP = Integer.parseInt(indexAP_str);

                    TSSocialSettingsObj obj = arraySocial[arrayUSNC.get(index) -
                        1];
                    TSSocialAutoPubSettingsObj[] obj_array_AP = obj.getAuto_publishing();
                    TSSocialAutoPubSettingsObj obj_AP = new TSSocialAutoPubSettingsObj();
                    obj_AP.setUsncYN(s);
                    obj_AP.setUsncORDER(arrayUSNC_AP.get(indexAP).toString());
                    obj_array_AP[arrayUSNC_AP.get(indexAP) - 1] = obj_AP;
                }

                statement.close();
                social.setSocialSettings(arraySocial);

                return social;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public int showTrustedFriend(TSDataSource tsDataSource,
        Connection connection, String userId, String destUserId)
        throws TasteSyncException {
        MySQL mySQL = new MySQL();
        int trustedFriendFlag = 4;
        ResultSet resultSet = null;
        PreparedStatement statement = null;

        try {
            boolean isCheck = mySQL.checkUserFriendTasteSync(connection,
                    userId, destUserId);

            if (isCheck) {
                statement = connection.prepareStatement(UserQueries.USER_FRIEND_TASTESYNC_CHECK_SELECT_SQL);
                statement.setString(1, userId);
                statement.setString(2, destUserId);
                resultSet = statement.executeQuery();

                if (resultSet.next()) {
                    int trust = resultSet.getInt(
                            "user_friend_tastesync.FRIEND_TRUSTED_FLAG");

                    if (trust == 1) {
                        trustedFriendFlag = 1;
                    } else if (trust == 0) {
                        trustedFriendFlag = 0;
                    } else {
                        trustedFriendFlag = 3;
                    }
                }

                statement.close();
            } else {
                trustedFriendFlag = 2;
            }

            return trustedFriendFlag;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public boolean submitMyProfileAboutMe(TSDataSource tsDataSource,
        Connection connection, String userId, String aboutMeText)
        throws TasteSyncException {
        boolean ret = true;
        MySQL mySQL = new MySQL();
        PreparedStatement statement = null;
        tsDataSource.begin();

        try {
            if (mySQL.getUserInformation(connection, userId) == null) {
                ret = false;
            } else {
                statement = connection.prepareStatement(UserQueries.USER_ABOUT_UPDATE_SQL);
                statement.setString(1, aboutMeText);
                statement.setString(2, userId);
                statement.executeUpdate();
                statement.close();
                ret = true;
            }

            tsDataSource.commit();

            return ret;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void submitSettingscontactUs(TSDataSource tsDataSource,
        Connection connection, String userId, String order, String desc)
        throws TasteSyncException {
        String dateNow = CommonFunctionsUtil.getCurrentDatetime();
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            MySQL mySQL = new MySQL();
            int contactId = mySQL.getIDContactSettings(connection,
                    Integer.parseInt(order));
            String id = userId + "-" + CommonFunctionsUtil.generateUniqueKey();

            statement = connection.prepareStatement(UserQueries.USER_CONTACT_SETTINGS_INSERT_SQL);
            statement.setString(1, id);
            statement.setString(2, userId);
            statement.setInt(3, contactId);
            statement.setString(4, desc);
            statement.setString(5, dateNow);
            statement.execute();
            statement.close();
            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void submitSignupDetail(TSDataSource tsDataSource,
        Connection connection, TSAskSubmitLoginObj askObj)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        List<String> restaurantIdList = askObj.getRestaurandId();

        try {
            tsDataSource.begin();

            if (askObj.getCuisineId() != null) {
                statement = connection.prepareStatement(UserQueries.USER_CUISINE_INSERT_SQL);
                statement.setString(1, askObj.getUserId());
                statement.setString(2, askObj.getCuisineId());
                statement.execute();
                statement.close();

                statement = connection.prepareStatement(UserQueries.CUISINE_DESC_CUISINE_TIER2_SELECT_SQL);
                statement.setString(1, askObj.getCuisineId());
                resultset = statement.executeQuery();

                String cuisineTier2Desc = null;

                if (resultset.next()) {
                    cuisineTier2Desc = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "CUISINE_DESC"));
                }

                statement.close();

                if ((cuisineTier2Desc != null) && !cuisineTier2Desc.isEmpty()) {
                    statement = connection.prepareStatement(UserQueries.USERS_ABOUT_UPDATE_SQL);
                    statement.setString(1,
                        "Favorite Cuisine: " + cuisineTier2Desc);
                    statement.setString(2, askObj.getUserId());
                    statement.execute();
                    statement.close();
                }
            }

            if (askObj.getFacebookFriendId() != null) {
                statement = connection.prepareStatement(UserQueries.USER_FRIEND_SIGNUP_FB_UPDATE_SQL);
                statement.setString(1, "1");
                statement.setString(2, askObj.getUserId());
                statement.setString(3, askObj.getFacebookFriendId());
                statement.executeUpdate();
                statement.close();
            }

            statement = connection.prepareStatement(UserQueries.USER_RESTAURANT_FAV_INSERT_SQL);

            for (String restaurantId : restaurantIdList) {
                statement.setString(1, askObj.getUserId());
                statement.setString(2, restaurantId);
                statement.setInt(3, 3);
                statement.setInt(4, 1);
                statement.execute();
            }

            statement.close();

            statement = connection.prepareStatement(UserQueries.USERS_CURRENT_STATUS_UPDATE_SQL);

            statement.setString(1, "e");
            statement.setString(2, askObj.getUserId());
            statement.execute();

            statement.close();

            statement = connection.prepareStatement(UserQueries.USER_NOTIF_WELCOME_MESSAGE_INSERT_SQL);
            statement.setString(1, askObj.getUserId());
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.execute();

            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void submitTrustedFriendStatusChange(TSDataSource tsDataSource,
        Connection connection, String userId, String dest_user_id,
        String trustedFriendStatus) throws TasteSyncException {
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(UserQueries.USER_FRIEND_TASTESYNC_TRUST_UPDATE_SQL);

            statement.setString(1, trustedFriendStatus);
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(3, userId);
            statement.setString(4, dest_user_id);

            statement.execute();
            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void submitUserReport(TSDataSource tsDataSource,
        Connection connection, String userId, String reportText,
        String reportedUser, String reportedByUser) throws TasteSyncException {
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(UserQueries.USER_REPORTED_INFO_INSERT_SQL);
            statement.setString(1, CommonFunctionsUtil.generateUniqueKey());

            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            statement.setString(3, reportText);
            statement.setString(4, reportedUser);
            statement.setString(5, reportedByUser);
            statement.executeUpdate();
            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void submitUserReport(TSDataSource tsDataSource,
        Connection connection, String userId, String reportedUserId,
        String reason) throws TasteSyncException {
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(UserQueries.USER_REPORTED_INFO_INSERT_SQL);
            statement.setString(1,
                reportedUserId + CommonFunctionsUtil.generateUniqueKey());
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(3, reason);
            statement.setString(4, reportedUserId);
            statement.setString(5, userId);
            statement.executeUpdate();
            statement.close();

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void updateSettingsAutoPublishSettings(TSDataSource tsDataSource,
        Connection connection, TSListSocialSettingObj social_setting_obj)
        throws TasteSyncException {
        PreparedStatement statement = null;

        try {
            MySQL mySQL = new MySQL();

            TSSocialSettingsObj[] arraySocial = social_setting_obj.getSocialSettings();
            Dictionary<TSSocialSettingsObj, Integer> array = new Hashtable<TSSocialSettingsObj, Integer>();

            for (int i = 1; i <= arraySocial.length; i++) {
                array.put(arraySocial[i - 1],
                    mySQL.getIDUserSocialNetworkConnection(connection, i));
            }

            TSSocialAutoPubSettingsObj[] arraySocial_AP = arraySocial[0].getAuto_publishing();
            Dictionary<Integer, Integer> array_AP = new Hashtable<Integer, Integer>();

            for (int i = 1; i <= arraySocial_AP.length; i++) {
                array_AP.put(i, mySQL.getIDAutoPublishing(connection, i));
            }

            String userId = social_setting_obj.getUserId();
            boolean isCheckUSNC = mySQL.checkUserUSNC(connection, userId);
            boolean isCheckUSNC_AP = mySQL.checkUserUSNC_AP(connection, userId);

            if (isCheckUSNC) {
                for (Enumeration<TSSocialSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSSocialSettingsObj data = e.nextElement();
                    int index = array.get(data);

                    statement = connection.prepareStatement(UserQueries.USER_USNC_UPDATE_SQL);
                    statement.setString(1, data.getUsncYN());
                    statement.setString(2, userId);
                    statement.setInt(3, index);
                    statement.executeUpdate();
                    statement.close();
                }
            } else {
                for (Enumeration<TSSocialSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSSocialSettingsObj data = e.nextElement();
                    int index = array.get(data);

                    statement = connection.prepareStatement(UserQueries.USER_USNC_INSERT_SQL);
                    statement.setInt(1, index);
                    statement.setString(2, data.getUsncYN());
                    statement.setString(3, userId);
                    statement.execute();
                    statement.close();
                }
            }

            //Auto publishing
            if (!isCheckUSNC_AP) {
                for (Enumeration<TSSocialSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSSocialSettingsObj data = e.nextElement();
                    int index = array.get(data);

                    for (Enumeration<Integer> e_AP = array_AP.keys();
                            e_AP.hasMoreElements();) {
                        Integer data_AP = e_AP.nextElement();
                        int index_AP = array_AP.get(data_AP);

                        if (data.getAuto_publishing()[data_AP - 1] != null) {
                            statement = connection.prepareStatement(UserQueries.USER_SOCIAL_APID_INSERT_SQL);
                            statement.setInt(1, index);
                            statement.setInt(2, index_AP);
                            statement.setString(3,
                                data.getAuto_publishing()[data_AP - 1].getUsncYN());
                            statement.setString(4, userId);
                            statement.execute();
                            statement.close();
                        }
                    }
                }
            } else {
                for (Enumeration<TSSocialSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSSocialSettingsObj data = e.nextElement();
                    int index = array.get(data);

                    for (Enumeration<Integer> e_AP = array_AP.keys();
                            e_AP.hasMoreElements();) {
                        Integer data_AP = e_AP.nextElement();
                        int index_AP = array_AP.get(data_AP);

                        if (data.getAuto_publishing()[data_AP - 1] != null) {
                            statement = connection.prepareStatement(UserQueries.USER_SOCIAL_APID_UPDATE_SQL);
                            statement.setString(1,
                                data.getAuto_publishing()[data_AP - 1].getUsncYN());
                            statement.setString(2, userId);
                            statement.setInt(3, index);
                            statement.setInt(4, index_AP);
                            statement.executeUpdate();
                            statement.close();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(
                "Error while updateSettingsAutoPublishSettings " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void updateSettingsNotifications(TSDataSource tsDataSource,
        Connection connection, TSListNotificationSettingsObj notificationSetting)
        throws TasteSyncException {
        String userId = notificationSetting.getUserId();
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            MySQL mySQL = new MySQL();
            TSNotificationSettingsObj[] arrayNotification = notificationSetting.getNotification();
            Dictionary<TSNotificationSettingsObj, Integer> array = new Hashtable<TSNotificationSettingsObj, Integer>();

            for (int i = 1; i <= arrayNotification.length; i++) {
                array.put(arrayNotification[i - 1],
                    mySQL.getIDNotificationDescriptor(connection, i));
            }

            boolean isCheckUSNC = mySQL.checkNotificationDescriptor(connection,
                    userId);

            if (!isCheckUSNC) {
                for (Enumeration<TSNotificationSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSNotificationSettingsObj data = e.nextElement();
                    int index = array.get(data);
                    statement = connection.prepareStatement(UserQueries.USER_NOTIFICATION_SETTINGS_INSERT_SQL);
                    statement.setString(1, userId);
                    statement.setInt(2, index);
                    statement.setString(3, data.getPhoneFlag());
                    statement.setString(4, data.getEmailFlag());
                    statement.execute();
                    statement.close();
                }
            } else {
                for (Enumeration<TSNotificationSettingsObj> e = array.keys();
                        e.hasMoreElements();) {
                    TSNotificationSettingsObj data = e.nextElement();
                    int index = array.get(data);
                    statement = connection.prepareStatement(UserQueries.USER_NOTIFICATION_SETTINGS_ID_UPDATE_SQL);
                    statement.setString(1, data.getPhoneFlag());
                    statement.setString(2, data.getEmailFlag());
                    statement.setString(3, userId);
                    statement.setInt(4, index);
                    statement.executeUpdate();
                    statement.close();
                }
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }

    @Override
    public void updateSettingsPrivacy(TSDataSource tsDataSource,
        Connection connection, TSListPrivacySettingsObj privacySettingObj)
        throws TasteSyncException {
        String userId = privacySettingObj.getUserId();
        PreparedStatement statement = null;

        try {
            tsDataSource.begin();

            MySQL mySQL = new MySQL();
            Dictionary<Integer, String> array = new Hashtable<Integer, String>();

            TSPrivacySettingsObj[] privacyArray = privacySettingObj.getPrivacy();

            for (int i = 1; i <= privacyArray.length; i++) {
                TSPrivacySettingsObj privacy = privacyArray[i - 1];
                array.put(mySQL.getIDPrivacySettings(connection,
                        Integer.parseInt(privacy.getPrivacy_id_order())),
                    privacy.getPrivacy_flag());
            }

            boolean isCheckUSNC = mySQL.checkPrivacyDescriptor(connection,
                    userId);

            if (!isCheckUSNC) {
                for (Enumeration<Integer> e = array.keys();
                        e.hasMoreElements();) {
                    Integer data = e.nextElement();
                    String index = array.get(data);
                    statement = connection.prepareStatement(UserQueries.USER_PRIVACY_SETTINGS_INSERT_SQL);
                    statement.setString(1, userId);
                    statement.setInt(2, data);
                    statement.setString(3, index);
                    statement.execute();
                    statement.close();
                }
            } else {
                for (Enumeration<Integer> e = array.keys();
                        e.hasMoreElements();) {
                    Integer data = e.nextElement();
                    String index = array.get(data);
                    statement = connection.prepareStatement(UserQueries.USER_PRIVACY_SETTINGS_ID_UPDATE_SQL);
                    statement.setString(1, index);
                    statement.setString(2, userId);
                    statement.setInt(3, data);
                    statement.executeUpdate();
                    statement.close();
                }
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, null);
        }
    }
}
