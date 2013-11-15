package com.tastesync.db.dao;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;
import com.tastesync.db.queries.RestaurantQueries;
import com.tastesync.db.queries.TSDBCommonQueries;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.json.DayOpeningTiming;
import com.tastesync.model.objects.TSMenuObj;
import com.tastesync.model.objects.TSRestaurantDetailsObj;
import com.tastesync.model.objects.TSRestaurantExtendInfoObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSRestaurantPhotoObj;
import com.tastesync.model.objects.TSRestaurantQuesionNonTsAssignedObj;
import com.tastesync.model.objects.TSRestaurantTipsAPSettingsObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzCompleteObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzRecoObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzTipObj;
import com.tastesync.model.objects.derived.TSRestaurantRecommendersDetailsObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;
import com.tastesync.model.vo.RestaurantBuzzRecoVO;
import com.tastesync.model.vo.RestaurantBuzzVO;

import com.tastesync.util.TSConstants;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;


public class RestaurantDAOImpl extends BaseDaoImpl implements RestaurantDAO {
    @Deprecated
    private TSRestaurantBuzzObj getTSRestaurantBuzzObj(Connection connection,
        String userId, RestaurantBuzzVO restaurantBuzzVO)
        throws SQLException {
        TSRestaurantBuzzObj tsRestaurantBuzzObj = null;

        if (restaurantBuzzVO != null) {
            String recommenderUserName = null;
            String recommenderUserPhoto = null;
            String recommenderFacebookId = null;

            PreparedStatement statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

            statement.setString(1, restaurantBuzzVO.getRecommenderUserUserId());

            ResultSet resultset = statement.executeQuery();

            if (resultset.next()) {
                recommenderFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users.user_fb_id"));
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                statement.setString(1, recommenderFacebookId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommenderUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.name"));
                    recommenderUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.picture"));
                }

                statement.close();
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
            statement.setString(1, restaurantBuzzVO.getRecommenderUserUserId());
            statement.setString(2, userId);

            resultset = statement.executeQuery();

            String recommendeeUserFolloweeFlag = "0"; // default
            int rowCount = 0;

            if (resultset.next()) {
                rowCount = resultset.getInt(1);
            }

            if (rowCount > 0) {
                recommendeeUserFolloweeFlag = "1";
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_TS_ASSIGNED_SELECT_SQL);
            statement.setString(1, restaurantBuzzVO.getRecorequestId());
            statement.setString(2, restaurantBuzzVO.getRecommenderUserUserId());
            resultset = statement.executeQuery();

            String friendOrNot = null;

            //only one result
            if (resultset.next()) {
                friendOrNot = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_ts_assigned.ASSIGNED_USERTYPE"));
            } else {
                // invalid data case
                return null;
            }

            statement.close();

            String recorequestText = null;

            //-- this means userId is friend of recommendeeUserId and we should use the free text field
            if ("user-assigned-friend".equals(friendOrNot) ||
                    "system-assigned-friend".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_FRIEND_SELECT_SQL);
                statement.setString(1, restaurantBuzzVO.getRecorequestId());
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.recorequest_free_text"));
                }

                statement.close();
            } else if ("user-assigned-other".equals(friendOrNot) ||
                    "system-assigned-other".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_OTHER_SELECT_SQL);
                statement.setString(1, restaurantBuzzVO.getRecorequestId());
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.reco_request_template_sentences"));
                }

