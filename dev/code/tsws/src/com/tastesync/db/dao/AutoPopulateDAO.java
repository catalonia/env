package com.tastesync.db.dao;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSInitDataObj;
import com.tastesync.model.objects.TSLocationSearchCitiesObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;

import org.codehaus.jettison.json.JSONArray;

import java.sql.Connection;

import java.util.List;


public interface AutoPopulateDAO {
    JSONArray populateCuisineTier1(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    JSONArray populateCuisineTier2(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    List<TSLocationSearchCitiesObj> populateLocationSearchTerms(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException;

    JSONArray populateOccasionDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    JSONArray populatePriceDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    List<TSRestaurantObj> populateRestaurantSearchTerms(
        TSDataSource tsDataSource, Connection connection, String key,
        String cityId) throws TasteSyncException;

    List<TSRestaurantBasicObj> populateSuggestedRestaurantNames(
        TSDataSource tsDataSource, Connection connection, String restaurantKey,
        String cityId) throws TasteSyncException;

    JSONArray populateThemeDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    JSONArray populateTypeofrestDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;

    List<TSUserProfileBasicObj> populateUserSearchTerms(
        TSDataSource tsDataSource, Connection connection, String userId,
        String key, String excludeFollowees) throws TasteSyncException;

    JSONArray populateWhoareyouwithDescriptor(TSDataSource tsDataSource,
        Connection connection) throws TasteSyncException;
    TSInitDataObj showInitData(TSDataSource tsDataSource,
            Connection connection) throws TasteSyncException;

}
