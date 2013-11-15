package com.tastesync.db.dao;

import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;

import com.tastesync.algo.model.vo.RestaurantsSearchResultsVO;
import com.tastesync.algo.user.restaurant.RestaurantsSearchResultsOnlineCalc;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;
import com.tastesync.db.queries.AskReplyQueries;
import com.tastesync.db.queries.TSDBCommonQueries;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSNotifDidYouLikeObj;
import com.tastesync.model.objects.TSNotifFollowupQuestionObj;
import com.tastesync.model.objects.TSNotifMessageForYouObj;
import com.tastesync.model.objects.TSNotifRecoLikeObj;
import com.tastesync.model.objects.TSNotifRecoReplyObj;
import com.tastesync.model.objects.TSNotifRecorequestAnswerObj;
import com.tastesync.model.objects.TSNotifRecorequestNeededObj;
import com.tastesync.model.objects.TSRecoNotificationBaseObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;
import com.tastesync.model.objects.derived.TSRecoRequestNonAssignedObj;
import com.tastesync.model.objects.derived.TSRecoRequestObj;
import com.tastesync.model.objects.derived.TSRecommendationsFollowupObj;
import com.tastesync.model.objects.derived.TSRecommendationsForYouObj;
import com.tastesync.model.objects.derived.TSRecommendationsObj;
import com.tastesync.model.objects.derived.TSRecommendeeUserObj;
import com.tastesync.model.objects.derived.TSRestaurantsForYouObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchExtendedInfoObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;
import com.tastesync.model.objects.derived.TSSenderUserObj;
import com.tastesync.model.vo.DescriptorDataVO;
import com.tastesync.model.vo.NotifRecoReplyVO;
import com.tastesync.model.vo.RecommendationsForYouVO;

import com.tastesync.util.TSConstants;

import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Properties;


public class AskReplyDAOImpl extends BaseDaoImpl implements AskReplyDAO {
    // need to load in static block
    // need to load in static block
    public String createRecoRequestTemplateText(Connection connection,
        String[] cuisineTier1IdList, String[] cuisineTier2IdList,
        String[] priceIdList, String[] themeIdList,
        String[] whoareyouwithIdList, String[] typeOfRestaurantIdList,
        String[] occasionIdList, String neighborhoodId, String cityId,
        String stateName) throws TasteSyncException {
        StringBuffer finalTemplateString = new StringBuffer();
        Properties prop = new Properties();
        InputStream ifile = null;

        try {
            //loader.getResourceAsStream("Resources/SomeConfig.xml");
            ifile = this.getClass().getClassLoader()
                        .getResourceAsStream("Resources/config.properties");
            //load a properties file
            prop.load(ifile);

            //get the property value and print it out
            DescriptorDataVO descriptorDataVO = getDescriptorDataForDifferentIds(connection,
                    cuisineTier1IdList, cuisineTier2IdList, priceIdList,
                    themeIdList, whoareyouwithIdList, typeOfRestaurantIdList,
                    occasionIdList, neighborhoodId, cityId, stateName);

            ArrayList<String> cuisineTier1IdDescList = descriptorDataVO.getCuisineTier1IdDescList();
            ArrayList<String> cuisineTier2IdDescList = descriptorDataVO.getCuisineTier2IdDescList();
            ArrayList<String> occasionIdDescList = descriptorDataVO.getOccasionIdDescList();
            ArrayList<String> whoareyouwithIdDescList = descriptorDataVO.getWhoareyouwithIdDescList();
            ArrayList<String> typeOfRestaurantIdDescList = descriptorDataVO.getTypeOfRestaurantIdDescList();
            ArrayList<String> themeIdDescList = descriptorDataVO.getThemeIdDescList();
            ArrayList<String> priceIdDescList = descriptorDataVO.getPriceIdDescList();

            StringBuffer textToBeReplaced = new StringBuffer();
            textToBeReplaced.append(" ");

            // get cuisines desc
            String templateString = prop.getProperty("search.cuisine.location");

            int cuisineTier1IdDescListSize = cuisineTier1IdDescList.size();

            int cuisineTier2IdDescListSize = cuisineTier2IdDescList.size();

            for (int i = 0; i < cuisineTier1IdDescListSize; ++i) {
                textToBeReplaced.append(cuisineTier1IdDescList.get(i));

                if (cuisineTier2IdDescListSize == 0) {
                    if ((i != (cuisineTier1IdDescListSize - 1)) &&
                            (i != (cuisineTier1IdDescListSize - 2))) {
                        textToBeReplaced.append(", ");
                    } else if ((cuisineTier1IdDescListSize > 1) &&
                            (i == (cuisineTier1IdDescListSize - 2))) {
                        textToBeReplaced.append(" or ");
                    } else if (i == (cuisineTier1IdDescListSize - 1)) {
                        textToBeReplaced.append(" ");
                    }
                } else {
                    textToBeReplaced.append(", ");
                }
            }

            for (int i = 0; i < cuisineTier2IdDescListSize; ++i) {
                textToBeReplaced.append(cuisineTier2IdDescList.get(i));

                if ((i != (cuisineTier2IdDescListSize - 1)) &&
                        (i != (cuisineTier2IdDescListSize - 2))) {
                    textToBeReplaced.append(", ");
                } else if ((cuisineTier2IdDescListSize > 1) &&
                        (i == (cuisineTier2IdDescListSize - 2))) {
                    textToBeReplaced.append(" or ");
                } else if (i == (cuisineTier2IdDescListSize - 1)) {
                    textToBeReplaced.append(" ");
                }
            }

            String tempTemplateString = StringUtils.replace(templateString,
                    "<cuisine>", textToBeReplaced.toString());

            templateString = tempTemplateString;

            // Get location related info.
            textToBeReplaced = new StringBuffer();

            if ((neighborhoodId != null) && !neighborhoodId.isEmpty()) {
                textToBeReplaced.append(descriptorDataVO.getNeighborhoodName())
                                .append(", ");
            }

            textToBeReplaced.append(descriptorDataVO.getCityName());

            tempTemplateString = StringUtils.replace(templateString,
                    "<location>", textToBeReplaced.toString());

            finalTemplateString.append(tempTemplateString);

            cuisineTier1IdDescList = null;

            textToBeReplaced = new StringBuffer();

            //get occasion desc
            if (occasionIdDescList.size() > 0) {
                templateString = prop.getProperty("search.occasion");

                for (int i = 0; i < occasionIdDescList.size(); ++i) {
                    textToBeReplaced.append(occasionIdDescList.get(i));

                    if (i != (occasionIdDescList.size() - 1)) {
                        textToBeReplaced.append("/");
                    }
                }

                if ((textToBeReplaced.toString() != null) &&
                        !textToBeReplaced.toString().isEmpty()) {
                    tempTemplateString = StringUtils.replace(templateString,
                            "<occasion>", textToBeReplaced.toString());
                    finalTemplateString.append(" ").append(tempTemplateString);
                }
            }

            occasionIdDescList = null;
            textToBeReplaced = new StringBuffer();

            // get whoareyouwith
            if (whoareyouwithIdDescList.size() > 0) {
                templateString = prop.getProperty("search.whoareyouwith");

                for (int i = 0; i < whoareyouwithIdDescList.size(); ++i) {
                    textToBeReplaced.append(whoareyouwithIdDescList.get(i));

                    if (i != (whoareyouwithIdDescList.size() - 1)) {
                        textToBeReplaced.append("/");
                    }
                }

                if ((textToBeReplaced.toString() != null) &&
                        !textToBeReplaced.toString().isEmpty()) {
                    tempTemplateString = StringUtils.replace(templateString,
                            "<whoareyouwith>", textToBeReplaced.toString());
                    finalTemplateString.append(" ").append(tempTemplateString);
                }
            }

            whoareyouwithIdDescList = null;
            textToBeReplaced = new StringBuffer();

            // get typeOfRestaurant 
            if (typeOfRestaurantIdDescList.size() > 0) {
                templateString = prop.getProperty("search.typeofrest");

                for (int i = 0; i < typeOfRestaurantIdDescList.size(); ++i) {
                    textToBeReplaced.append(typeOfRestaurantIdDescList.get(i));

                    if (i != (typeOfRestaurantIdDescList.size() - 1)) {
                        textToBeReplaced.append("/");
                    }
                }

                if ((textToBeReplaced.toString() != null) &&
                        !textToBeReplaced.toString().isEmpty()) {
                    tempTemplateString = StringUtils.replace(templateString,
                            "<typeofrest>", textToBeReplaced.toString());
                    finalTemplateString.append(" ").append(tempTemplateString);
                }
            }

            typeOfRestaurantIdDescList = null;
            textToBeReplaced = new StringBuffer();

            //get typeOfRestaurant 
            if (themeIdDescList.size() > 0) {
                templateString = prop.getProperty("search.restaurant.theme");

                for (int i = 0; i < themeIdDescList.size(); ++i) {
                    textToBeReplaced.append(themeIdDescList.get(i));

                    if (i != (themeIdDescList.size() - 1)) {
                        textToBeReplaced.append("/");
                    }
                }

                if ((textToBeReplaced.toString() != null) &&
                        !textToBeReplaced.toString().isEmpty()) {
                    tempTemplateString = StringUtils.replace(templateString,
                            "<theme>", textToBeReplaced.toString());
                    finalTemplateString.append(" ").append(tempTemplateString);
                }
            }

            themeIdDescList = null;

            // define price id values 
            int priceIdValueType = 0;

            if (priceIdDescList.size() > 0) {
                Collections.sort(priceIdDescList);

                if (priceIdDescList.size() == 1) {
                    if ("$".equals(priceIdDescList.get(0))) {
                        priceIdValueType = 1;
                    } else if ("$$".equals(priceIdDescList.get(0))) {
                        priceIdValueType = 2;
                    } else if ("$$$".equals(priceIdDescList.get(0))) {
                        priceIdValueType = 3;
                    } else {
                        priceIdValueType = -1;
                    }
                }

                if (priceIdValueType == -1) {
                    if (priceIdDescList.size() == 2) {
                        if ("$".equals(priceIdDescList.get(0)) &&
                                "$$".equals(priceIdDescList.get(1))) {
                            priceIdValueType = 2;
                        } else if ("$$".equals(priceIdDescList.get(0)) &&
                                "$$$".equals(priceIdDescList.get(1))) {
                            priceIdValueType = 2;
                        } else if ("$$$".equals(priceIdDescList.get(0)) &&
                                "$$$$".equals(priceIdDescList.get(1))) {
                            priceIdValueType = 3;
                        } else {
                            priceIdValueType = -1;
                        }
                    }
                }

                if (priceIdValueType == -1) {
                    if (priceIdDescList.size() == 3) {
                        if ("$".equals(priceIdDescList.get(0)) &&
                                "$$".equals(priceIdDescList.get(1)) &&
                                "$$$".equals(priceIdDescList.get(2))) {
                            priceIdValueType = 2;
                        } else if (("$$$".equals(priceIdDescList.get(0)) &&
                                "$$$$".equals(priceIdDescList.get(1)) &&
                                "$$$$$".equals(priceIdDescList.get(2)))) {
                            priceIdValueType = 3;
                        } else {
                            priceIdValueType = -1;
                        }
                    }
                }

                if (priceIdValueType == 1) {
                    templateString = prop.getProperty(
                            "search.restaurant.price.1");
                    finalTemplateString.append(" ").append(templateString);
                } else if (priceIdValueType == 2) {
                    templateString = prop.getProperty(
                            "search.restaurant.price.3.less");
                    finalTemplateString.append(" ").append(templateString);
                } else if (priceIdValueType == 3) {
                    templateString = prop.getProperty(
                            "search.restaurant.price.3.more");
                    finalTemplateString.append(" ").append(templateString);
                } else {
                    finalTemplateString.append("");
                }
            }

            //System.out.println("finalTemplateString=" + finalTemplateString);
            return finalTemplateString.toString();
        } catch (IOException ex) {
            ex.printStackTrace();
            throw new TasteSyncException(ex.getMessage());
        } finally {
            if (ifile != null) {
                try {
                    ifile.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public String[] getCuisine2FromCuisine1Mapper(Connection connection,
        String[] cuisineTier1IdList) throws TasteSyncException {
        if ((cuisineTier1IdList == null) || (cuisineTier1IdList.length == 0)) {
            new ArrayList<String>();
        }

        List<String> cuisineTier2IdList = new ArrayList<String>();
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.CUISINE_TIER2_FROM_CUISINE_TIER1_SELECT_SQL);

            String cuisineTier2Id = null;

            for (String cuisineTier1Id : cuisineTier1IdList) {
                statement.setString(1, cuisineTier1Id);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    cuisineTier2Id = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "CUISINE_TIER_MAPPER.TIER2_CUISINE_ID"));

                    if (!cuisineTier2IdList.contains(cuisineTier2Id)) {
                        cuisineTier2IdList.add(cuisineTier2Id);
                    }
                }
            }

            statement.close();

            return cuisineTier2IdList.isEmpty() ? null
                                                : cuisineTier2IdList.toArray(new String[cuisineTier2IdList.size()]);
        } catch (SQLException e) {
            e.printStackTrace();

            throw new TasteSyncException(
                "Error while creating restaurant tips " + e.getMessage());
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

    private String getCuisineTier2Desc(Connection connection,
        String restaurantId, String[] cuisineTier2IdArray)
        throws SQLException {
        String cuisineTier2Desc = null;
        String sql = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        //get cuisine Tier2 descriptor out of input
        if ((cuisineTier2IdArray != null) && (cuisineTier2IdArray.length != 0)) {
            sql = AskReplyQueries.CUISINE_TIER2_DESCRIPTOR_SEARCH_RESULTS_SELECT_SQL;

            StringBuffer buildQuestionMarksInSql = new StringBuffer();

            // add additonal parameters as ?
            for (int i = 0; i < cuisineTier2IdArray.length; ++i) {
                buildQuestionMarksInSql.append("?");

                if (i != (cuisineTier2IdArray.length - 1)) {
                    buildQuestionMarksInSql.append(",");
                }
            }

            sql = StringUtils.replace(sql, "1_REPLACE_PARAM",
                    buildQuestionMarksInSql.toString());
            statement = connection.prepareStatement(sql);

            int bindposition = 0;

            for (String cuisineTier2Id : cuisineTier2IdArray) {
                ++bindposition;
                statement.setString(bindposition, cuisineTier2Id);
            }

            ++bindposition;
            statement.setString(bindposition, restaurantId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                cuisineTier2Desc = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "CUISINE_TIER2_DESCRIPTOR.CUISINE_DESC"));
            }

            statement.close();
        }