                statement.close();
            } else {
                // invalid data case
                return null;
            }

            statement.close();

            TSUserProfileBasicObj recommenderUser = new TSUserProfileBasicObj();
            recommenderUser.setName(recommenderUserName);
            recommenderUser.setPhoto(recommenderUserPhoto);
            recommenderUser.setUserId(restaurantBuzzVO.getRecommenderUserUserId());

            tsRestaurantBuzzObj = new TSRestaurantBuzzObj();
            tsRestaurantBuzzObj.setRecommenderUser(recommenderUser);

            tsRestaurantBuzzObj.setReplyText(restaurantBuzzVO.getReplyText());
            tsRestaurantBuzzObj.setReplyDatetime(restaurantBuzzVO.getReplyDatetime());

            tsRestaurantBuzzObj.setRecommenderUserFolloweeFlag(recommendeeUserFolloweeFlag);

            tsRestaurantBuzzObj.setRecorequestText(recorequestText);
        }

        return tsRestaurantBuzzObj;
    }

    private TSRestaurantBuzzRecoObj getTSRestaurantBuzzRecoObj(
        Connection connection, String userId,
        RestaurantBuzzRecoVO restaurantBuzzRecoVO) throws SQLException {
        TSRestaurantBuzzRecoObj tsRestaurantBuzzRecoObj = null;

        if (restaurantBuzzRecoVO != null) {
            String recommenderUserName = null;
            String recommenderUserPhoto = null;
            String recommenderFacebookId = null;

            PreparedStatement statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

            statement.setString(1,
                restaurantBuzzRecoVO.getRecommenderUserUserId());

            ResultSet resultset = statement.executeQuery();

            if (resultset.next()) {
                recommenderFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users.user_fb_id"));
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                statement.setString(1, recommenderFacebookId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommenderUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.name"));
                    recommenderUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.picture"));
                }

                statement.close();
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
            statement.setString(1,
                restaurantBuzzRecoVO.getRecommenderUserUserId());
            statement.setString(2, userId);

            resultset = statement.executeQuery();

            String recommendeeUserFolloweeFlag = "0"; // default
            int rowCount = 0;

            if (resultset.next()) {
                rowCount = resultset.getInt(1);
            }

            if (rowCount > 0) {
                recommendeeUserFolloweeFlag = "1";
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_TS_ASSIGNED_SELECT_SQL);
            statement.setString(1, restaurantBuzzRecoVO.getRecorequestId());
            statement.setString(2,
                restaurantBuzzRecoVO.getRecommenderUserUserId());
            resultset = statement.executeQuery();

            String friendOrNot = null;

            //only one result
            if (resultset.next()) {
                friendOrNot = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_ts_assigned.ASSIGNED_USERTYPE"));
            } else {
                // invalid data case
                return null;
            }

            statement.close();

            String recorequestText = null;

            //-- this means userId is friend of recommendeeUserId and we should use the free text field
            if ("user-assigned-friend".equals(friendOrNot) ||
                    "system-assigned-friend".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_FRIEND_SELECT_SQL);
                statement.setString(1, restaurantBuzzRecoVO.getRecorequestId());
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.recorequest_free_text"));
                }

                statement.close();
            } else if ("user-assigned-other".equals(friendOrNot) ||
                    "system-assigned-other".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_OTHER_SELECT_SQL);
                statement.setString(1, restaurantBuzzRecoVO.getRecorequestId());
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.reco_request_template_sentences"));
                }

                statement.close();
            } else {
                // invalid data case
                return null;
            }

            statement.close();

            TSUserProfileBasicObj recommenderUser = new TSUserProfileBasicObj();
            recommenderUser.setName(recommenderUserName);
            recommenderUser.setPhoto(recommenderUserPhoto);
            recommenderUser.setUserId(restaurantBuzzRecoVO.getRecommenderUserUserId());

            tsRestaurantBuzzRecoObj = new TSRestaurantBuzzRecoObj();
            tsRestaurantBuzzRecoObj.setRecommenderUser(recommenderUser);

            tsRestaurantBuzzRecoObj.setReplyText(restaurantBuzzRecoVO.getReplyText());
            tsRestaurantBuzzRecoObj.setReplyDatetime(restaurantBuzzRecoVO.getReplyDatetime());

            tsRestaurantBuzzRecoObj.setRecommenderUserFolloweeFlag(recommendeeUserFolloweeFlag);

            tsRestaurantBuzzRecoObj.setRecorequestText(recorequestText);
        }

        return tsRestaurantBuzzRecoObj;
    }

    private TSRestaurantBuzzTipObj getTSRestaurantBuzzTipObj(
        Connection connection, String userId, String restaurantId)
        throws SQLException {
        TSRestaurantBuzzTipObj tsRestaurantBuzzTipObj = null;

        String sql = RestaurantQueries.RESTAURANT_TIPS_TASTESYNC_SELECT_SQL +
            " LIMIT 1";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, restaurantId);

        ResultSet resultset = statement.executeQuery();
        PreparedStatement statementInner = null;
        ResultSet resultsetInner = null;
        String tipId;
        String tipSource;
        String tipUserId;
        String tipUserFirstName;
        String tipUserLastName;
        String tipText;
        String tipUserPhoto;
        String tipUserfolloweeFlag;
        int rowCount;

        if (resultset.next()) {
            tipId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "RESTAURANT_TIPS_TASTESYNC.TIP_ID"));

            tipSource = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "RESTAURANT_TIPS_TASTESYNC.TIP_SOURCE"));
            tipUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "RESTAURANT_TIPS_TASTESYNC.USER_ID"));

            tipUserFirstName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "USERS.TS_FIRST_NAME"));

            tipUserLastName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "USERS.TS_LAST_NAME"));

            tipText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "RESTAURANT_TIPS_TASTESYNC.TIP_TEXT"));

            String userFbId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                        "USERS.USER_FB_ID"));

            statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
            statementInner.setString(1, userFbId);
            resultsetInner = statementInner.executeQuery();
            tipUserPhoto = null;

            String tipUserFBName = null;

            if (resultsetInner.next()) {
                tipUserFBName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                            "facebook_user_data.name"));
                tipUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                            "facebook_user_data.picture"));
            }

            statementInner.close();

            statementInner = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
            statementInner.setString(1, tipUserId);
            statementInner.setString(2, userId);

            resultsetInner = statementInner.executeQuery();

            tipUserfolloweeFlag = "0"; // default

            rowCount = 0;

            if (resultsetInner.next()) {
                rowCount = resultsetInner.getInt(1);
            }

            if (rowCount > 0) {
                tipUserfolloweeFlag = "1";
            }

            statementInner.close();

            tsRestaurantBuzzTipObj = new TSRestaurantBuzzTipObj();
            tsRestaurantBuzzTipObj.setTipId(tipId);
            tsRestaurantBuzzTipObj.setTipSource(tipSource);
            tsRestaurantBuzzTipObj.setTipUserId(tipUserId);
            tsRestaurantBuzzTipObj.setTipUserFirstName(tipUserFirstName);
            tsRestaurantBuzzTipObj.setTipUserLastName(tipUserLastName);
            tsRestaurantBuzzTipObj.setTipText(tipText);

            tsRestaurantBuzzTipObj.setTipUserPhoto(tipUserPhoto);

            tsRestaurantBuzzTipObj.setTipUserfolloweeFlag(tipUserfolloweeFlag);
        } else {
            statement.close();

            String tipPhotoPrefix;
            String tipPhotoSuffix;
            //check for external tips
            sql = RestaurantQueries.RESTAURANT_TIPS_EXTERNAL_SELECT_SQL +
                " LIMIT 1";
            statement = connection.prepareStatement(sql);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                tipId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_id"));

                tipSource = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_source"));

                tipUserFirstName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_firstname"));

                tipUserLastName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_lastname"));

                tipText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.TIP_TEXT"));
                tipPhotoPrefix = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_photo_prefix"));

                tipPhotoSuffix = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_photo_suffix"));
                statement.close();

                tipUserPhoto = null;

                if ((tipPhotoPrefix != null) && (tipPhotoSuffix != null)) {
                    tipUserPhoto = tipPhotoPrefix + "50x50" + tipPhotoSuffix;
                }

                tsRestaurantBuzzTipObj = new TSRestaurantBuzzTipObj();
                tsRestaurantBuzzTipObj.setTipId(tipId);
                tsRestaurantBuzzTipObj.setTipSource(tipSource);

                tsRestaurantBuzzTipObj.setTipUserFirstName(tipUserFirstName);
                tsRestaurantBuzzTipObj.setTipUserLastName(tipUserLastName);
                tsRestaurantBuzzTipObj.setTipText(tipText);
                tsRestaurantBuzzTipObj.setTipUserPhoto(tipUserPhoto);
                tsRestaurantBuzzTipObj.setTipUserId(null);
                tsRestaurantBuzzTipObj.setTipUserfolloweeFlag(null);
            }
        }

        statement.close();

        return tsRestaurantBuzzTipObj;
    }

    private Boolean isOpenNow(String jsonString) {
        // read from file, convert it to user class
        if ((jsonString == null) || jsonString.isEmpty()) {
            return null;
        }

        ObjectMapper mapper = new ObjectMapper();

        DayOpeningTiming dayOpeningTiming;

        try {
            dayOpeningTiming = mapper.readValue(jsonString,
                    DayOpeningTiming.class);

            Date currentDate = new Date();

            Date convertedUsEasternCurrentDate = CommonFunctionsUtil.convertJodaTimezoneFromCurrentTimezoneToEST(currentDate);
            Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone(
                        "US/Eastern"));
            calendar.setTime(currentDate);

            int day = calendar.get(Calendar.DAY_OF_WEEK);
            List<List<String>> openTimings = null;

            switch (day) {
            case 1:
                // "Sunday"
                openTimings = dayOpeningTiming.getSunday();

                break;

            case 2:
                // "Monday"
                openTimings = dayOpeningTiming.getMonday();

                break;

            case 3:
                System.out.print("Tueseday");
                // "Tueseday"
                openTimings = dayOpeningTiming.getTuesday();

                break;

            case 4:
                // "Wednesday"
                openTimings = dayOpeningTiming.getWednesday();

                break;

            case 5:
                // "Thursday"
                openTimings = dayOpeningTiming.getThursday();

                break;

            case 6:
                // "Friday"
                openTimings = dayOpeningTiming.getFriday();

                break;

            case 7:
                // "Saturday"
                openTimings = dayOpeningTiming.getSaturday();

                break;
            }

            if ((openTimings == null) || (openTimings.size() == 0)) {
                return null;
            }

            String openIntraDayOpeningTimings;
            String closeIntraDayOpeningTimings;
            SimpleDateFormat formatter = new SimpleDateFormat("HH:mm");

            boolean openTimeNow = false;

            for (List<String> intraDayOpeningTimings : openTimings) {
                if (intraDayOpeningTimings.size() >= 2) {
                    openIntraDayOpeningTimings = intraDayOpeningTimings.get(0);

                    if (openIntraDayOpeningTimings.length() == 4) {
                        openIntraDayOpeningTimings = "0" +
                            openIntraDayOpeningTimings;
                    }

                    closeIntraDayOpeningTimings = intraDayOpeningTimings.get(1);

                    if (closeIntraDayOpeningTimings.length() == 4) {
                        closeIntraDayOpeningTimings = "0" +
                            closeIntraDayOpeningTimings;
                    }

                    if ((formatter.format(convertedUsEasternCurrentDate)
                                      .compareTo(openIntraDayOpeningTimings) >= 0) &&
                            (formatter.format(convertedUsEasternCurrentDate)
                                          .compareTo(closeIntraDayOpeningTimings) <= 0)) {
                        openTimeNow = true;

                        break;
                    }
                }
            }

            return openTimeNow;
        } catch (JsonParseException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    //TODO
    private void mapResultsetRowToTSRestaurantExtendInfoVO(
        TSRestaurantExtendInfoObj tsRestaurantExtendInfoObj, ResultSet resultset)
        throws SQLException {
        tsRestaurantExtendInfoObj.setPhoneNumber(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.tel")));
        tsRestaurantExtendInfoObj.setWebsite(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.website")));
        tsRestaurantExtendInfoObj.setHealthyOptionsFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.options_healthy")));
        tsRestaurantExtendInfoObj.setWifiFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.wifi")));
        tsRestaurantExtendInfoObj.setPayCashonlyFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.payment_cashonly")));
        tsRestaurantExtendInfoObj.setReservationsFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.reservations")));
        tsRestaurantExtendInfoObj.setOpen24HoursFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.open_24hrs")));
        tsRestaurantExtendInfoObj.setAttire(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.attire")));
        tsRestaurantExtendInfoObj.setAttireRequiredList(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.attire_required")));
        tsRestaurantExtendInfoObj.setAttireProhibitedList(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.attire_prohibited")));
        tsRestaurantExtendInfoObj.setParkingFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking")));
        tsRestaurantExtendInfoObj.setParkingValetFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking_valet")));
        tsRestaurantExtendInfoObj.setParkingFreeFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking_free")));
        tsRestaurantExtendInfoObj.setParkingGarageFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking_garage")));
        tsRestaurantExtendInfoObj.setParkingLotFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking_lot")));
        tsRestaurantExtendInfoObj.setParkingStreetFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.parking_street")));
        tsRestaurantExtendInfoObj.setParkingValidatedFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.parking_validated")));
        tsRestaurantExtendInfoObj.setSmokingFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.smoking")));
        tsRestaurantExtendInfoObj.setAccessibleWheelchairFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.accessible_wheelchair")));
        tsRestaurantExtendInfoObj.setAlcoholFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.alcohol")));
        tsRestaurantExtendInfoObj.setAlcoholBarFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.alcohol_bar")));
        tsRestaurantExtendInfoObj.setAlcoholBeerWineFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.alcohol_beer_wine")));
        tsRestaurantExtendInfoObj.setAlcoholByobFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.alcohol_byob")));
        tsRestaurantExtendInfoObj.setGroupsGoodForFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.groups_goodfor")));
        tsRestaurantExtendInfoObj.setKidsGoodForFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.kids_goodfor")));
        tsRestaurantExtendInfoObj.setKidsMenuFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.kids_menu")));
        tsRestaurantExtendInfoObj.setMealBreakfastFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_breakfast")));
        tsRestaurantExtendInfoObj.setMealCaterFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_cater")));
        tsRestaurantExtendInfoObj.setMealDeliverFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_deliver")));
        tsRestaurantExtendInfoObj.setMealDinnerFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_dinner")));
        tsRestaurantExtendInfoObj.setMealLunchFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_lunch")));
        tsRestaurantExtendInfoObj.setMealTakeoutFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.meal_takeout")));
        tsRestaurantExtendInfoObj.setOptionsGlutenfreeFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.options_glutenfree")));
        tsRestaurantExtendInfoObj.setOptionsLowfatFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.options_lowfat")));
        tsRestaurantExtendInfoObj.setOptionsOrganicFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.options_organic")));
        tsRestaurantExtendInfoObj.setOptionsVeganFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.options_vegan")));
        tsRestaurantExtendInfoObj.setOptionsVegetarianFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString(
                    "restaurant_extended_info.options_vegetarian")));
        tsRestaurantExtendInfoObj.setRoomPrivateFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.room_private")));
        tsRestaurantExtendInfoObj.setSeatingOutdoorFlag(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_extended_info.seating_outdoor")));
        tsRestaurantExtendInfoObj.setLat(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.restaurant_lat")));
        tsRestaurantExtendInfoObj.setLon(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant.restaurant_lon")));
    }

    private void mapResultsetRowToTSRestaurantMenuVO(TSMenuObj tsMenuObj,
        ResultSet resultset) throws SQLException {
        tsMenuObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_menu.restaurant_id")));
        tsMenuObj.setMenuSource(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_menu.menu_source")));
        tsMenuObj.setMenuMobileUrl(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_menu.menu_mobileurl")));
    }

    private void mapResultsetRowToTSRestaurantPhotoObjVO(
        TSRestaurantPhotoObj tsRestaurantPhotoObj, ResultSet resultset)
        throws SQLException {
        tsRestaurantPhotoObj.setRestaurantId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.RESTAURANT_ID")));
        tsRestaurantPhotoObj.setPhotoId(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.PHOTO_ID")));
        tsRestaurantPhotoObj.setPrefix(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.PREFIX")));
        tsRestaurantPhotoObj.setSuffix(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.SUFFIX")));
        tsRestaurantPhotoObj.setWidth(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.WIDTH")));
        tsRestaurantPhotoObj.setHeight(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.HEIGHT")));
        tsRestaurantPhotoObj.setUltimateSourceName(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.ULTIMATE_SOURCE_NAME")));
        tsRestaurantPhotoObj.setUltimateSourceUrl(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.ULTIMATE_SOURCE_URL")));
        tsRestaurantPhotoObj.setPhotoSource(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("restaurant_photo.PHOTO_SOURCE")));
    }

    private void mapResultsetRowToTSRestaurantTipsAPSettingsVO(String userId,
        TSRestaurantTipsAPSettingsObj tsRestaurantTipsAPSettingsObj,
        ResultSet resultset) throws SQLException {
        tsRestaurantTipsAPSettingsObj.setUserId(CommonFunctionsUtil.getModifiedValueString(
                userId));
        tsRestaurantTipsAPSettingsObj.setAutoPublishingSetting(CommonFunctionsUtil.getModifiedValueString(
                resultset.getString("usg_usnc_ap.usnc_yn")));

        if (TSConstants.USNC_APP_FACEBOOK.equals(resultset.getString(
                        "usg_usnc_ap.usnc_id"))) {
            tsRestaurantTipsAPSettingsObj.setApSettingType(TSRestaurantTipsAPSettingsObj.APSETTINGTYPE.FACEBOOK);
        } else if (TSConstants.USNC_APP_TWITTER.equals(resultset.getString(
                        "usg_usnc_ap.usnc_id"))) {
            tsRestaurantTipsAPSettingsObj.setApSettingType(TSRestaurantTipsAPSettingsObj.APSETTINGTYPE.TWITTER);
        }
    }

    //TODO to be removed
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

        String restaurantHours = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                    "restaurant.RESTAURANT_HOURS"));
        Boolean openNow = isOpenNow(restaurantHours);

        if (openNow != null) {
            if (openNow) {
                tsRestaurantObj.setOpenNowFlag("1");
            } else {
                tsRestaurantObj.setOpenNowFlag("0");
            }
        } else {
            tsRestaurantObj.setOpenNowFlag(null);
        }

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
    @Deprecated
    public List<TSRestaurantBuzzObj> showRestaurantBuzz(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.USER_RESTAURANT_ALL_RECO_REPLY_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            List<RestaurantBuzzVO> restaurantBuzzVOList = new ArrayList<RestaurantBuzzVO>();

            String replyId;
            String replyText;
            String recommenderUserUserId;
            String replyDatetime;
            String recorequestId;

            while (resultset.next()) {
                replyId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.REPLY_ID"));

                recommenderUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.RECOMMENDER_USER_ID"));
                replyDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.UPDATED_DATETIME"));

                recorequestId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.RECOREQUEST_ID"));

                replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.REPLY_TEXT"));

                RestaurantBuzzVO restaurantBuzzVO = new RestaurantBuzzVO(replyId,
                        replyText, recommenderUserUserId, replyDatetime,
                        recorequestId);

                restaurantBuzzVOList.add(restaurantBuzzVO);
            }

            statement.close();

            List<TSRestaurantBuzzObj> tsRestaurantBuzzObjList = new ArrayList<TSRestaurantBuzzObj>(restaurantBuzzVOList.size());

            for (RestaurantBuzzVO restaurantBuzzVO : restaurantBuzzVOList) {
                TSRestaurantBuzzObj tsRestaurantBuzzObj = getTSRestaurantBuzzObj(connection,
                        userId, restaurantBuzzVO);

                tsRestaurantBuzzObjList.add(tsRestaurantBuzzObj);
            }

            return tsRestaurantBuzzObjList;
        } catch (SQLException e) {
            e.printStackTrace();

            throw new TasteSyncException("Error while showRestaurantBuzz " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRestaurantBuzzCompleteObj showRestaurantBuzzComplete(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.USER_RESTAURANT_ALL_RECO_REPLY_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            List<RestaurantBuzzRecoVO> restaurantBuzzRecoVOList = new ArrayList<RestaurantBuzzRecoVO>();

            String replyId;
            String replyText;
            String recommenderUserUserId;
            String replyDatetime;
            String recorequestId;

            while (resultset.next()) {
                replyId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.REPLY_ID"));

                recommenderUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.RECOMMENDER_USER_ID"));
                replyDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.UPDATED_DATETIME"));

                recorequestId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.RECOREQUEST_ID"));

                replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.REPLY_TEXT"));

                RestaurantBuzzRecoVO restaurantBuzzRecoVO = new RestaurantBuzzRecoVO(replyId,
                        replyText, recommenderUserUserId, replyDatetime,
                        recorequestId);

                restaurantBuzzRecoVOList.add(restaurantBuzzRecoVO);
            }

            statement.close();

            List<TSRestaurantBuzzRecoObj> tsRestaurantBuzzRecoObjList = new ArrayList<TSRestaurantBuzzRecoObj>(restaurantBuzzRecoVOList.size());

            for (RestaurantBuzzRecoVO restaurantBuzzRecoVO : restaurantBuzzRecoVOList) {
                TSRestaurantBuzzRecoObj tsRestaurantBuzzRecoObj = getTSRestaurantBuzzRecoObj(connection,
                        userId, restaurantBuzzRecoVO);

                tsRestaurantBuzzRecoObjList.add(tsRestaurantBuzzRecoObj);
            }

            String tipId;
            String tipSource;
            String tipUserId;
            String tipUserFirstName;
            String tipUserLastName;
            String tipText;
            String tipUserPhoto;
            String tipUserfolloweeFlag;

            List<TSRestaurantBuzzTipObj> tsRestaurantBuzzTipObjList = new ArrayList<TSRestaurantBuzzTipObj>();
            TSRestaurantBuzzTipObj tsRestaurantBuzzTipObj = null;

            PreparedStatement statementInner = null;
            ResultSet resultsetInner = null;

            String tipUserFBName;
            int rowCount;

            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_TIPS_TASTESYNC_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                tipId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_TASTESYNC.TIP_ID"));

                tipSource = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_TASTESYNC.TIP_SOURCE"));
                tipUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_TASTESYNC.USER_ID"));

                tipUserFirstName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USERS.TS_FIRST_NAME"));

                tipUserLastName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USERS.TS_LAST_NAME"));

                tipText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_TASTESYNC.TIP_TEXT"));

                String userFbId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USERS.USER_FB_ID"));

                statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                statementInner.setString(1, userFbId);
                resultsetInner = statementInner.executeQuery();
                tipUserPhoto = null;
                tipUserFBName = null;

                if (resultsetInner.next()) {
                    tipUserFBName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "facebook_user_data.name"));
                    tipUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "facebook_user_data.picture"));
                }

                statementInner.close();

                statementInner = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
                statementInner.setString(1, tipUserId);
                statementInner.setString(2, userId);

                resultsetInner = statementInner.executeQuery();

                tipUserfolloweeFlag = "0"; // default

                rowCount = 0;

                if (resultsetInner.next()) {
                    rowCount = resultsetInner.getInt(1);
                }

                if (rowCount > 0) {
                    tipUserfolloweeFlag = "1";
                }

                statementInner.close();

                tsRestaurantBuzzTipObj = new TSRestaurantBuzzTipObj();
                tsRestaurantBuzzTipObj.setTipId(tipId);
                tsRestaurantBuzzTipObj.setTipSource(tipSource);
                tsRestaurantBuzzTipObj.setTipUserId(tipUserId);
                tsRestaurantBuzzTipObj.setTipUserFirstName(tipUserFirstName);
                tsRestaurantBuzzTipObj.setTipUserLastName(tipUserLastName);
                tsRestaurantBuzzTipObj.setTipText(tipText);

                tsRestaurantBuzzTipObj.setTipUserPhoto(tipUserPhoto);

                tsRestaurantBuzzTipObj.setTipUserfolloweeFlag(tipUserfolloweeFlag);

                tsRestaurantBuzzTipObjList.add(tsRestaurantBuzzTipObj);
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_TIPS_EXTERNAL_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            tipId = null;
            tipSource = null;
            tipUserId = null;
            tipUserFirstName = null;
            tipUserLastName = null;
            tipText = null;
            tipUserPhoto = null;
            tipUserfolloweeFlag = null;

            String tipPhotoPrefix;
            String tipPhotoSuffix;

            while (resultset.next()) {
                tipId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_id"));

                tipSource = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_source"));

                tipUserFirstName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_firstname"));

                tipUserLastName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_lastname"));

                tipText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.TIP_TEXT"));
                tipPhotoPrefix = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_photo_prefix"));

                tipPhotoSuffix = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RESTAURANT_TIPS_EXTERNAL.tip_user_photo_suffix"));

                tipUserPhoto = null;

                if ((tipPhotoPrefix != null) && (tipPhotoSuffix != null)) {
                    tipUserPhoto = tipPhotoPrefix + "50x50" + tipPhotoSuffix;
                }

                tsRestaurantBuzzTipObj = new TSRestaurantBuzzTipObj();
                tsRestaurantBuzzTipObj.setTipId(tipId);
                tsRestaurantBuzzTipObj.setTipSource(tipSource);

                tsRestaurantBuzzTipObj.setTipUserFirstName(tipUserFirstName);
                tsRestaurantBuzzTipObj.setTipUserLastName(tipUserLastName);
                tsRestaurantBuzzTipObj.setTipText(tipText);
                tsRestaurantBuzzTipObj.setTipUserPhoto(tipUserPhoto);
                tsRestaurantBuzzTipObj.setTipUserId(null);
                tsRestaurantBuzzTipObj.setTipUserfolloweeFlag(null);

                tsRestaurantBuzzTipObjList.add(tsRestaurantBuzzTipObj);
            }

            statement.close();

            TSRestaurantBuzzCompleteObj tsRestaurantBuzzCompleteObj = new TSRestaurantBuzzCompleteObj();
            tsRestaurantBuzzCompleteObj.setRestaurantBuzzRecoList(tsRestaurantBuzzRecoObjList);
            tsRestaurantBuzzCompleteObj.setRestaurantBuzzTipList(tsRestaurantBuzzTipObjList);

            return tsRestaurantBuzzCompleteObj;
        } catch (SQLException e) {
            e.printStackTrace();

            throw new TasteSyncException("Error while showRestaurantBuzz " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRestaurantObj showRestaurantDetail(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException {
        TSRestaurantObj tsRestaurantObj = new TSRestaurantObj();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            //only one result
            if (resultset.next()) {
                mapResultsetRowToTSRestaurantVO(tsRestaurantObj, resultset);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRestaurantObj;
    }

    @Override
    public TSRestaurantDetailsObj showRestaurantDetail(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        TSRestaurantDetailsObj tsRestaurantDetailsObj = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            String openNowFlag = null;
            String moreInfoFlag = "0";

            //only one result
            if (resultset.next()) {
                String restaurantHours = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant.RESTAURANT_HOURS"));
                Boolean openNow = isOpenNow(restaurantHours);

                if (openNow != null) {
                    if (openNow) {
                        openNowFlag = "1";
                    } else {
                        openNowFlag = "0";
                    }
                } else {
                    openNowFlag = null;
                }

                String restaurantLat = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant.RESTAURANT_LAT"));

                String restaurantLon = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant.RESTAURANT_LON"));

                if ((restaurantLat != null) && (restaurantLon != null)) {
                    moreInfoFlag = "1";
                }
            }

            statement.close();
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_PHOTO_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            int instgramPhoto = 0;
            int nonInstgramPhoto = 0;
            List<TSRestaurantPhotoObj> nonInstagramTsRestaurantPhotoObjs = new ArrayList<TSRestaurantPhotoObj>();
            List<TSRestaurantPhotoObj> photoList = new ArrayList<TSRestaurantPhotoObj>();

            while (resultset.next()) {
                TSRestaurantPhotoObj tsRestaurantPhotoObj = new TSRestaurantPhotoObj();
                mapResultsetRowToTSRestaurantPhotoObjVO(tsRestaurantPhotoObj,
                    resultset);

                if ("Instagram".equalsIgnoreCase(
                            CommonFunctionsUtil.getModifiedValueString(
                                resultset.getString(
                                    "restaurant_photo.ULTIMATE_SOURCE_NAME")))) {
                    photoList.add(tsRestaurantPhotoObj);
                    ++instgramPhoto;
                } else {
                    nonInstagramTsRestaurantPhotoObjs.add(tsRestaurantPhotoObj);
                    ++nonInstgramPhoto;
                }

                if (instgramPhoto == 3) {
                    break;
                }
            }

            int tsRestaurantPhotoObjsSize = photoList.size();
            int nonInstagrapmPhotoLeft = (3 - tsRestaurantPhotoObjsSize);

            int nonInstagramTsRestaurantPhotoObjsSize = nonInstagramTsRestaurantPhotoObjs.size();

            if (nonInstagramTsRestaurantPhotoObjsSize < nonInstagrapmPhotoLeft) {
                nonInstagrapmPhotoLeft = nonInstagramTsRestaurantPhotoObjsSize;
            }

            if (nonInstagrapmPhotoLeft > 0) {
                for (int i = 0; i < nonInstagrapmPhotoLeft; ++i) {
                    photoList.add(nonInstagramTsRestaurantPhotoObjs.get(i));
                }
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_MENU_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            String menuFlag = "0";

            //only one result
            if (resultset.next()) {
                String mobileMenuUrl = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_menu.menu_mobileurl"));

                if (mobileMenuUrl != null) {
                    menuFlag = "1";
                } else {
                    menuFlag = "0";
                }
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.USER_RESTAURANT_SAVED_DATA_EXIST_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            String userRestaurantSavedFlag = "0";

            if (resultset.next()) {
                userRestaurantSavedFlag = "1";
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_FAV_DATA_EXISTS_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            String userRestaurantFavFlag = "0";

            if (resultset.next()) {
                userRestaurantFavFlag = "1";
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.USER_RESTAURANT_TIPS_EXIST_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);

            resultset = statement.executeQuery();

            String userRestaurantTipFlag = "0";

            if (resultset.next()) {
                userRestaurantTipFlag = "1";
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.USER_RESTAURANT_LATEST_RECO_REPLY_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            RestaurantBuzzVO restaurantBuzzVO = null;
            RestaurantBuzzRecoVO restaurantBuzzRecoVO = null;

            String replyId;
            String replyText;
            String recommenderUserUserId;
            String replyDatetime;
            String recorequestId;

            if (resultset.next()) {
                replyId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.REPLY_ID"));

                recommenderUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.RECOMMENDER_USER_ID"));
                replyDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "USER_RESTAURANT_RECO.UPDATED_DATETIME"));

                recorequestId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.RECOREQUEST_ID"));

                replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "RECOREQUEST_REPLY_USER.REPLY_TEXT"));

                restaurantBuzzVO = new RestaurantBuzzVO(replyId, replyText,
                        recommenderUserUserId, replyDatetime, recorequestId);

                restaurantBuzzRecoVO = new RestaurantBuzzRecoVO(replyId,
                        replyText, recommenderUserUserId, replyDatetime,
                        recorequestId);
            }

            statement.close();

            TSRestaurantExtendInfoObj tsRestaurantExtendInfoObj = null;

            if ("0".equals(menuFlag) && "1".equals(moreInfoFlag)) {
                tsRestaurantExtendInfoObj = showRestaurantDetailMoreInfo(tsDataSource,
                        connection, restaurantId);
            }

            TSRestaurantBuzzRecoObj tsRestaurantBuzzRecoObj = getTSRestaurantBuzzRecoObj(connection,
                    userId, restaurantBuzzRecoVO);

            TSRestaurantBuzzTipObj tsRestaurantBuzzTipObj = getTSRestaurantBuzzTipObj(connection,
                    userId, restaurantId);
            tsRestaurantDetailsObj = new TSRestaurantDetailsObj();
            tsRestaurantDetailsObj.setOpenNowFlag(openNowFlag);
            tsRestaurantDetailsObj.setMoreInfoFlag(moreInfoFlag);
            tsRestaurantDetailsObj.setMenuFlag(menuFlag);
            tsRestaurantDetailsObj.setUserRestaurantFavFlag(userRestaurantFavFlag);
            tsRestaurantDetailsObj.setUserRestaurantSavedFlag(userRestaurantSavedFlag);
            tsRestaurantDetailsObj.setUserRestaurantTipFlag(userRestaurantTipFlag);
            tsRestaurantDetailsObj.setDealHeadline("");
            tsRestaurantDetailsObj.setPhotoList(photoList);

            TSRestaurantBuzzCompleteObj tsRestaurantBuzzCompleteObj = new TSRestaurantBuzzCompleteObj();

            List<TSRestaurantBuzzRecoObj> restaurantBuzzRecoList = null;

            if (tsRestaurantBuzzRecoObj != null) {
                restaurantBuzzRecoList = new ArrayList<TSRestaurantBuzzRecoObj>(1);
                restaurantBuzzRecoList.add(tsRestaurantBuzzRecoObj);
            }

            tsRestaurantBuzzCompleteObj.setRestaurantBuzzRecoList(restaurantBuzzRecoList);

            List<TSRestaurantBuzzTipObj> restaurantBuzzTipList = null;

            if (tsRestaurantBuzzTipObj != null) {
                restaurantBuzzTipList = new ArrayList<TSRestaurantBuzzTipObj>(1);
                restaurantBuzzTipList.add(tsRestaurantBuzzTipObj);
            }

            tsRestaurantBuzzCompleteObj.setRestaurantBuzzTipList(restaurantBuzzTipList);

            TSRestaurantsTileSearchObj tsRestaurantsTileSearchObj = getRestaurantTileSearchReslt(connection,
                    restaurantId);
            tsRestaurantDetailsObj.setRestaurantsTileSearch(tsRestaurantsTileSearchObj);
            tsRestaurantDetailsObj.setRestaurantBuzzComplete(tsRestaurantBuzzCompleteObj);
            tsRestaurantDetailsObj.setRestaurantExtendInfoObj(tsRestaurantExtendInfoObj);

            return tsRestaurantDetailsObj;
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRestaurantRecommendersDetailsObj showRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        TSRestaurantRecommendersDetailsObj tsRestaurantRecommendersDetailsObj = null;

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RECOMMENDER_USER_DAY_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            List<String> recommenderUserIdList = new ArrayList<String>();

            String recommenderUserIdValue = null;

            while (resultset.next()) {
                recommenderUserIdValue = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_restaurant_reco.RECOMMENDER_USER_ID"));

                if (!recommenderUserIdList.contains(recommenderUserIdValue)) {
                    recommenderUserIdList.add(recommenderUserIdValue);
                }
            }

            statement.close();

            String recommenderUserName = null;
            String recommenderUserPhoto = null;
            String recommenderFacebookId = null;
            List<TSUserProfileBasicObj> recommendersDetailsList = new ArrayList<TSUserProfileBasicObj>();

            for (String recommenderUserId : recommenderUserIdList) {
                recommenderUserName = null;
                recommenderUserPhoto = null;

                statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                statement.setString(1, recommenderUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommenderFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_fb_id"));
                    statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    statement.setString(1, recommenderFacebookId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        recommenderUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.name"));
                        recommenderUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.picture"));
                    }
                }

                TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
                recommendeeUser.setName(recommenderUserName);
                recommendeeUser.setPhoto(recommenderUserPhoto);
                recommendeeUser.setUserId(recommenderUserId);
                recommendersDetailsList.add(recommendeeUser);
                statement.close();
            }

            tsRestaurantRecommendersDetailsObj = new TSRestaurantRecommendersDetailsObj();

            tsRestaurantRecommendersDetailsObj.setRecommendersDetailsList(recommendersDetailsList);
            tsRestaurantRecommendersDetailsObj.setRestaurantId(restaurantId);
            tsRestaurantRecommendersDetailsObj.setUserId(userId);

            return tsRestaurantRecommendersDetailsObj;
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
    public TSMenuObj showRestaurantDetailMenu(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        TSMenuObj tsMenuObj = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_MENU_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            //only one result
            if (resultset.next()) {
                tsMenuObj = new TSMenuObj();
                mapResultsetRowToTSRestaurantMenuVO(tsMenuObj, resultset);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsMenuObj;
    }

    @Override
    public TSRestaurantExtendInfoObj showRestaurantDetailMoreInfo(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;
        TSRestaurantExtendInfoObj tsRestaurantExtendInfoObj = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_EXTENDED_INFO_SELECT_SQL);
            statement.setString(1, restaurantId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            String[] addressList = new String[6];

            tsRestaurantExtendInfoObj = new TSRestaurantExtendInfoObj();

            //only one result
            if (resultset.next()) {
                mapResultsetRowToTSRestaurantExtendInfoVO(tsRestaurantExtendInfoObj,
                    resultset);
                addressList[0] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_extended_info.address"));
                addressList[1] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_extended_info.address_extended"));
                addressList[5] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_extended_info.postcode"));
            } else {
                //log the restaurant id. log ipaddress!!
                logger.warn("showRestaurantDetailMoreInfo - restaurantId=" +
                    restaurantId);

                return null;
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_EXTENDED_INFO_CITY_SELECT_SQL);
            statement.setString(1, restaurantId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                addressList[2] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "cities.city"));
                addressList[3] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "cities.state"));
                addressList[4] = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "cities.country"));
            }

            statement.close();

            StringBuffer addressBuffer = new StringBuffer();

            for (String anAddressList : addressList) {
                if ((anAddressList != null) && !anAddressList.isEmpty()) {
                    addressBuffer.append(anAddressList).append(", ");
                }
            }

            //remove last , characters
            String addressStr = addressBuffer.toString();

            if ((addressStr.length() > 2)) {
                addressStr = addressStr.substring(0, addressStr.length() - 2);
            }

            tsRestaurantExtendInfoObj.setAddress(addressStr);

            return tsRestaurantExtendInfoObj;
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSRestaurantPhotoObj> showRestaurantDetailPhotos(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException {
        List<TSRestaurantPhotoObj> tsRestaurantPhotoObjs = new ArrayList<TSRestaurantPhotoObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_PHOTOS_SELECT_SQL);
            statement.setString(1, restaurantId);

            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSRestaurantPhotoObj tsRestaurantPhotoObj = new TSRestaurantPhotoObj();
                mapResultsetRowToTSRestaurantPhotoObjVO(tsRestaurantPhotoObj,
                    resultset);

                tsRestaurantPhotoObjs.add(tsRestaurantPhotoObj);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRestaurantPhotoObjs;
    }

    @Override
    public List<TSRestaurantTipsAPSettingsObj> showRestaurantDetailTipAPSettings(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        List<TSRestaurantTipsAPSettingsObj> tsRestaurantTipsAPSettingsObjs = new ArrayList<TSRestaurantTipsAPSettingsObj>();

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_DETAIL_TIP_APSETTINGS_SELECT_SQL);
            statement.setString(1, userId);

            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSRestaurantTipsAPSettingsObj tsRestaurantTipsAPSettingsObj = new TSRestaurantTipsAPSettingsObj();
                mapResultsetRowToTSRestaurantTipsAPSettingsVO(userId,
                    tsRestaurantTipsAPSettingsObj, resultset);

                tsRestaurantTipsAPSettingsObjs.add(tsRestaurantTipsAPSettingsObj);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRestaurantTipsAPSettingsObjs;
    }

    @Override
    public List<TSRestaurantObj> showRestaurantsDetailsList(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        List<TSRestaurantObj> tsRestaurantObjs = new ArrayList<TSRestaurantObj>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANTS_SELECT_SQL);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                TSRestaurantObj tsRestaurantObj = new TSRestaurantObj();
                mapResultsetRowToTSRestaurantVO(tsRestaurantObj, resultset);

                tsRestaurantObjs.add(tsRestaurantObj);
            }

            statement.close();
        } catch (SQLException e1) {
            e1.printStackTrace();
            throw new TasteSyncException(e1.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRestaurantObjs;
    }

    @Override
    public void submitAddOrRemoveFromFavs(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantFavFlag) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            if ("0".equals(userRestaurantFavFlag)) {
                statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_FAV_DELETE_SQL);
                statement.setString(1, restaurantId);
                statement.setString(2, userId);
                statement.executeUpdate();
                statement.close();
            } else if ("1".equals(userRestaurantFavFlag)) {
                statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_FAV_INSERT_SQL);
                statement.setString(1, restaurantId);
                statement.setString(2, userId);
                statement.setInt(3, 3);
                statement.setInt(4, 1);
                statement.executeUpdate();
                statement.close();
            } else {
                throw new TasteSyncException(
                    "Unknown value for userRestaurantFavFlag as " +
                    userRestaurantFavFlag);
            }

            statement = connection.prepareStatement(TSDBCommonQueries.HISTORICAL_RESTAURANT_FAV_INSERT_SQL);

            statement.setString(1, userRestaurantFavFlag);

            List<String> inputKeyStr = new ArrayList<String>();
            inputKeyStr.add(userId);
            statement.setString(2,
                CommonFunctionsUtil.generateUniqueKey(inputKeyStr));

            statement.setString(3, restaurantId);

            statement.setTimestamp(4,
                CommonFunctionsUtil.getCurrentDateTimestamp());

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

            throw new TasteSyncException(
                "Error while creating restaurant tips " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRestaurantQuesionNonTsAssignedObj submitRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String questionText, String postQuestionOnForum,
        String[] recommendersUserIdList, String[] friendsFacebookIdList)
        throws TasteSyncException {
        TSRestaurantQuesionNonTsAssignedObj tsRestaurantQuesionNonTsAssignedObj = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_QUESTION_INSERT_SQL);
            statement.setString(1, userId);

            statement.setString(2, postQuestionOnForum);

            statement.setTimestamp(3,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            String questionId = userId +
                CommonFunctionsUtil.generateUniqueKey();

            statement.setString(4, questionId);
            statement.setString(5, questionText);
            statement.setString(6, restaurantId);
            statement.executeUpdate();
            statement.close();

            String userAssignedFriendType = null;
            String friendTrustedFlag = null;
            String questionRestaurantId = null;

            for (String recommendersUserId : recommendersUserIdList) {
                statement = connection.prepareStatement(TSDBCommonQueries.FRIEND_TRUSTED_FLAG_SELECT_SQL);
                statement.setString(1, userId);
                statement.setString(2, recommendersUserId);

                resultset = statement.executeQuery();

                if (resultset.next()) {
                    userAssignedFriendType = "user-assigned-friend";
                    friendTrustedFlag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_friend_tastesync.FRIEND_TRUSTED_FLAG"));
                } else {
                    userAssignedFriendType = "user-assigned-non-friend";
                    friendTrustedFlag = "N";
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.QUESTION_DETAILS_RESTAURANT_SELECT_SQL);
                statement.setString(1, questionId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    questionRestaurantId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant_question_user.restaurant_id"));
                }

                statement.close();

                statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_QUESTION_TS_ASSIGNED_INSERT_SQL);
                statement.setString(1, "N");
                statement.setString(2, friendTrustedFlag);
                statement.setString(3, recommendersUserId);
                statement.setString(4, userAssignedFriendType);
                statement.setString(5, recommendersUserId);
                statement.setString(6, "Y");
                statement.setString(7, questionId);
                statement.setString(8, questionRestaurantId);
                statement.setTimestamp(9,
                    CommonFunctionsUtil.getCurrentDateTimestamp());

                statement.executeUpdate();
                statement.close();
            }

            statement.close();

            userAssignedFriendType = null;
            friendTrustedFlag = null;

            String friendUserId = null;
            String friendTsUserId = null;

            List<String> nonTsAssignedFacebookIdList = new ArrayList<String>();

            for (String friendsFacebookId : friendsFacebookIdList) {
                statement = connection.prepareStatement(RestaurantQueries.USERS_ID_SELECT_SQL);
                statement.setString(1, friendsFacebookId);

                resultset = statement.executeQuery();

                if (resultset.next()) {
                    friendUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_id"));
                    friendTsUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.TS_USER_ID"));

                    statement = connection.prepareStatement(TSDBCommonQueries.FRIEND_TRUSTED_FLAG_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, friendUserId);

                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        friendTrustedFlag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "user_friend_tastesync.FRIEND_TRUSTED_FLAG"));
                    } else {
                        friendTrustedFlag = "N";
                    }

                    statement.close();

                    statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_QUESTION_TS_ASSIGNED_INSERT_SQL);
                    statement.setString(1, "N");
                    statement.setString(2, friendTrustedFlag);
                    statement.setString(3, friendTsUserId);
                    statement.setString(4, "user-assigned-friend");
                    statement.setString(5, friendUserId);
                    statement.setString(6, "Y");
                    statement.setString(7, questionId);
                    statement.setString(8, restaurantId);
                    statement.setTimestamp(9,
                        CommonFunctionsUtil.getCurrentDateTimestamp());
                    statement.executeUpdate();
                    statement.close();
                } else {
                    nonTsAssignedFacebookIdList.add(friendsFacebookId);
                    statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_QUESTION_NON_TS_ASSIGNED_INSERT_SQL);
                    statement.setString(1, friendsFacebookId);
                    statement.setString(2, "N");
                    statement.setString(3, "N");
                    statement.setString(4, "user-assigned-friend");
                    statement.setString(5, "N");
                    statement.setString(6, questionId);
                    statement.setString(7, restaurantId);
                    statement.setTimestamp(8,
                        CommonFunctionsUtil.getCurrentDateTimestamp());
                    statement.executeUpdate();
                    statement.close();
                }
            }

            tsRestaurantQuesionNonTsAssignedObj = new TSRestaurantQuesionNonTsAssignedObj();
            tsRestaurantQuesionNonTsAssignedObj.setQuestionId(questionId);
            tsRestaurantQuesionNonTsAssignedObj.setFriendsNonTsUserFacebookId(nonTsAssignedFacebookIdList);

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while creating restaurant tips " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRestaurantQuesionNonTsAssignedObj;
    }

    @Override
    public void submitRestaurantDetailTip(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String tipText, String shareOnFacebook, String shareOnTwitter)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            String tipId = userId + CommonFunctionsUtil.generateUniqueKey();

            //TODO Add ALGO_STATUS column to restaurant_tips_tastesync
            statement = connection.prepareStatement(RestaurantQueries.RESTAURANT_TIP_INSERT_SQL);
            statement.setString(1, restaurantId);
            statement.setString(2, tipId);
            statement.setString(3, tipText);
            statement.setString(4, userId);
            statement.executeUpdate();
            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                String facebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users.user_fb_id"));

                statement.close();

                if ("1".equals(shareOnFacebook)) {
                    statement = connection.prepareStatement(TSDBCommonQueries.HISTORICAL_USER_SHARED_DATA_INSERT_SQL);

                    //datetime userid random number
                    statement.setString(1, facebookId);

                    List<String> inputKeyStr = new ArrayList<String>();
                    inputKeyStr.add(userId);

                    statement.setString(2,
                        CommonFunctionsUtil.generateUniqueKey(inputKeyStr));
                    statement.setTimestamp(3,
                        CommonFunctionsUtil.getCurrentDateTimestamp());
                    statement.setString(4, tipText);
                    statement.setString(5, "facebook_post");
                    statement.setString(6, userId);

                    statement.setString(1, userId);
                    statement.executeUpdate();

                    statement.close();
                }

                //TODO Twitter - ph2
            }

            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while creating restaurant tips " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void submitSaveOrUnsaveRestaurant(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantSavedFlag) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            if (TSConstants.INT_INSERT.equals(userRestaurantSavedFlag)) {
                statement = connection.prepareStatement(RestaurantQueries.SAVERESTAURANTFAV_INSERT_SQL);
                statement.setString(1, restaurantId);
                statement.setString(2, userId);
                statement.executeUpdate();
            } else if (TSConstants.INT_DELETE.endsWith(userRestaurantSavedFlag)) {
                statement = connection.prepareStatement(RestaurantQueries.SAVERESTAURANTFAV_DELETE_SQL);
                statement.setString(1, userId);
                statement.setString(2, restaurantId);
                statement.executeUpdate();
            } else {
                throw new TasteSyncException("Error Unknown Operation");
            }

            statement.close();

            statement = connection.prepareStatement(RestaurantQueries.SAVERESTAURANTFAV_HISTORICAL_INSERT_SQL);

            List<String> inputKeyStr = new ArrayList<String>();
            inputKeyStr.add(userId);
            statement.setString(1,
                CommonFunctionsUtil.generateUniqueKey(inputKeyStr));
            statement.setString(2, restaurantId);
            statement.setString(3, userRestaurantSavedFlag);
            statement.setString(4, null);
            statement.setTimestamp(5,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(6, userId);
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

            throw new TasteSyncException(
                "Error while creating restaurant tips " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }
}
