package com.tastesync.bos;

import com.tastesync.db.dao.AutoPopulateDAO;
import com.tastesync.db.dao.AutoPopulateDAOImpl;
import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSLocationSearchCitiesObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;

import org.codehaus.jettison.json.JSONArray;

import java.sql.Connection;

import java.util.List;


public class AutoPopulateBOImpl implements AutoPopulateBO {
    private AutoPopulateDAO autoPopulateDAO = new AutoPopulateDAOImpl();

    @Override
    public JSONArray populateCuisineTier1(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populateCuisineTier1(tsDataSource, connection);
    }

    @Override
    public JSONArray populateCuisineTier2(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populateCuisineTier2(tsDataSource, connection);
    }

    @Override
    public List<TSLocationSearchCitiesObj> populateLocationSearchTerms(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        return autoPopulateDAO.populateLocationSearchTerms(tsDataSource,
            connection);
    }

    @Override
    public JSONArray populateOccasionDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populateOccasionDescriptor(tsDataSource,
            connection);
    }

    @Override
    public JSONArray populatePriceDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populatePriceDescriptor(tsDataSource, connection);
    }

    @Override
    public List<TSRestaurantObj> populateRestaurantSearchTerms(
        TSDataSource tsDataSource, Connection connection, String key,
        String cityId) throws TasteSyncException {
        return autoPopulateDAO.populateRestaurantSearchTerms(tsDataSource,
            connection, key, cityId);
    }

    @Override
    public List<TSRestaurantBasicObj> populateSuggestedRestaurantNames(
        TSDataSource tsDataSource, Connection connection, String restaurantKey,
        String cityId) throws TasteSyncException {
        return autoPopulateDAO.populateSuggestedRestaurantNames(tsDataSource,
            connection, restaurantKey, cityId);
    }

    @Override
    public JSONArray populateThemeDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populateThemeDescriptor(tsDataSource, connection);
    }

    @Override
    public JSONArray populateTypeofrestDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException {
        return autoPopulateDAO.populateTypeofrestDescriptor(tsDataSource,
            connection);
    }

    @Override
    public List<TSUserProfileBasicObj> populateUserSearchTerms(
        TSDataSource tsDataSource, Connection connection, String userId,
        String key, String excludeFollowees) throws TasteSyncException {
        return autoPopulateDAO.populateUserSearchTerms(tsDataSource,
            connection, userId, key, excludeFollowees);
    }

    @Override
    public JSONArray populateWhoareyouwithDescriptor(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        return autoPopulateDAO.populateWhoareyouwithDescriptor(tsDataSource,
            connection);
    }
}