        return cuisineTier2Desc;
    }

    private DescriptorDataVO getDescriptorDataForDifferentIds(
        Connection connection, String[] cuisineTier1IdList,
        String[] cuisineTier2IdList, String[] priceIdList,
        String[] themeIdList, String[] whoareyouwithIdList,
        String[] typeOfRestaurantIdList, String[] occasionIdList,
        String neighborhoodId, String cityId, String stateName)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            ArrayList<String> cuisineTier1IdDescList = new ArrayList<String>();
            ArrayList<String> cuisineTier2IdDescList = new ArrayList<String>();
            ArrayList<String> occasionIdDescList = new ArrayList<String>();
            ArrayList<String> whoareyouwithIdDescList = new ArrayList<String>();
            ArrayList<String> typeOfRestaurantIdDescList = new ArrayList<String>();
            ArrayList<String> themeIdDescList = new ArrayList<String>();
            ArrayList<String> priceIdDescList = new ArrayList<String>();

            statement = connection.prepareStatement(AskReplyQueries.CUISINE_TIER1_DESCRIPTOR_ALL_SELECT_SQL);

            if (cuisineTier1IdList != null) {
                for (String cuisineTier1IdListElement : cuisineTier1IdList) {
                    if (cuisineTier1IdListElement != null) {
                        statement.setString(1, cuisineTier1IdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            cuisineTier1IdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("CUISINE_DESC")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.CUISINE_TIER2_DESCRIPTOR_ALL_SELECT_SQL);

            if (cuisineTier2IdList != null) {
                for (String aCuisineTier2IdList : cuisineTier2IdList) {
                    if (aCuisineTier2IdList != null) {
                        statement.setString(1, aCuisineTier2IdList);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            cuisineTier2IdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("CUISINE_DESC")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.OCCASION_DESCRIPTOR_SELECT_SQL);

            if (occasionIdList != null) {
                for (String occasionIdListElement : occasionIdList) {
                    if (occasionIdListElement != null) {
                        statement.setString(1, occasionIdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            occasionIdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("occasion_desc")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.WHOAREYOUWITH_DESCRIPTOR_SELECT_SQL);

            if (whoareyouwithIdList != null) {
                for (String whoareyouwithIdListElement : whoareyouwithIdList) {
                    if (whoareyouwithIdListElement != null) {
                        statement.setString(1, whoareyouwithIdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            whoareyouwithIdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("whoareyouwith_desc")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.TYPEOFREST_DESCRIPTOR_SELECT_SQL);

            if (typeOfRestaurantIdList != null) {
                for (String typeOfRestaurantIdListElement : typeOfRestaurantIdList) {
                    if (typeOfRestaurantIdListElement != null) {
                        statement.setString(1, typeOfRestaurantIdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            typeOfRestaurantIdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("typeofrest_desc")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.THEME_DESCRIPTOR_SELECT_SQL);

            if (themeIdList != null) {
                for (String themeIdListElement : themeIdList) {
                    if (themeIdListElement != null) {
                        statement.setString(1, themeIdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            themeIdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("THEME_DESC")));
                        }
                    }
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.PRICE_DESCRIPTOR_SELECT_SQL);

            if (priceIdList != null) {
                for (String priceIdListElement : priceIdList) {
                    if (priceIdListElement != null) {
                        statement.setString(1, priceIdListElement);
                        resultset = statement.executeQuery();

                        while (resultset.next()) {
                            priceIdDescList.add(CommonFunctionsUtil.getModifiedValueString(
                                    resultset.getString("price_desc")));
                        }
                    }
                }
            }

            statement.close();

            String cityName = "";

            if ((cityId != null) && !cityId.isEmpty()) {
                statement = connection.prepareStatement(AskReplyQueries.CITY_NAME_SELECT_SQL);
                statement.setString(1, cityId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    cityName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "CITY"));
                }

                statement.close();
            }

            String neighborhoodName = "";

            if ((neighborhoodId != null) && !neighborhoodId.isEmpty()) {
                statement = connection.prepareStatement(AskReplyQueries.NEIGHBOURHOOD_NAME_SELECT_SQL);
                statement.setString(1, neighborhoodId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    neighborhoodName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "NEIGHBOURHOOD_DESC"));
                }

                statement.close();
            }

            return new DescriptorDataVO(cuisineTier1IdDescList,
                cuisineTier2IdDescList, occasionIdDescList,
                whoareyouwithIdDescList, typeOfRestaurantIdDescList,
                themeIdDescList, priceIdDescList, cityName, neighborhoodName);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        }
    }

    private List<TSRecommendationsObj> getRecommendationsForRestaurantFromUsersList(
        Connection connection, String userId,
        List<String> recommenderUserIdList, List<String> replyTextList)
        throws SQLException {
        PreparedStatement st = null;
        ResultSet rs = null;

        String recommenderUserFolloweeFlag = null;

        String recommenderUserIdFacebookId = null;
        String recommenderUserName = null;
        String recommenderUserPhoto = null;
        int index = 0;
        List<TSRecommendationsObj> recommendationsForYouList = new ArrayList<TSRecommendationsObj>();

        try {
            //TODO Duplicates
            for (String recommenderUserId : recommenderUserIdList) {
                TSRecommendationsObj tsRecommendationsObj = new TSRecommendationsObj();

                st = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
                st.setString(1, recommenderUserId);
                st.setString(2, userId);

                rs = st.executeQuery();
                recommenderUserFolloweeFlag = "0"; //default

                int rowCount = 0;

                if (rs.next()) {
                    rowCount = rs.getInt(1);
                }

                if (rowCount > 0) {
                    recommenderUserFolloweeFlag = "1";
                }

                st.close();

                st = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                st.setString(1, recommenderUserId);
                rs = st.executeQuery();

                if (rs.next()) {
                    recommenderUserIdFacebookId = CommonFunctionsUtil.getModifiedValueString(rs.getString(
                                "users.user_fb_id"));

                    if (st != null) {
                        st.close();
                    }

                    st = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    st.setString(1, recommenderUserIdFacebookId);
                    rs = st.executeQuery();

                    if (rs.next()) {
                        recommenderUserName = CommonFunctionsUtil.getModifiedValueString(rs.getString(
                                    "facebook_user_data.name"));
                        recommenderUserPhoto = CommonFunctionsUtil.getModifiedValueString(rs.getString(
                                    "facebook_user_data.picture"));
                    }

                    st.close();
                }

                TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
                recommendeeUser.setName(recommenderUserName);
                recommendeeUser.setPhoto(recommenderUserPhoto);
                recommendeeUser.setUserId(recommenderUserId);

                tsRecommendationsObj.setRecommendeeUser(recommendeeUser);
                tsRecommendationsObj.setRecommenderUserFolloweeFlag(recommenderUserFolloweeFlag);
                tsRecommendationsObj.setReplyText(replyTextList.get(index));
                ++index;
                recommendationsForYouList.add(tsRecommendationsObj);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }

            if (st != null) {
                st.close();
            }
        }

        return recommendationsForYouList;
    }

    private String getUnreadCounterNotificationsAll(Connection connection,
        String userId) throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        String unreadCounter = "0";

        try {
            statement = connection.prepareStatement(AskReplyQueries.COUNT_UNREAD_NOTIFICATIONS_ALL_SELECT_SQL);

            statement.setString(1, userId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                unreadCounter = String.valueOf(resultset.getInt(1));
            }

            statement.close();

            return unreadCounter;
        } finally {
            if (resultset != null) {
                resultset.close();
            }

            if (statement != null) {
                statement.close();
            }
        }
    }

    // for restaurant search based on reco request id related parameters 
    private RestaurantsSearchResultsVO identifyRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userIdFrmDb,
        String recoRequestLocationNeighborhoodId,
        String recoRequestLocationCityId, String[] priceIdArray,
        String paginationId, String[] cuisineTier2IdArray,
        String[] themeIdArray, String[] whoareyouwithIdArray,
        String[] typeOfRestaurantIdArray, String[] occasionIdArray)
        throws TasteSyncException {
        return identifyRestaurantsSearchResults(tsDataSource, connection,
            userIdFrmDb, null, recoRequestLocationNeighborhoodId,
            recoRequestLocationCityId, null, priceIdArray, null, null, null,
            null, null, paginationId, cuisineTier2IdArray, themeIdArray,
            whoareyouwithIdArray, typeOfRestaurantIdArray, occasionIdArray);
    }

    // for restaurant search based on city id related parameters 
    private RestaurantsSearchResultsVO identifyRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String neighborhoodId, String cityId,
        String stateName, String[] priceIdList, String rating,
        String savedFlag, String favFlag, String dealFlag, String chainFlag,
        String paginationId, String[] cuisineTier2IdArray)
        throws TasteSyncException {
        return identifyRestaurantsSearchResults(tsDataSource, connection,
            userId, restaurantId, neighborhoodId, cityId, stateName,
            priceIdList, rating, savedFlag, favFlag, dealFlag, chainFlag,
            paginationId, cuisineTier2IdArray, null, null, null, null);
    }

    private RestaurantsSearchResultsVO identifyRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String neighborhoodId, String cityId,
        String stateName, String[] priceIdList, String rating,
        String savedFlag, String favFlag, String dealFlag, String chainFlag,
        String paginationId, String[] cuisineTier2IdArray,
        String[] themeIdArray, String[] whoareyouwithIdArray,
        String[] typeOfRestaurantIdArray, String[] occasionIdArray)
        throws TasteSyncException {
        List<String> restaurantIdList = new ArrayList<String>();

        if (restaurantId != null) {
            restaurantIdList.add(restaurantId);

            return new RestaurantsSearchResultsVO(String.valueOf(1),
                restaurantIdList);
        }

        // get the corresponding results

        // call to algo!!
        RestaurantsSearchResultsOnlineCalc restaurantsSearchResultsOnlineCalc = new RestaurantsSearchResultsOnlineCalc();

        try {
            return restaurantsSearchResultsOnlineCalc.showListOfRestaurantsSearchResults(tsDataSource,
                connection, userId, restaurantId, neighborhoodId, cityId,
                stateName, priceIdList, rating, savedFlag, favFlag, dealFlag,
                chainFlag, paginationId, cuisineTier2IdArray, themeIdArray,
                whoareyouwithIdArray, typeOfRestaurantIdArray, occasionIdArray);
        } catch (com.tastesync.algo.exception.TasteSyncException e) {
            e.printStackTrace();
            throw new TasteSyncException(e.getMessage());
        }
    }

    private void processTSNotifDidYouLikeObj(Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        PreparedStatement statementInner = null;
        ResultSet resultsetInner = null;

        PreparedStatement statementInner1 = null;
        ResultSet resultsetInner1 = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RECOREPLY_DIDIYOULIKE_SELECT_SQL);
            statement.setString(1, tsRecoNotificationBaseObjElement.getIdBase());
            resultset = statement.executeQuery();

            String recorequestId = null;

            while (resultset.next()) {
                TSNotifDidYouLikeObj tsNotifDidYouLikeObj = new TSNotifDidYouLikeObj();

                recorequestId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recoreply_didyoulike_notif.recorequest_id"));
                tsNotifDidYouLikeObj.setRecorequestId(recorequestId);
                tsNotifDidYouLikeObj.setIdBase(recorequestId);

                tsNotifDidYouLikeObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_DID_LIKE);
                tsNotifDidYouLikeObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                String datetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recoreply_didyoulike_notif.notif_datetime"));

                //Date formatting
                tsNotifDidYouLikeObj.setDatetime(datetime);

                tsNotifDidYouLikeObj.setDatetimeBase(resultset.getTimestamp(
                        "recoreply_didyoulike_notif.notif_datetime"));

                tsNotifDidYouLikeObj.setViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recoreply_didyoulike_notif.notif_viewed")));

                List<TSRestaurantBasicObj> tsRestaurantBasicObjList = new ArrayList<TSRestaurantBasicObj>();
                String recommendedrestaurantsRestaurantId = null;
                String recommendedrestaurantsRestaurantName = null;

                statementInner = connection.prepareStatement(AskReplyQueries.RECOREQUEST_RESTAURANT_SELECT_SQL);
                statementInner.setString(1, recorequestId);
                resultsetInner = statementInner.executeQuery();

                while (resultsetInner.next()) {
                    recommendedrestaurantsRestaurantId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "restaurant_id"));

                    statementInner1 = connection.prepareStatement(AskReplyQueries.RESTAURANT_NAME_SELECT_SQL);
                    statementInner1.setString(1,
                        recommendedrestaurantsRestaurantId);
                    resultsetInner1 = statementInner1.executeQuery();

                    if (resultsetInner1.next()) {
                        recommendedrestaurantsRestaurantName = CommonFunctionsUtil.getModifiedValueString(resultsetInner1.getString(
                                    "restaurant.restaurant_name"));
                    }

                    statementInner1.close();

                    TSRestaurantBasicObj tsRestaurantBasicObj = new TSRestaurantBasicObj();
                    tsRestaurantBasicObj.setRestaurantId(recommendedrestaurantsRestaurantId);
                    tsRestaurantBasicObj.setRestaurantName(recommendedrestaurantsRestaurantName);
                    tsRestaurantBasicObjList.add(tsRestaurantBasicObj);
                }

                statementInner.close();

                tsNotifDidYouLikeObj.setRestaurantbasic(tsRestaurantBasicObjList);

                recoNotificationBaseList.add(tsNotifDidYouLikeObj);
            }

            if (statement != null) {
                statement.close();
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }

            if (statementInner != null) {
                statementInner.close();
            }

            if (resultsetInner != null) {
                resultsetInner.close();
            }

            if (statementInner1 != null) {
                statementInner1.close();
            }

            if (resultsetInner1 != null) {
                resultsetInner1.close();
            }
        }
    }

    private void processTSNotifFollowupQuestionObj(Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        PreparedStatement statementInner = null;
        ResultSet resultsetInner = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RESTAURANT_QUESTION_TS_ASSIGNED_NOTIF_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, tsRecoNotificationBaseObjElement.getIdBase());
            resultset = statement.executeQuery();

            String questionId = null;

            while (resultset.next()) {
                TSNotifFollowupQuestionObj tsNotifFollowupQuestionObj = new TSNotifFollowupQuestionObj();

                questionId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_ts_assigned.question_id"));
                tsNotifFollowupQuestionObj.setQuestionId(questionId);

                tsNotifFollowupQuestionObj.setIdBase(questionId);

                tsNotifFollowupQuestionObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_FOLLOWUP);
                tsNotifFollowupQuestionObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                String assignedDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_ts_assigned.assigned_datetime"));

                //Date formatting
                tsNotifFollowupQuestionObj.setAssignedDatetime(assignedDatetime);

                tsNotifFollowupQuestionObj.setDatetimeBase(resultset.getTimestamp(
                        "restaurant_question_ts_assigned.assigned_datetime"));

                tsNotifFollowupQuestionObj.setViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "restaurant_question_ts_assigned.question_assigned_viewed")));

                statementInner = connection.prepareStatement(AskReplyQueries.COUNT_QUESTION_REPLY_USER_SELECT_SQL);
                tsNotifFollowupQuestionObj.setActioned("0");
                statementInner.setString(1, questionId);
                statementInner.setString(2, userId);

                resultsetInner = statementInner.executeQuery();

                int rowCount = 0;

                if (resultsetInner.next()) {
                    rowCount = resultsetInner.getInt(1);

                    if (rowCount > 0) {
                        tsNotifFollowupQuestionObj.setActioned("1");
                    }
                }

                statementInner.close();

                statementInner = connection.prepareStatement(TSDBCommonQueries.QUESTION_DETAILS_RESTAURANT_SELECT_SQL);
                statementInner.setString(1, questionId);
                resultsetInner = statementInner.executeQuery();

                String questionUserId = null;
                String questionText = null;
                String questionUserFacebookId = null;
                String questionUserName = null;
                String questionUserPhoto = null;

                if (resultsetInner.next()) {
                    questionUserId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "restaurant_question_user.initiator_user_id"));
                    questionText = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "restaurant_question_user.question_text"));
                    statementInner.close();

                    statementInner = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                    statementInner.setString(1, questionUserId);
                    resultsetInner = statementInner.executeQuery();

                    if (resultsetInner.next()) {
                        questionUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "users.user_fb_id"));

                        statementInner.close();

                        statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                        statementInner.setString(1, questionUserFacebookId);
                        resultsetInner = statementInner.executeQuery();

                        if (resultsetInner.next()) {
                            questionUserName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                        "facebook_user_data.name"));
                            questionUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                        "facebook_user_data.picture"));
                        }

                        statementInner.close();
                    }

                    if (statementInner != null) {
                        statementInner.close();
                    }
                }

                if (statementInner != null) {
                    statementInner.close();
                }

                TSUserProfileBasicObj questionUser = new TSUserProfileBasicObj();
                questionUser.setName(questionUserName);
                questionUser.setPhoto(questionUserPhoto);
                questionUser.setUserId(questionUserId);

                tsNotifFollowupQuestionObj.setQuestionUser(questionUser);
                tsNotifFollowupQuestionObj.setQuestionText(questionText);

                recoNotificationBaseList.add(tsNotifFollowupQuestionObj);
            }

            if (statement != null) {
                statement.close();
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }

            if (statementInner != null) {
                statementInner.close();
            }

            if (resultsetInner != null) {
                resultsetInner.close();
            }
        }
    }

    private void processTSNotifMessageForYouObj(Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        PreparedStatement statementInner = null;
        ResultSet resultsetInner = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_RECIPIENT_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, tsRecoNotificationBaseObjElement.getIdBase());
            resultset = statement.executeQuery();

            String messageId = null;

            while (resultset.next()) {
                TSNotifMessageForYouObj tsNotifMessageForYouObj = new TSNotifMessageForYouObj();

                messageId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_message.message_id"));
                tsNotifMessageForYouObj.setMessageId(messageId);

                tsNotifMessageForYouObj.setIdBase(messageId);

                tsNotifMessageForYouObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_MESSAGE);
                tsNotifMessageForYouObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                String messageCreatedTime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_message.created"));

                //Date formatting
                tsNotifMessageForYouObj.setMessageCreatedTime(messageCreatedTime);

                tsNotifMessageForYouObj.setDatetimeBase(resultset.getTimestamp(
                        "user_message.created"));

                tsNotifMessageForYouObj.setViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "user_message.message_recipient_viewed")));

                statementInner = connection.prepareStatement(AskReplyQueries.COUNT_USER_MESSAGE_SELECT_SQL);
                tsNotifMessageForYouObj.setActioned("0");
                statementInner.setString(1, messageId);
                statementInner.setString(2, userId);

                resultsetInner = statementInner.executeQuery();

                int rowCount = 0;

                if (resultsetInner.next()) {
                    rowCount = resultsetInner.getInt(1);

                    if (rowCount > 0) {
                        tsNotifMessageForYouObj.setActioned("1");
                    }
                }

                statementInner.close();

                statementInner = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_SELECT_SQL);
                statementInner.setString(1, userId);
                statementInner.setString(2, messageId);

                resultsetInner = statementInner.executeQuery();

                String senderUserId = null;
                String message = null;
                String senderUserFacebookId = null;
                String senderUserName = null;
                String senderUserPhoto = null;

                if (resultsetInner.next()) {
                    senderUserId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "user_message.sender_id"));
                    message = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "user_message.content"));
                    statementInner.close();

                    statementInner = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                    statementInner.setString(1, senderUserId);
                    resultsetInner = statementInner.executeQuery();

                    if (resultsetInner.next()) {
                        senderUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "users.user_fb_id"));
                    }

                    statementInner.close();

                    statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    statementInner.setString(1, senderUserFacebookId);
                    resultsetInner = statementInner.executeQuery();

                    if (resultsetInner.next()) {
                        senderUserName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "facebook_user_data.name"));
                        senderUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "facebook_user_data.picture"));
                    }

                    statementInner.close();
                }

                if (statementInner != null) {
                    statementInner.close();
                }

                TSUserProfileBasicObj senderUser = new TSUserProfileBasicObj();
                senderUser.setName(senderUserName);
                senderUser.setPhoto(senderUserPhoto);
                senderUser.setUserId(senderUserId);

                tsNotifMessageForYouObj.setSenderUser(senderUser);
                tsNotifMessageForYouObj.setMessage(message);

                recoNotificationBaseList.add(tsNotifMessageForYouObj);
            }

            if (statement != null) {
                statement.close();
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }

            if (statementInner != null) {
                statementInner.close();
            }

            if (resultsetInner != null) {
                resultsetInner.close();
            }
        }
    }

    private void processTSNotifRecoLikeObj(Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        PreparedStatement statementInner = null;
        ResultSet resultsetInner = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RECO_LIKE_NOTIF_SELECT_SQL);
            statement.setString(1, tsRecoNotificationBaseObjElement.getIdBase());
            resultset = statement.executeQuery();

            String likeId = null;
            String recommendeeUserId = null;

            while (resultset.next()) {
                TSNotifRecoLikeObj tsNotifRecoLikeObj = new TSNotifRecoLikeObj();

                likeId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reco_like.id"));
                tsNotifRecoLikeObj.setLikeId(likeId);
                tsNotifRecoLikeObj.setIdBase(likeId);
                tsNotifRecoLikeObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_LIKE);
                tsNotifRecoLikeObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                String likeDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reco_like.like_datetime"));

                //Date formatting
                tsNotifRecoLikeObj.setLikeDatetime(likeDatetime);

                tsNotifRecoLikeObj.setDatetimeBase(resultset.getTimestamp(
                        "reco_like.like_datetime"));

                tsNotifRecoLikeObj.setViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("reco_like.like_recommender_viewed")));

                recommendeeUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reco_like.like_user_id"));

                String recommendeeFacebookId = null;
                String recommendeeUserName = null;
                String recommendeeUserPhoto = null;

                statementInner = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                statementInner.setString(1, recommendeeUserId);
                resultsetInner = statementInner.executeQuery();

                if (resultsetInner.next()) {
                    recommendeeFacebookId = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "users.user_fb_id"));

                    if (statementInner != null) {
                        statementInner.close();
                    }

                    statementInner = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    statementInner.setString(1, recommendeeFacebookId);
                    resultsetInner = statementInner.executeQuery();

                    if (resultsetInner.next()) {
                        recommendeeUserName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "facebook_user_data.name"));
                        recommendeeUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                    "facebook_user_data.picture"));
                    }

                    statementInner.close();
                }

                TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
                recommendeeUser.setName(recommendeeUserName);
                recommendeeUser.setPhoto(recommendeeUserPhoto);
                recommendeeUser.setUserId(recommendeeUserId);

                tsNotifRecoLikeObj.setRecommendeeUser(recommendeeUser);

                recoNotificationBaseList.add(tsNotifRecoLikeObj);
            }

            if (statement != null) {
                statement.close();
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }

            if (statementInner != null) {
                statementInner.close();
            }

            if (resultsetInner != null) {
                resultsetInner.close();
            }
        }
    }

    private void processTSNotifRecorequestAnswerObj(Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            TSNotifRecorequestAnswerObj tsNotifRecorequestAnswerObj = null;
            String recorequestIdElement = tsRecoNotificationBaseObjElement.getIdBase();
            tsNotifRecorequestAnswerObj = new TSNotifRecorequestAnswerObj();
            tsNotifRecorequestAnswerObj.setRecorequestId(recorequestIdElement);
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_LATEST_INFO_SELECT_SQL);
            statement.setString(1, recorequestIdElement);
            resultset = statement.executeQuery();
            tsNotifRecorequestAnswerObj.setMinViewedIndicator("1");

            if (resultset.next()) {
                TSNotifRecoReplyObj tsNotifRecoReplyObj = new TSNotifRecoReplyObj();
                tsNotifRecoReplyObj.setReplyId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("recorequest_reply_user.reply_id")));

                String repliedSendDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_reply_user.reply_send_datetime"));
                //TODO formatting!!
                tsNotifRecoReplyObj.setRepliedDatetime(repliedSendDatetime);

                tsNotifRecoReplyObj.setViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_reply_user.reply_viewed_initiator")));
                tsNotifRecorequestAnswerObj.setMinViewedIndicator(tsNotifRecoReplyObj.getViewed());

                tsNotifRecorequestAnswerObj.setDatetimeBase(resultset.getTimestamp(
                        "recorequest_reply_user.reply_send_datetime"));
                tsNotifRecorequestAnswerObj.setIdBase(recorequestIdElement);

                tsNotifRecorequestAnswerObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_ANSWER);

                tsNotifRecorequestAnswerObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                //                List<TSNotifRecoReplyObj> recoReplyList = new ArrayList<TSNotifRecoReplyObj>();
                //                recoReplyList.add(tsNotifRecoReplyObj);
                //                tsNotifRecorequestAnswerObj.setRecoReply(recoReplyList);
                List<String> allReplyIdFOrRequestIdList = new ArrayList<String>();

                statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_ALL_REPLIES_SELECT_SQL);
                statement.setString(1, recorequestIdElement);
                resultset = statement.executeQuery();

                while (resultset.next()) {
                    allReplyIdFOrRequestIdList.add(CommonFunctionsUtil.getModifiedValueString(
                            resultset.getString(
                                "recorequest_reply_user.reply_id")));
                }

                statement.close();

                NotifRecoReplyVO notifRecoReplyVO = null;
                List<NotifRecoReplyVO> notifRecoReplyVOList = new ArrayList<NotifRecoReplyVO>();

                statement = connection.prepareStatement(AskReplyQueries.COUNT_RECOREQUEST_REPLY_USER_ALL_REPLIES_SELECT_SQL);

                for (String replyIdElement : allReplyIdFOrRequestIdList) {
                    notifRecoReplyVO = new NotifRecoReplyVO();

                    notifRecoReplyVO.setReplyActioned("0");
                    statement.setString(1, recorequestIdElement);
                    statement.setString(2, recorequestIdElement);
                    statement.setString(3, replyIdElement);
                    statement.setString(4, userId);
                    resultset = statement.executeQuery();

                    int rowCount = 0;

                    if (resultset.next()) {
                        rowCount = resultset.getInt(1);

                        if (rowCount > 0) {
                            notifRecoReplyVO.setReplyActioned("1");
                        }
                    }

                    notifRecoReplyVOList.add(notifRecoReplyVO);
                }

                statement.close();

                tsNotifRecorequestAnswerObj.setRecoActioned("1");

                for (NotifRecoReplyVO notifRecoReplyVOElement : notifRecoReplyVOList) {
                    if ("0".equals(notifRecoReplyVOElement.getReplyActioned())) {
                        tsNotifRecorequestAnswerObj.setRecoActioned("0");

                        break;
                    }
                }

                statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TEMPLATE_SENTENCES_SELECT_SQL);
                statement.setString(1,
                    tsNotifRecorequestAnswerObj.getRecorequestId());
                resultset = statement.executeQuery();

                String recorequestText = "";

                //only one result
                if (resultset.next()) {
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.RECO_REQUEST_TEMPLATE_SENTENCES"));
                }

                statement.close();

                statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_RECO_REST_SELECT_SQL);
                statement.setString(1,
                    tsNotifRecorequestAnswerObj.getRecorequestId());
                resultset = statement.executeQuery();

                String restaurantIdValue = null;
                String recommenderUserId = null;
                String replyText = null;
                List<RecommendationsForYouVO> recommendationsForYouVOList = new ArrayList<RecommendationsForYouVO>();

                while (resultset.next()) {
                    restaurantIdValue = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant_id"));

                    recommenderUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recommender_user_id"));

                    replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "reply_text"));

                    RecommendationsForYouVO recommendationsForYouVO = new RecommendationsForYouVO(restaurantIdValue,
                            recommenderUserId, replyText);

                    recommendationsForYouVOList.add(recommendationsForYouVO);
                }

                statement.close();

                List<String> restaurantIdList = new ArrayList<String>();

                for (RecommendationsForYouVO recommendationsForYouVO : recommendationsForYouVOList) {
                    if (!restaurantIdList.contains(
                                recommendationsForYouVO.getRestaurantId())) {
                        restaurantIdList.add(recommendationsForYouVO.getRestaurantId());
                    }
                }

                List<String> recommenderUserIdList = null;
                List<String> replyTextList = null;

                List<TSRestaurantsForYouObj> restaurantsForYouObjList = new ArrayList<TSRestaurantsForYouObj>();
                TSUserProfileBasicObj latestRecommendeeUser = null;

                //check for duplicates
                for (String restaurantId : restaurantIdList) {
                    recommenderUserIdList = new ArrayList<String>();
                    replyTextList = new ArrayList<String>();

                    for (RecommendationsForYouVO recommendationsForYouVO : recommendationsForYouVOList) {
                        if (restaurantId.equals(
                                    recommendationsForYouVO.getRestaurantId())) {
                            recommenderUserIdList.add(recommendationsForYouVO.getRecommenderUserId());
                            replyTextList.add(recommendationsForYouVO.getReplyText());
                        }
                    }

                    List<TSRecommendationsObj> recommendationsForYouList = getRecommendationsForRestaurantFromUsersList(connection,
                            userId, recommenderUserIdList, replyTextList);

                    statement = connection.prepareStatement(TSDBCommonQueries.CITY_RESTAURANT_SELECT_SQL);
                    statement.setString(1, restaurantId);
                    resultset = statement.executeQuery();

                    String restaurantName = null;

                    while (resultset.next()) {
                        restaurantName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "restaurant.restaurant_name"));
                    }

                    statement.close();

                    TSRestaurantsForYouObj tsRestaurantsForYouObj = new TSRestaurantsForYouObj();
                    tsRestaurantsForYouObj.setRestaurantId(restaurantId);
                    tsRestaurantsForYouObj.setRestaurantName(restaurantName);
                    tsRestaurantsForYouObj.setRecommendationsForYouList(recommendationsForYouList);

                    if ((recommendationsForYouList != null) &&
                            !recommendationsForYouList.isEmpty()) {
                        latestRecommendeeUser = recommendationsForYouList.get(recommendationsForYouList.size() -
                                1).getRecommendeeUser();
                    }

                    restaurantsForYouObjList.add(tsRestaurantsForYouObj);
                }

                if (statement != null) {
                    statement.close();
                }

                TSRecommendationsForYouObj tsRecommendationsForYouObj = new TSRecommendationsForYouObj();
                tsRecommendationsForYouObj.setRecorequestText(recorequestText);
                tsRecommendationsForYouObj.setRestaurantsForYouObjList(restaurantsForYouObjList);
                tsRecommendationsForYouObj.setLatestRecommendeeUser(latestRecommendeeUser);

                tsNotifRecorequestAnswerObj.setRecommendationsForYou(tsRecommendationsForYouObj);
                recoNotificationBaseList.add(tsNotifRecorequestAnswerObj);
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }
        }
    }

    private void processTSNotifRecorequestNeededObjElement(
        Connection connection,
        TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement,
        List<TSRecoNotificationBaseObj> recoNotificationBaseList, String userId)
        throws SQLException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TS_ASSIGNED_ALL_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, tsRecoNotificationBaseObjElement.getIdBase());
            resultset = statement.executeQuery();

            TSNotifRecorequestNeededObj tsNotifRecorequestNeededObj = null;
            List<TSNotifRecorequestNeededObj> tsNotifRecorequestNeededObjList = new ArrayList<TSNotifRecorequestNeededObj>();

            while (resultset.next()) {
                tsNotifRecorequestNeededObj = new TSNotifRecorequestNeededObj();
                tsNotifRecorequestNeededObj.setDatetimeBase(resultset.getTimestamp(
                        "recorequest_ts_assigned.assigned_datetime"));

                String assignedDatetime = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_ts_assigned.assigned_datetime"));
                //TODO formatting!!
                tsNotifRecorequestNeededObj.setAssignedDatetime(assignedDatetime);

                tsNotifRecorequestNeededObj.setIdBase(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_ts_assigned.recorequest_id")));

                tsNotifRecorequestNeededObj.setRecoNotificationType(TSConstants.RECONOTIFICATION_TYPE_NEEDED);

                tsNotifRecorequestNeededObj.setRecorequestId(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_ts_assigned.recorequest_id")));

                tsNotifRecorequestNeededObj.setRecorequestassignedViewed(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_ts_assigned.recorequest_assigned_viewed")));

                tsNotifRecorequestNeededObj.setMaxPaginationId(String.valueOf(
                        tsRecoNotificationBaseObjElement.getMaxPaginationId()));

                tsNotifRecorequestNeededObjList.add(tsNotifRecorequestNeededObj);
            }

            statement.close();

            for (TSNotifRecorequestNeededObj tsNotifRecorequestNeededObjElement : tsNotifRecorequestNeededObjList) {
                statement = connection.prepareStatement(AskReplyQueries.COUNT_REPLIES_RECOREQUEST_REPLY_USER_SELECT_SQL);
                tsNotifRecorequestNeededObjElement.setRecorequestassignedActioned(
                    "0");
                statement.setString(1,
                    tsNotifRecorequestNeededObjElement.getRecorequestId());

                statement.setString(2, userId);

                resultset = statement.executeQuery();

                int rowCount = 0;

                if (resultset.next()) {
                    rowCount = resultset.getInt(1);

                    if (rowCount > 0) {
                        tsNotifRecorequestNeededObjElement.setRecorequestassignedActioned(
                            "1");
                    }
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_TS_ASSIGNED_SELECT_SQL);
                statement.setString(1,
                    tsNotifRecorequestNeededObjElement.getRecorequestId());
                statement.setString(2, userId);
                resultset = statement.executeQuery();

                String friendOrNot = null;

                //only one result
                if (resultset.next()) {
                    friendOrNot = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_ts_assigned.ASSIGNED_USERTYPE"));
                }

                if (statement != null) {
                    statement.close();
                }

                String recommendeeUserFacebookId = null;
                String recommendeeUserName = null;
                String recommendeeUserPhoto = null;
                String recommendeeUserUserId = null;
                String recorequestText = null;

                //-- this means userId is friend of recommendeeUserId and we should use the free text field
                if ("user-assigned-friend".equals(friendOrNot) ||
                        "system-assigned-friend".equals(friendOrNot)) {
                    if (statement != null) {
                        statement.close();
                    }

                    statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_FRIEND_SELECT_SQL);
                    statement.setString(1,
                        tsNotifRecorequestNeededObjElement.getRecorequestId());
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        recommendeeUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "recorequest_user.initiator_user_id"));
                        recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "recorequest_user.recorequest_free_text"));
                    }

                    statement.close();
                } else if ("user-assigned-other".equals(friendOrNot) ||
                        "system-assigned-other".equals(friendOrNot)) {
                    if (statement != null) {
                        statement.close();
                    }

                    statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_OTHER_SELECT_SQL);
                    statement.setString(1,
                        tsNotifRecorequestNeededObjElement.getRecorequestId());
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        recommendeeUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "recorequest_user.initiator_user_id"));
                        recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "recorequest_user.reco_request_template_sentences"));
                    }

                    statement.close();
                }

                if (statement != null) {
                    statement.close();
                }

                statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);
                statement.setString(1, recommendeeUserUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommendeeUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_fb_id"));
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                statement.setString(1, recommendeeUserFacebookId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommendeeUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.name"));
                    recommendeeUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.picture"));
                }

                statement.close();

                TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
                recommendeeUser.setName(recommendeeUserName);
                recommendeeUser.setPhoto(recommendeeUserPhoto);
                recommendeeUser.setUserId(recommendeeUserUserId);
                tsNotifRecorequestNeededObjElement.setRecommendeeUser(recommendeeUser);
                tsNotifRecorequestNeededObjElement.setRecorequestText(recorequestText);

                recoNotificationBaseList.add(tsNotifRecorequestNeededObjElement);
            }

            if (statement != null) {
                statement.close();
            }
        } finally {
            if (statement != null) {
                statement.close();
            }

            if (resultset != null) {
                resultset.close();
            }
        }
    }

    @Override
    public String showAskForRecommendationFriends(TSDataSource tsDataSource,
        Connection connection, String recoRequestId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TEMPLATE_SENTENCES_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            String recoRequestTemplateSentences = "";

            //only one result
            if (resultset.next()) {
                recoRequestTemplateSentences = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_user.RECO_REQUEST_TEMPLATE_SENTENCES"));
            }

            statement.close();

            return recoRequestTemplateSentences;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showAskForRecommendationFriends " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String neighborhoodId, String cityId,
        String stateName, String[] cuisineTier1IdList, String[] priceIdList,
        String rating, String savedFlag, String favFlag, String dealFlag,
        String chainFlag, String paginationId) throws TasteSyncException {
        //
        String[] cuisineTier2IdArray = getCuisine2FromCuisine1Mapper(connection,
                cuisineTier1IdList);

        RestaurantsSearchResultsVO restaurantsSearchResultsVO = identifyRestaurantsSearchResults(tsDataSource,
                connection, userId, restaurantId, neighborhoodId, cityId,
                stateName, priceIdList, rating, savedFlag, favFlag, dealFlag,
                chainFlag, paginationId, cuisineTier2IdArray);
        List<String> restaurantIdList = restaurantsSearchResultsVO.getRestaurantIdList();

        TSRestaurantsTileSearchObj tsRestaurantsTileSearchObj = null;

        List<TSRestaurantsTileSearchObj> tsRestaurantsTileSearchObjList = new ArrayList<TSRestaurantsTileSearchObj>();

        try {
            for (String restaurantIdElement : restaurantIdList) {
                tsRestaurantsTileSearchObj = getRestaurantTileSearchReslt(connection,
                        restaurantIdElement);

                String cuisineTier2Desc = getCuisineTier2Desc(connection,
                        restaurantIdElement, cuisineTier2IdArray);

                if (cuisineTier2Desc != null) {
                    tsRestaurantsTileSearchObj.setCuisineTier2Name(cuisineTier2Desc);
                }

                tsRestaurantsTileSearchObjList.add(tsRestaurantsTileSearchObj);
            }
        } catch (SQLException e) {
            e.printStackTrace();

            throw new TasteSyncException(
                "Error while creating showListOfRestaurantsSearchResults " +
                e.getMessage());
        } finally {
        }

        TSRestaurantsTileSearchExtendedInfoObj tsRestaurantsTileSearchExtendedInfoObj =
            new TSRestaurantsTileSearchExtendedInfoObj();
        tsRestaurantsTileSearchExtendedInfoObj.setTsRestaurantsTileSearchObjList(tsRestaurantsTileSearchObjList);
        tsRestaurantsTileSearchExtendedInfoObj.setMaxPaginationId(restaurantsSearchResultsVO.getMaxPaginationId());

        return tsRestaurantsTileSearchExtendedInfoObj;
    }

    @Override
    public TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResultsBasedOnRecoId(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String paginationId) throws TasteSyncException {
        //get different parameters based on recorequest id
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_USER_LOCATION_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            String userIdFrmDb = null;
            String recoRequestLocationCityId = null;
            String recoRequestLocationNeighborhoodId = null;

            //only one result
            if (resultset.next()) {
                userIdFrmDb = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_user.initiator_user_id"));
                recoRequestLocationCityId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_location.city_id"));

                recoRequestLocationNeighborhoodId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_location.neighbourhood_id"));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_CUISINE_TIER2_FROM_CUISINE_TIER1_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> cuisineTier2IdList = new ArrayList<String>();

            while (resultset.next()) {
                cuisineTier2IdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "cuisine_tier_mapper.tier2_cuisine_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_CUISINE_TIER2_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            String cuisineTier2Id = null;

            while (resultset.next()) {
                cuisineTier2Id = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_cuisine_tier2.cuisine_tier2_id"));

                if (!cuisineTier2IdList.contains(cuisineTier2Id)) {
                    cuisineTier2IdList.add(cuisineTier2Id);
                }
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_PRICE_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> priceIdList = new ArrayList<String>();

            while (resultset.next()) {
                priceIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("recorequest_price.price_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_THEME_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> themeIdList = new ArrayList<String>();

            while (resultset.next()) {
                themeIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("recorequest_theme.theme_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_WHOAREYOUWITH_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> whoareyouwithIdList = new ArrayList<String>();

            while (resultset.next()) {
                whoareyouwithIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_whoareyouwith.whoareyouwith_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TYPEOFREST_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> typeOfRestaurantIdList = new ArrayList<String>();

            while (resultset.next()) {
                typeOfRestaurantIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "recorequest_typeofrest.typeofrest_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_OCCASION_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            ArrayList<String> occasionIdList = new ArrayList<String>();

            while (resultset.next()) {
                occasionIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("recorequest_occasion.occasion_id")));
            }

            statement.close();

            String[] priceIdArray = priceIdList.isEmpty() ? null
                                                          : priceIdList.toArray(new String[priceIdList.size()]);

            String[] cuisineTier2IdArray = cuisineTier2IdList.isEmpty() ? null
                                                                        : cuisineTier2IdList.toArray(new String[cuisineTier2IdList.size()]);

            String[] themeIdArray = themeIdList.isEmpty() ? null
                                                          : themeIdList.toArray(new String[themeIdList.size()]);

            String[] whoareyouwithIdArray = whoareyouwithIdList.isEmpty()
                ? null
                : whoareyouwithIdList.toArray(new String[whoareyouwithIdList.size()]);

            String[] typeOfRestaurantIdArray = typeOfRestaurantIdList.isEmpty()
                ? null
                : typeOfRestaurantIdList.toArray(new String[typeOfRestaurantIdList.size()]);

            String[] occasionIdArray = occasionIdList.isEmpty() ? null
                                                                : occasionIdList.toArray(new String[occasionIdList.size()]);

            RestaurantsSearchResultsVO restaurantsSearchResultsVO = identifyRestaurantsSearchResults(tsDataSource,
                    connection, userIdFrmDb, recoRequestLocationNeighborhoodId,
                    recoRequestLocationCityId, priceIdArray, paginationId,
                    cuisineTier2IdArray, themeIdArray, whoareyouwithIdArray,
                    typeOfRestaurantIdArray, occasionIdArray);
            List<String> restaurantIdList = restaurantsSearchResultsVO.getRestaurantIdList();
            TSRestaurantsTileSearchObj tsRestaurantsTileSearchObj = null;

            List<TSRestaurantsTileSearchObj> tsRestaurantsTileSearchObjList = new ArrayList<TSRestaurantsTileSearchObj>();

            for (String restaurantId : restaurantIdList) {
                tsRestaurantsTileSearchObj = getRestaurantTileSearchReslt(connection,
                        restaurantId);

                String cuisineTier2Desc = getCuisineTier2Desc(connection,
                        restaurantId, cuisineTier2IdArray);

                if (cuisineTier2Desc != null) {
                    tsRestaurantsTileSearchObj.setCuisineTier2Name(cuisineTier2Desc);
                }

                tsRestaurantsTileSearchObjList.add(tsRestaurantsTileSearchObj);
            }

            TSRestaurantsTileSearchExtendedInfoObj tsRestaurantsTileSearchExtendedInfoObj =
                new TSRestaurantsTileSearchExtendedInfoObj();
            tsRestaurantsTileSearchExtendedInfoObj.setTsRestaurantsTileSearchObjList(tsRestaurantsTileSearchObjList);
            tsRestaurantsTileSearchExtendedInfoObj.setMaxPaginationId(restaurantsSearchResultsVO.getMaxPaginationId());

            return tsRestaurantsTileSearchExtendedInfoObj;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException(
                "Error while showListOfRestaurantsSearchResultsBasedOnRecoId " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSRestaurantBasicObj> showRecommendationDidYouLike(
        TSDataSource tsDataSource, Connection connection, String recorequestId)
        throws TasteSyncException {
        List<TSRestaurantBasicObj> tsRestaurantObjList = new ArrayList<TSRestaurantBasicObj>();
        PreparedStatement statement = null;
        PreparedStatement statementInner = null;
        ResultSet resultset = null;

        ResultSet resultsetInner = null;

        String recommendedrestaurantsRestaurantId;
        String recommendedrestaurantsRestaurantName;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_RESTAURANT_SELECT_SQL);
            statement.setString(1, recorequestId);
            resultset = statement.executeQuery();
            statementInner = connection.prepareStatement(AskReplyQueries.RESTAURANT_NAME_SELECT_SQL);

            while (resultset.next()) {
                recommendedrestaurantsRestaurantId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_id"));
                statementInner.setString(1, recommendedrestaurantsRestaurantId);
                resultsetInner = statementInner.executeQuery();
                recommendedrestaurantsRestaurantName = null;

                if (resultsetInner.next()) {
                    recommendedrestaurantsRestaurantName = CommonFunctionsUtil.getModifiedValueString(resultsetInner.getString(
                                "restaurant.restaurant_name"));
                }

                TSRestaurantBasicObj tsRestaurantBasicObj = new TSRestaurantBasicObj();
                tsRestaurantBasicObj.setRestaurantId(recommendedrestaurantsRestaurantId);
                tsRestaurantBasicObj.setRestaurantName(recommendedrestaurantsRestaurantName);
                tsRestaurantObjList.add(tsRestaurantBasicObj);
            }

            statementInner.close();
            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREPLY_DIDYOULIKE_NOTIF_UPDATE_SQL);
            statement.setString(1, recorequestId);
            statement.executeUpdate();
            statement.close();
            tsDataSource.commit();

            return tsRestaurantObjList;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showRecommendationDidYouLike " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
            tsDataSource.closeConnection(statementInner, resultsetInner);
        }
    }

    @Override
    public TSSenderUserObj showRecommendationMessage(
        TSDataSource tsDataSource, Connection connection, String messageId,
        String recipientUserId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_SELECT_SQL);
            statement.setString(1, recipientUserId);
            statement.setString(2, messageId);

            resultset = statement.executeQuery();

            String senderUserId = null;
            String message = null;
            String senderUserFacebookId = null;
            String senderUserName = null;
            String senderUserPhoto = null;
            String senderUserFolloweeFlag = "0";

            if (resultset.next()) {
                senderUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_message.sender_id"));
                message = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_message.content"));

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                statement.setString(1, senderUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    senderUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_fb_id"));
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                statement.setString(1, senderUserFacebookId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    senderUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.name"));
                    senderUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "facebook_user_data.picture"));
                }

                statement.close();

                statement = connection.prepareStatement(AskReplyQueries.USER_FOLLOW_DATA_SELECT);

                statement.setString(1, senderUserId);
                statement.setString(2, recipientUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    senderUserFolloweeFlag = "1";
                }

                statement.close();
            }

            statement.close();

            String unreadCounter = getUnreadCounterNotificationsAll(connection,
                    recipientUserId);

            statement = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_UPDATE_SQL);
            statement.setString(1, messageId);
            statement.setString(2, recipientUserId);
            statement.executeUpdate();
            statement.close();
            tsDataSource.commit();

            TSSenderUserObj tsSenderUserObj = new TSSenderUserObj();

            TSUserProfileBasicObj senderUser = new TSUserProfileBasicObj();
            senderUser.setName(senderUserName);
            senderUser.setPhoto(senderUserPhoto);
            senderUser.setUserId(senderUserId);

            tsSenderUserObj.setSenderUser(senderUser);
            tsSenderUserObj.setMessage(message);
            tsSenderUserObj.setSenderUserFolloweeFlag(senderUserFolloweeFlag);
            tsSenderUserObj.setUnreadCounter(unreadCounter);

            return tsSenderUserObj;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showRecommendationMessage " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRecommendationsFollowupObj showRecommendationsFollowup(
        TSDataSource tsDataSource, Connection connection, String userId,
        String questionId) throws TasteSyncException {
        TSRecommendationsFollowupObj tsRecommendationsFollowupObj = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(TSDBCommonQueries.QUESTION_DETAILS_RESTAURANT_SELECT_SQL);
            statement.setString(1, questionId);
            resultset = statement.executeQuery();

            String questionUserId = null;
            String questionRestaurantId = null;
            String questionText = null;
            String questionRestaurantRestaurantName = null;
            String questionUserFacebookId = null;
            String questionUserName = null;
            String questionUserPhoto = null;
            String questionUserFolloweeFlag = "0";

            if (resultset.next()) {
                questionUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_user.initiator_user_id"));
                questionRestaurantId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_user.restaurant_id"));
                questionText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_user.question_text"));

                statement.close();

                if (questionRestaurantId != null) {
                    statement = connection.prepareStatement(AskReplyQueries.RESTAURANT_NAME_SELECT_SQL);
                    statement.setString(1, questionRestaurantId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        questionRestaurantRestaurantName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "restaurant.restaurant_name"));
                    }

                    statement.close();
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                statement.setString(1, questionUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    questionUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_fb_id"));

                    statement.close();

                    statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    statement.setString(1, questionUserFacebookId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        questionUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.name"));
                        questionUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.picture"));
                    }

                    statement.close();
                }

                statement.close();

                statement = connection.prepareStatement(AskReplyQueries.USER_FOLLOW_DATA_SELECT);

                statement.setString(1, questionUserId);
                statement.setString(2, userId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    questionUserFolloweeFlag = "1";
                }

                statement.close();
            }

            statement.close();

            String unreadCounter = getUnreadCounterNotificationsAll(connection,
                    userId);

            statement = connection.prepareStatement(AskReplyQueries.RESTAURANT_QUESTION_TS_ASSIGNED_UPDATE_SQL);
            statement.setString(1, questionId);
            statement.setString(2, userId);

            statement.executeUpdate();
            statement.close();
            tsDataSource.commit();

            TSUserProfileBasicObj questionUser = new TSUserProfileBasicObj();
            questionUser.setName(questionUserName);
            questionUser.setPhoto(questionUserPhoto);
            questionUser.setUserId(questionUserId);

            TSRestaurantObj questionRestaurant = new TSRestaurantObj();
            questionRestaurant.setRestaurantName(questionRestaurantRestaurantName);
            questionRestaurant.setRestaurantId(questionRestaurantId);

            tsRecommendationsFollowupObj = new TSRecommendationsFollowupObj();
            tsRecommendationsFollowupObj.setQuestionUser(questionUser);
            tsRecommendationsFollowupObj.setQuestionRestaurant(questionRestaurant);
            tsRecommendationsFollowupObj.setQuestionUserFolloweeFlag(questionUserFolloweeFlag);
            tsRecommendationsFollowupObj.setQuestionText(questionText);
            tsRecommendationsFollowupObj.setUnreadCounter(unreadCounter);

            return tsRecommendationsFollowupObj;
        } catch (SQLException e) {
            e.printStackTrace();

            throw new TasteSyncException(
                "Error while showRecommendationsFollowup " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRecommendationsForYouObj showRecommendationsForYou(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId) throws TasteSyncException {
        TSRecommendationsForYouObj tsRecommendationsForYouObj = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TEMPLATE_SENTENCES_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            String recorequestText = "";

            //only one result
            if (resultset.next()) {
                recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_user.RECO_REQUEST_TEMPLATE_SENTENCES"));
            }

            statement.close();

            List<String> replyIdList = new ArrayList<String>();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_RECO_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            while (resultset.next()) {
                replyIdList.add(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("recorequest_reply_user.reply_id")));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_RECO_REST_SELECT_SQL);
            statement.setString(1, recoRequestId);
            resultset = statement.executeQuery();

            String restaurantIdValue = null;
            String recommenderUserId = null;
            String replyText = null;
            List<RecommendationsForYouVO> recommendationsForYouVOList = new ArrayList<RecommendationsForYouVO>();

            while (resultset.next()) {
                restaurantIdValue = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_id"));

                recommenderUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recommender_user_id"));

                replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reply_text"));

                RecommendationsForYouVO recommendationsForYouVO = new RecommendationsForYouVO(restaurantIdValue,
                        recommenderUserId, replyText);

                recommendationsForYouVOList.add(recommendationsForYouVO);
            }

            statement.close();

            List<String> restaurantIdList = new ArrayList<String>();

            for (RecommendationsForYouVO recommendationsForYouVO : recommendationsForYouVOList) {
                if (!restaurantIdList.contains(
                            recommendationsForYouVO.getRestaurantId())) {
                    restaurantIdList.add(recommendationsForYouVO.getRestaurantId());
                }
            }

            List<String> recommenderUserIdList = null;
            List<String> replyTextList = null;

            List<TSRestaurantsForYouObj> restaurantsForYouObjList = new ArrayList<TSRestaurantsForYouObj>();

            //check for duplicates
            for (String restaurantId : restaurantIdList) {
                recommenderUserIdList = new ArrayList<String>();
                replyTextList = new ArrayList<String>();

                for (RecommendationsForYouVO recommendationsForYouVO : recommendationsForYouVOList) {
                    if (restaurantId.equals(
                                recommendationsForYouVO.getRestaurantId())) {
                        recommenderUserIdList.add(recommendationsForYouVO.getRecommenderUserId());
                        replyTextList.add(recommendationsForYouVO.getReplyText());
                    }
                }

                List<TSRecommendationsObj> recommendationsForYouList = getRecommendationsForRestaurantFromUsersList(connection,
                        userId, recommenderUserIdList, replyTextList);

                statement = connection.prepareStatement(TSDBCommonQueries.CITY_RESTAURANT_SELECT_SQL);
                statement.setString(1, restaurantId);
                resultset = statement.executeQuery();

                String restaurantName = null;
                String price = null;

                String restaurantCity = null;
                String restaurantLat = null;
                String restaurantLong = null;
                String restaurantDealFlag = null;
                String restaurantRating = null;

                while (resultset.next()) {
                    restaurantName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.restaurant_name"));
                    price = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.price_range"));

                    restaurantName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.restaurant_name"));

                    restaurantCity = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "cities.city"));

                    restaurantLat = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.restaurant_lat"));
                    restaurantLong = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.restaurant_lon"));

                    restaurantDealFlag = null;
                    restaurantRating = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "restaurant.factual_rating"));
                }

                statement.close();

                String cuisineTier2Name = null;
                statement = connection.prepareStatement(TSDBCommonQueries.CUISINE_DESC_ONE_RESTAURANT_SELECT_SQL);
                statement.setString(1, restaurantId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    cuisineTier2Name = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "cuisine_desc"));
                }

                statement.close();

                TSRestaurantsForYouObj tsRestaurantsForYouObj = new TSRestaurantsForYouObj();
                tsRestaurantsForYouObj.setRestaurantId(restaurantId);
                tsRestaurantsForYouObj.setRestaurantName(restaurantName);
                tsRestaurantsForYouObj.setPrice(price);
                tsRestaurantsForYouObj.setRestaurantName(restaurantName);
                tsRestaurantsForYouObj.setRestaurantCity(restaurantCity);
                tsRestaurantsForYouObj.setRestaurantLat(restaurantLat);
                tsRestaurantsForYouObj.setRestaurantLong(restaurantLong);
                tsRestaurantsForYouObj.setRestaurantDealFlag(restaurantDealFlag);
                tsRestaurantsForYouObj.setRestaurantRating(restaurantRating);
                tsRestaurantsForYouObj.setRecommendationsForYouList(recommendationsForYouList);
                tsRestaurantsForYouObj.setCuisineTier2Name(cuisineTier2Name);
                restaurantsForYouObjList.add(tsRestaurantsForYouObj);
            }

            if (statement != null) {
                statement.close();
            }

            String unreadCounter = getUnreadCounterNotificationsAll(connection,
                    userId);

            tsRecommendationsForYouObj = new TSRecommendationsForYouObj();
            tsRecommendationsForYouObj.setRecorequestText(recorequestText);
            tsRecommendationsForYouObj.setRestaurantsForYouObjList(restaurantsForYouObjList);
            tsRecommendationsForYouObj.setUnreadCounter(unreadCounter);
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_UPDATE_SQL);

            for (String replyId : replyIdList) {
                statement.setString(1, replyId);
                statement.addBatch();
            }

            statement.executeBatch();
            statement.close();
            tsDataSource.commit();

            return tsRecommendationsForYouObj;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showRecommendationsForYou " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public List<TSRecoNotificationBaseObj> showRecommendationsList(
        TSDataSource tsDataSource, Connection connection, String userId,
        String paginationId) throws TasteSyncException {
        //Indexing for ORDER BY/Select parameters like user id etc!!
        List<TSRecoNotificationBaseObj> recoNotificationBaseList = new ArrayList<TSRecoNotificationBaseObj>();

        List<TSRecoNotificationBaseObj> recoNotificationBaseOverallList = new ArrayList<TSRecoNotificationBaseObj>();

        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(AskReplyQueries.COUNT_NOTIFICATIONS_ALL_SELECT_SQL);

            statement.setString(1, userId);

            resultset = statement.executeQuery();

            int rowCount = 0;

            if (resultset.next()) {
                rowCount = resultset.getInt(1);
            }

            statement.close();

            int maxPaginationId = (rowCount / TSConstants.PAGINATION_GAP) + 1;

            statement = connection.prepareStatement(AskReplyQueries.NOTIFICATIONS_ALL_SELECT_SQL);
            statement.setString(1, userId);

            int pagintionIndex = (Integer.valueOf(paginationId) - 1) * TSConstants.PAGINATION_GAP;

            if (pagintionIndex < 0) {
                pagintionIndex = 0;
            }

            statement.setInt(2, pagintionIndex); //TODO calculate based on pagination logic!!
            statement.setInt(3, TSConstants.PAGINATION_GAP);

            resultset = statement.executeQuery();

            TSRecoNotificationBaseObj tsRecoNotificationBaseObj = null;
            String unreadCounter;

            while (resultset.next()) {
                tsRecoNotificationBaseObj = new TSRecoNotificationBaseObj();
                tsRecoNotificationBaseObj.setDatetimeBase(resultset.getTimestamp(
                        "notifications_all.datetime"));

                tsRecoNotificationBaseObj.setIdBase(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString("notifications_all.linked_id")));

                tsRecoNotificationBaseObj.setRecoNotificationType(CommonFunctionsUtil.getModifiedValueString(
                        resultset.getString(
                            "notifications_all.notification_type")));

                tsRecoNotificationBaseObj.setMaxPaginationId(String.valueOf(
                        maxPaginationId));
                unreadCounter = getUnreadCounterNotificationsAll(connection,
                        userId);
                tsRecoNotificationBaseObj.setUnreadCounter(unreadCounter);
                recoNotificationBaseOverallList.add(tsRecoNotificationBaseObj);
            }

            //if no result, then check pagination is and see if it is top or last? 
            statement.close();

            //            Collections.sort(recoNotificationBaseOverallList,
            //                new Comparator<TSRecoNotificationBaseObj>() {
            //                    public int compare(TSRecoNotificationBaseObj o1,
            //                        TSRecoNotificationBaseObj o2) {
            //                        return o1.getDatetimeBase()
            //                                 .compareTo(o2.getDatetimeBase());
            //                    }
            //                });
            for (TSRecoNotificationBaseObj tsRecoNotificationBaseObjElement : recoNotificationBaseOverallList) {
                if (TSConstants.RECONOTIFICATION_TYPE_NEEDED.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifRecorequestNeededObjElement(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                } else if (TSConstants.RECONOTIFICATION_TYPE_ANSWER.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifRecorequestAnswerObj(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                } else if (TSConstants.RECONOTIFICATION_TYPE_FOLLOWUP.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifFollowupQuestionObj(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                } else if (TSConstants.RECONOTIFICATION_TYPE_MESSAGE.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifMessageForYouObj(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                } else if (TSConstants.RECONOTIFICATION_TYPE_LIKE.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifRecoLikeObj(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                } else if (TSConstants.RECONOTIFICATION_TYPE_DID_LIKE.equals(
                            tsRecoNotificationBaseObjElement.getRecoNotificationType())) {
                    processTSNotifDidYouLikeObj(connection,
                        tsRecoNotificationBaseObjElement,
                        recoNotificationBaseList, userId);
                }
            }

            return recoNotificationBaseList;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new TasteSyncException("Error while showRecommendationsList " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRecoRequestObj showRecommendationsRequest(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recorequestId) throws TasteSyncException {
        TSRecoRequestObj tsRecoRequestObj = null;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_TS_ASSIGNED_SELECT_SQL);
            statement.setString(1, recorequestId);
            statement.setString(2, userId);
            resultset = statement.executeQuery();

            String friendOrNot = null;

            //only one result
            if (resultset.next()) {
                friendOrNot = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_ts_assigned.ASSIGNED_USERTYPE"));
            } else {
                System.out.println("invalid data case with recorequestId=" +
                    recorequestId + " and userId=" + userId);

                // invalid data case
                return null;
            }

            statement.close();
            tsDataSource.begin();

            //TODO first do select count(*). If needed, add data as fav or delete
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TS_ASSIGNED_UPDATE_SQL);
            statement.setString(1, recorequestId);
            statement.setString(2, userId);
            statement.executeUpdate();

            statement.close();

            String recommendeeUserFacebookId = null;
            String recommendeeUserName = null;
            String recommendeeUserPhoto = null;
            String recommendeeUserUserId = null;
            String recorequestText = null;
            String recommendeeUserFolloweeFlag = null;

            //-- this means userId is friend of recommendeeUserId and we should use the free text field
            if ("user-assigned-friend".equals(friendOrNot) ||
                    "system-assigned-friend".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_FRIEND_SELECT_SQL);
                statement.setString(1, recorequestId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommendeeUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.initiator_user_id"));
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.recorequest_free_text"));
                }

                statement.close();
            } else if ("user-assigned-other".equals(friendOrNot) ||
                    "system-assigned-other".equals(friendOrNot)) {
                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_OTHER_SELECT_SQL);
                statement.setString(1, recorequestId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommendeeUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.initiator_user_id"));
                    recorequestText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_user.reco_request_template_sentences"));
                }

                statement.close();
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);
            statement.setString(1, recommendeeUserUserId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                recommendeeUserFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users.user_fb_id"));
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
            statement.setString(1, recommendeeUserFacebookId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                recommendeeUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "facebook_user_data.name"));
                recommendeeUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "facebook_user_data.picture"));
            }

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.COUNT_RECOREQUEST_USER_FOLLOWEEFLAG_SELECT_SQL);
            statement.setString(1, recommendeeUserUserId);
            statement.setString(2, userId);

            resultset = statement.executeQuery();
            recommendeeUserFolloweeFlag = "0"; // default

            int rowCount = 0;

            if (resultset.next()) {
                rowCount = resultset.getInt(1);
            }

            if (rowCount > 0) {
                recommendeeUserFolloweeFlag = "1";
            }

            statement.close();

            String unreadCounter = getUnreadCounterNotificationsAll(connection,
                    userId);
            TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
            recommendeeUser.setName(recommendeeUserName);
            recommendeeUser.setPhoto(recommendeeUserPhoto);
            recommendeeUser.setUserId(recommendeeUserUserId);

            tsRecoRequestObj = new TSRecoRequestObj();
            tsRecoRequestObj.setRecommendeeUser(recommendeeUser);
            tsRecoRequestObj.setRecorequestText(recorequestText);
            tsRecoRequestObj.setRecommendeeUserFolloweeFlag(recommendeeUserFolloweeFlag);
            tsRecoRequestObj.setRecommendeeUser(recommendeeUser);
            tsRecoRequestObj.setUnreadCounter(unreadCounter);
            tsDataSource.commit();
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showRecommendationsRequest " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }

        return tsRecoRequestObj;
    }

    @Override
    public TSRecommendeeUserObj showRecommendationsShowLikes(
        TSDataSource tsDataSource, Connection connection, String recoLikeId,
        String recommenderUserId) throws TasteSyncException {
        TSRecommendeeUserObj tsRecommendeeUserObj;
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(AskReplyQueries.RECO_LIKE_SELECT_SQL);
            statement.setString(1, recoLikeId);
            resultset = statement.executeQuery();

            String replyId = null;
            String recommendeeUserId = null;
            String replyText = null;
            String recommendeeFacebookId;
            String recommendeeUserName = null;
            String recommendeeUserPhoto = null;

            if (resultset.next()) {
                replyId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reco_like.reply_id"));

                recommendeeUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "reco_like.like_user_id"));

                statement.close();

                statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_SELECT_SQL);
                statement.setString(1, replyId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    replyText = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "recorequest_reply_user.reply_text"));
                }

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);

                statement.setString(1, recommendeeUserId);
                resultset = statement.executeQuery();

                if (resultset.next()) {
                    recommendeeFacebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_fb_id"));

                    statement.close();

                    statement = connection.prepareStatement(TSDBCommonQueries.FACEBOOK_USER_DATA_SELECT_SQL);
                    statement.setString(1, recommendeeFacebookId);
                    resultset = statement.executeQuery();

                    if (resultset.next()) {
                        recommendeeUserName = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.name"));
                        recommendeeUserPhoto = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                    "facebook_user_data.picture"));
                    }

                    statement.close();
                }
            }

            String unreadCounter = getUnreadCounterNotificationsAll(connection,
                    recommenderUserId);
            statement = connection.prepareStatement(AskReplyQueries.RECO_LIKE_UPDATE_SQL);
            statement.setString(1, recoLikeId);
            statement.executeUpdate();
            statement.close();
            tsDataSource.commit();

            TSUserProfileBasicObj recommendeeUser = new TSUserProfileBasicObj();
            recommendeeUser.setName(recommendeeUserName);
            recommendeeUser.setPhoto(recommendeeUserPhoto);
            recommendeeUser.setUserId(recommendeeUserId);

            tsRecommendeeUserObj = new TSRecommendeeUserObj();
            tsRecommendeeUserObj.setRecommendeeUser(recommendeeUser);
            tsRecommendeeUserObj.setReplyId(replyId);
            tsRecommendeeUserObj.setReplyText(replyText);
            tsRecommendeeUserObj.setAddedPoints("4");

            tsRecommendeeUserObj.setUnreadCounter(unreadCounter);

            return tsRecommendeeUserObj;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while showRecommendationsShowLikes " + e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public TSRecoRequestNonAssignedObj submitAskForRecommendationFriends(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String recoRequestFriendText,
        String[] friendsFacebookIdList, String postRecoRequestOnFacebook)
        throws TasteSyncException {
        TSRecoRequestNonAssignedObj tsRecoRequestNonAssignedObj = new TSRecoRequestNonAssignedObj();
        tsRecoRequestNonAssignedObj.setRecoRequestId(recoRequestId);

        //TODO Incomplete
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            List<String> nonassignedFacebookIdList = new ArrayList<String>();

            for (String friendsFacebookId : friendsFacebookIdList) {
                statement = connection.prepareStatement(AskReplyQueries.CHECK_FB_USER_AS_TS_USER_SELECT_SQL);
                statement.setString(1, friendsFacebookId);
                resultset = statement.executeQuery();

                //only one result
                //-- Pick only those friends' facebook ID who are TS users
                if (resultset.next()) {
                    statement.close();

                    statement = connection.prepareStatement(AskReplyQueries.USER_ID_FRM_FB_ID_SELECT_SQL);
                    statement.setString(1, friendsFacebookId);
                    resultset = statement.executeQuery();

                    String friendId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "users.user_id"));

                    statement.close();

                    statement = connection.prepareStatement(TSDBCommonQueries.FRIEND_TRUSTED_FLAG_SELECT_SQL);
                    statement.setString(1, userId);
                    statement.setString(2, friendId);

                    resultset = statement.executeQuery();

                    String friendTrustedFlag = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                                "user_friend_tastesync.FRIEND_TRUSTED_FLAG"));

                    statement.close();

                    statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TS_ASSIGNED_INSERT_SQL);
                    statement.setString(1, "N");
                    statement.setString(2, friendTrustedFlag);
                    statement.setString(3, "user-assigned-friend");
                    statement.setString(4, friendId);
                    statement.setString(5, "Y");
                    statement.setString(6, recoRequestId);
                    statement.setInt(7, 1);
                    statement.executeUpdate();

                    statement.close();
                } else {
                    nonassignedFacebookIdList.add(friendsFacebookId);
                    statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_NON_TS_ASSIGNED_INSERT_SQL);
                    statement.setString(1, recoRequestId);
                    statement.setString(2, friendsFacebookId);
                    statement.setString(3, "user-assigned-friend");
                    statement.setString(4, "N");
                    statement.setString(5, "N");
                    statement.setString(6, "N");
                    statement.executeUpdate();
                    statement.close();
                }
            }

            tsRecoRequestNonAssignedObj.setNonassignedFacebookIdList(nonassignedFacebookIdList);
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_USER_UPDATE_SQL);
            statement.setString(1, recoRequestFriendText);
            statement.setString(2, recoRequestId);
            statement.setString(3, userId);
            statement.executeUpdate();

            statement.close();

            statement = connection.prepareStatement(TSDBCommonQueries.FB_ID_FRM_USER_ID_SELECT_SQL);
            statement.setString(1, userId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                String facebookId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "users.user_fb_id"));

                statement.close();

                statement = connection.prepareStatement(TSDBCommonQueries.HISTORICAL_USER_SHARED_DATA_INSERT_SQL);

                //datetime userid random number
                statement.setString(1, facebookId);

                List<String> inputKeyStr = new ArrayList<String>();
                inputKeyStr.add(userId);
                statement.setString(2,
                    CommonFunctionsUtil.generateUniqueKey(inputKeyStr));
                statement.setTimestamp(3,
                    CommonFunctionsUtil.getCurrentDateTimestamp());
                statement.setString(4, recoRequestFriendText);
                statement.setString(5, "facebook_post");
                statement.setString(6, userId);

                statement.setString(1, userId);
                statement.executeUpdate();

                statement.close();
            } else {
                System.out.println("FB ser Id does not exist for user id=" +
                    userId);
            }

            statement = connection.prepareStatement(AskReplyQueries.USER_RECO_SUPPPLY_TIER_INSERT_SQL);
            statement.setString(1, userId);
            statement.executeUpdate();

            statement.close();

            tsDataSource.commit();

            return tsRecoRequestNonAssignedObj;
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while submitAskForRecommendationFriends " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public String submitAskForRecommendationSearch(TSDataSource tsDataSource,
        Connection connection, String userId, String[] cuisineTier1IdList,
        String[] cuisineTier2IdList, String[] priceIdList,
        String[] themeIdList, String[] whoareyouwithIdList,
        String[] typeOfRestaurantIdList, String[] occasionIdList,
        String neighborhoodId, String cityId, String stateName)
        throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            StringBuffer mergedTextBuffer = new StringBuffer();

            //sort lists
            if (cuisineTier1IdList != null) {
                Arrays.sort(cuisineTier1IdList);
            }

            if (cuisineTier2IdList != null) {
                Arrays.sort(cuisineTier2IdList);
            }

            if (priceIdList != null) {
                Arrays.sort(priceIdList);
            }

            if (themeIdList != null) {
                Arrays.sort(themeIdList);
            }

            if (whoareyouwithIdList != null) {
                Arrays.sort(whoareyouwithIdList);
            }

            if (typeOfRestaurantIdList != null) {
                Arrays.sort(typeOfRestaurantIdList);
            }

            if (occasionIdList != null) {
                Arrays.sort(occasionIdList);
            }

            for (String cuisineId : cuisineTier1IdList) {
                mergedTextBuffer.append("cuisine tier1 s:");
                mergedTextBuffer.append(cuisineId).append("");
            }

            if (cuisineTier2IdList != null) {
                for (String cuisineId : cuisineTier2IdList) {
                    mergedTextBuffer.append("cuisine tier2 s:");
                    mergedTextBuffer.append(cuisineId).append("");
                }
            }

            if (priceIdList != null) {
                for (String priceId : priceIdList) {
                    mergedTextBuffer.append("priceId s:");
                    mergedTextBuffer.append(priceId).append("");
                }
            }

            if (themeIdList != null) {
                for (String themeId : themeIdList) {
                    mergedTextBuffer.append("themeId s:");
                    mergedTextBuffer.append(themeId).append("");
                }
            }

            if (whoareyouwithIdList != null) {
                for (String whoareyouwithId : whoareyouwithIdList) {
                    mergedTextBuffer.append("whoareyouwithId s:");
                    mergedTextBuffer.append(whoareyouwithId).append("");
                }
            }

            if (typeOfRestaurantIdList != null) {
                for (String typeOfRestaurantId : typeOfRestaurantIdList) {
                    mergedTextBuffer.append("typeOfRestaurantId s:");
                    mergedTextBuffer.append(typeOfRestaurantId).append("");
                }
            }

            if (occasionIdList != null) {
                for (String occasionId : occasionIdList) {
                    mergedTextBuffer.append("occasionId s:");
                    mergedTextBuffer.append(occasionId).append("");
                }
            }

            if (cityId != null) {
                mergedTextBuffer.append("cityId s:");
                mergedTextBuffer.append(cityId).append("");

                if (neighborhoodId != null) {
                    mergedTextBuffer.append("neighborhoodId s:");
                    mergedTextBuffer.append(neighborhoodId).append("");
                }
            }

            String recoRequestId = userId +
                CommonFunctionsUtil.generateUniqueKey();

            String templateString = createRecoRequestTemplateText(connection,
                    cuisineTier1IdList, cuisineTier2IdList, priceIdList,
                    themeIdList, whoareyouwithIdList, typeOfRestaurantIdList,
                    occasionIdList, neighborhoodId, cityId, stateName);
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_USER_INSERT_SQL);

            statement.setString(1, recoRequestId);
            statement.setString(2, userId);
            statement.setTimestamp(3,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(4, TSConstants.EMPTY_STRING);
            statement.setString(5, mergedTextBuffer.toString());
            statement.setString(6, templateString);
            statement.setInt(7, 2);

            statement.executeUpdate();

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_CUISINE_TIER1_INSERT_SQL);

            for (String cuisineId : cuisineTier1IdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, cuisineId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_CUISINE_TIER2_INSERT_SQL);

            for (String cuisineId : cuisineTier2IdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, cuisineId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_PRICE_INSERT_SQL);

            for (String priceId : priceIdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, priceId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_OCCASION_INSERT_SQL);

            for (String occasionId : occasionIdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, occasionId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_THEME_INSERT_SQL);

            for (String themeId : themeIdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, themeId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_WHOAREYOUWITH_INSERT_SQL);

            for (String whoareyouwithId : whoareyouwithIdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, whoareyouwithId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_TYPEOFREST_INSERT_SQL);

            for (String typeOfRestaurantId : typeOfRestaurantIdList) {
                statement.setString(1, recoRequestId);
                statement.setString(2, typeOfRestaurantId);
                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_LOCATION_INSERT_SQL);

            if (cityId != null) {
                statement.setString(1, cityId);
                statement.setString(2, neighborhoodId);
                statement.setString(3, recoRequestId);
                statement.executeUpdate();
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.USER_RECO_SUPPPLY_TIER_INSERT_SQL);
            statement.setString(1, userId);
            statement.executeUpdate();

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.USER_RECO_DEMAND_TIER_INSERT_SQL);
            statement.setString(1, userId);
            statement.executeUpdate();

            statement.close();

            tsDataSource.commit();

            return recoRequestId;
        } catch (MySQLIntegrityConstraintViolationException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while submitAskForRecommendationSearch " +
                e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while submitAskForRecommendationSearch " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void submitRecommendationDidYouLikeLikes(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String likeFlag) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            if ("1".equals(likeFlag)) {
                statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_FAV_INSERT_SQL);
                statement.setString(1, restaurantId);
                statement.setString(2, userId);
                statement.setInt(3, 3);
                statement.setInt(4, 1);
                statement.executeUpdate();
                statement.close();
            } else if ("0".equals(likeFlag)) {
                statement = connection.prepareStatement(TSDBCommonQueries.RESTAURANT_FAV_DELETE_SQL);
                statement.setString(1, restaurantId);
                statement.setString(2, userId);
                statement.executeUpdate();
                statement.close();
            } else {
                throw new TasteSyncException("Unknown value for likeFlag as " +
                    likeFlag);
            }

            statement = connection.prepareStatement(TSDBCommonQueries.REPLYID_RECOMMENDER_USER_SELECT_SQL);
            statement.setString(1, userId);
            statement.setString(2, restaurantId);
            resultset = statement.executeQuery();

            List<String> recommenderUserIdList = new ArrayList<String>();
            List<String> replyIdList = new ArrayList<String>();
            String recommenderUserIdValue;
            String replyIdValue;

            while (resultset.next()) {
                recommenderUserIdValue = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_restaurant_reco.RECOMMENDER_USER_ID"));
                replyIdValue = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "user_restaurant_reco.reply_id"));

                if (!recommenderUserIdList.contains(recommenderUserIdValue)) {
                    recommenderUserIdList.add(recommenderUserIdValue);
                }

                if (!replyIdList.contains(replyIdValue)) {
                    replyIdList.add(replyIdValue);
                }
            }

            statement.close();

            if ("1".equals(likeFlag)) {
                for (String recommenderUserId : recommenderUserIdList) {
                    statement = connection.prepareStatement(AskReplyQueries.COUNT_USER_POINTS_LOG_SELECT_SQL);

                    statement.setString(1, recommenderUserId);

                    statement.setString(2, userId);

                    statement.setString(3, restaurantId);

                    resultset = statement.executeQuery();

                    int rowCount;

                    if (resultset.next()) {
                        rowCount = resultset.getInt(1);
                        statement.close();

                        if (rowCount == 0) {
                            //There should be way to add points only once!! - recommenderUserId
                            statement = connection.prepareStatement(AskReplyQueries.USER_POINTS_UPDATE_SQL);

                            statement.setInt(1, 4);

                            statement.setString(2, recommenderUserId);

                            statement.executeUpdate();

                            statement.close();

                            //insert into uer point table
                            statement = connection.prepareStatement(AskReplyQueries.USER_POINTS_INSERT_SQL);

                            statement.setInt(1, 4);

                            statement.setString(2, userId);

                            statement.setString(3, restaurantId);

                            statement.setTimestamp(4,
                                CommonFunctionsUtil.getCurrentDateTimestamp());

                            statement.setString(5, recommenderUserId);

                            statement.executeUpdate();

                            statement.close();
                        }
                    }

                    statement.close();
                }
            }

            statement = connection.prepareStatement(TSDBCommonQueries.HISTORICAL_RESTAURANT_FAV_INSERT_SQL);

            statement.setString(1, likeFlag);

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
            statement = connection.prepareStatement(AskReplyQueries.RECO_LIKE_INSERT_SQL);

            for (String replyId : replyIdList) {
                statement.setString(1,
                    userId + CommonFunctionsUtil.generateUniqueKey());
                statement.setString(2, userId);
                statement.setString(3, replyId);
                statement.setString(4, likeFlag);
                statement.setTimestamp(5,
                    CommonFunctionsUtil.getCurrentDateTimestamp());

                statement.executeUpdate();
            }

            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.HISTORICAL_RECO_LIKE_INSERT_SQL);

            for (String replyId : replyIdList) {
                inputKeyStr = new ArrayList<String>();
                inputKeyStr.add(userId);

                statement.setString(1,
                    userId +
                    CommonFunctionsUtil.generateUniqueKey(inputKeyStr));
                statement.setString(2, userId);
                statement.setString(3, replyId);
                statement.setString(4, likeFlag);
                statement.setTimestamp(5,
                    CommonFunctionsUtil.getCurrentDateTimestamp());

                statement.executeUpdate();
            }

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
                "Error while submitRecommendationDidYouLikeLikes " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void submitRecommendationFollowupAnswer(TSDataSource tsDataSource,
        Connection connection, String userId, String questionId,
        String replyText, String[] restaurantIdList) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();
            statement = connection.prepareStatement(AskReplyQueries.QUESTION_REPLY_USER_INSERT_SQL);
            statement.setString(1, questionId);
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            String replyId = questionId +
                CommonFunctionsUtil.generateUniqueKey();

            statement.setString(3, replyId);

            statement.setString(4, replyText);
            statement.setString(5, userId);
            statement.setString(6, userId);
            statement.executeUpdate();
            statement.close();

            String recipientId = null;

            statement = connection.prepareStatement(AskReplyQueries.QUESTION_RECIPIENT_SELECT_SQL);

            statement.setString(1, questionId);
            resultset = statement.executeQuery();

            if (resultset.next()) {
                recipientId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "restaurant_question_user.initiator_user_id"));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_INSERT_SQL);
            statement.setString(1, replyText);
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            String messageId = userId +
                CommonFunctionsUtil.generateUniqueKey();
            statement.setString(3, messageId);
            statement.setString(4, null);
            statement.setString(5, questionId);
            statement.setString(6, recipientId);
            statement.setString(7, null);
            statement.setString(8, userId);

            statement.executeUpdate();
            statement.close();
            tsDataSource.commit();
            tsDataSource.begin();
            statement = connection.prepareStatement(AskReplyQueries.MESSAGE_RESTAURANT_INSERT_SQL);

            for (String restaurantId : restaurantIdList) {
                statement.setString(1, messageId);
                statement.setString(2, restaurantId);
                statement.addBatch();
            }

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

            throw new TasteSyncException(
                "Error while submitRecommendationFollowupAnswer " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    @Override
    public void submitRecommendationMessageAnswer(TSDataSource tsDataSource,
        Connection connection, String newMessageText, String previousMessageId,
        String newMessageRecipientUserId, String newMessageSenderUserId,
        String[] restaurantIdList) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(AskReplyQueries.USER_MESSAGE_INSERT_SQL);
            statement.setString(1, newMessageText);
            statement.setTimestamp(2,
                CommonFunctionsUtil.getCurrentDateTimestamp());

            String messageId = newMessageSenderUserId +
                CommonFunctionsUtil.generateUniqueKey();
            statement.setString(3, messageId);
            statement.setString(4, previousMessageId);
            statement.setString(5, null);
            statement.setString(6, newMessageRecipientUserId);
            statement.setString(7, null);
            statement.setString(8, newMessageSenderUserId);

            statement.executeUpdate();
            statement.close();
            statement = connection.prepareStatement(AskReplyQueries.MESSAGE_RESTAURANT_INSERT_SQL);

            tsDataSource.commit();
            tsDataSource.begin();

            for (String restaurantId : restaurantIdList) {
                statement.setString(1, messageId);
                statement.setString(2, restaurantId);
                statement.addBatch();
            }

            statement.executeBatch();
            statement.close();

            tsDataSource.commit();
        } catch (MySQLIntegrityConstraintViolationException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while submitRecommendationMessageAnswer " +
                e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();

            try {
                tsDataSource.rollback();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }

            throw new TasteSyncException(
                "Error while submitRecommendationMessageAnswer " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }

    //also see submitRecommendationRequestAnswer in algo (shpould be aligned!!!)
    @Override
    public void submitRecommendationRequestAnswer(TSDataSource tsDataSource,
        Connection connection, String recorequestId, String recommenderUserId,
        String[] restaurantIdList, String replyText) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
            tsDataSource.begin();

            statement = connection.prepareStatement(AskReplyQueries.RECOREQUEST_REPLY_USER_INSERT_SQL);

            //datetime userid random number
            statement.setString(1, recorequestId);

            List<String> inputKeyStr = new ArrayList<String>();
            inputKeyStr.add(recorequestId);

            String replyId = CommonFunctionsUtil.generateUniqueKey(inputKeyStr);
            statement.setString(2, replyId);
            statement.setString(3, null);
            statement.setTimestamp(4,
                CommonFunctionsUtil.getCurrentDateTimestamp());
            statement.setString(5, replyText);
            statement.setString(6, recommenderUserId);
            statement.setString(7, recommenderUserId);
            statement.setInt(8, 4);
            statement.setInt(9, 1);

            statement.executeUpdate();

            statement.close();
            statement = connection.prepareStatement(TSDBCommonQueries.RECOREQUEST_USER_FRIEND_SELECT_SQL);
            statement.setString(1, recorequestId);
            resultset = statement.executeQuery();

            String recommendeeUserUserId = null;

            if (resultset.next()) {
                recommendeeUserUserId = CommonFunctionsUtil.getModifiedValueString(resultset.getString(
                            "recorequest_user.initiator_user_id"));
            }

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.RESTAURANT_REPLY_INSERT_SQL);

            for (String restaurantId : restaurantIdList) {
                statement.setTimestamp(1,
                    CommonFunctionsUtil.getCurrentDateTimestamp());

                statement.setString(2, null);

                statement.setString(3, replyId);
                statement.setString(4, restaurantId);

                statement.addBatch();
            }

            statement.executeBatch();

            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.USER_RESTAURANT_INSERT_SQL);

            for (String restaurantId : restaurantIdList) {
                //datetime userid random number
                statement.setString(1, recommendeeUserUserId);
                statement.setString(2, recommenderUserId);
                statement.setString(3, replyId);
                statement.setString(4, restaurantId);

                statement.setTimestamp(5,
                    CommonFunctionsUtil.getCurrentDateTimestamp());

                statement.addBatch();
            }

            statement.executeBatch();
            statement.close();

            statement = connection.prepareStatement(AskReplyQueries.COUNT_REPLIES_RECOREQUEST_REPLY_USER_SELECT_SQL);

            statement.setString(1, recorequestId);

            statement.setString(2, recommenderUserId);

            resultset = statement.executeQuery();

            int rowCount = 0;

            if (resultset.next()) {
                rowCount = resultset.getInt(1);
                statement.close();

                if (rowCount == 1) {
                    //There should be way to add points only once!! - recommenderUserId
                    statement = connection.prepareStatement(AskReplyQueries.USER_POINTS_UPDATE_SQL);

                    statement.setInt(1, 2);

                    statement.setString(2, recommenderUserId);

                    statement.executeUpdate();

                    statement.close();
                }
            }

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
                "Error while submitRecommendationRequestAnswer " +
                e.getMessage());
        } finally {
            tsDataSource.closeConnection(statement, resultset);
        }
    }
}
