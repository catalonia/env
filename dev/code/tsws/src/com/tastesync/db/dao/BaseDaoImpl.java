package com.tastesync.db.dao;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;
import com.tastesync.db.queries.TSDBCommonQueries;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.derived.TSRestaurantsTileSearchObj;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public abstract class BaseDaoImpl {
    protected Logger logger = Logger.getLogger(getClass());

    //private static boolean printDebugExtra = false;
    public TSRestaurantsTileSearchObj getRestaurantTileSearchReslt(
        Connection connection, String restaurantId) throws TasteSyncException {
        PreparedStatement statement = null;
        ResultSet resultset = null;

        try {
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

            TSRestaurantsTileSearchObj tsRestaurantsTileSearchObj = new TSRestaurantsTileSearchObj();

            tsRestaurantsTileSearchObj.setRestaurantId(restaurantId);
            tsRestaurantsTileSearchObj.setRestaurantName(restaurantName);
            tsRestaurantsTileSearchObj.setPrice(price);
            tsRestaurantsTileSearchObj.setRestaurantName(restaurantName);
            tsRestaurantsTileSearchObj.setRestaurantCity(restaurantCity);
            tsRestaurantsTileSearchObj.setRestaurantLat(restaurantLat);
            tsRestaurantsTileSearchObj.setRestaurantLong(restaurantLong);
            tsRestaurantsTileSearchObj.setRestaurantDealFlag(restaurantDealFlag);
            tsRestaurantsTileSearchObj.setRestaurantRating(restaurantRating);
            tsRestaurantsTileSearchObj.setCuisineTier2Name(cuisineTier2Name);

            return tsRestaurantsTileSearchObj;
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
}
