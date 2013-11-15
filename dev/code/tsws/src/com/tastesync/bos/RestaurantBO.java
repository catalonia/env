package com.tastesync.bos;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSMenuObj;
import com.tastesync.model.objects.TSRestaurantDetailsObj;
import com.tastesync.model.objects.TSRestaurantExtendInfoObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSRestaurantPhotoObj;
import com.tastesync.model.objects.TSRestaurantQuesionNonTsAssignedObj;
import com.tastesync.model.objects.TSRestaurantTipsAPSettingsObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzCompleteObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzObj;
import com.tastesync.model.objects.derived.TSRestaurantRecommendersDetailsObj;

import java.sql.Connection;

import java.util.List;


public interface RestaurantBO {
    @Deprecated
    List<TSRestaurantBuzzObj> showRestaurantBuzz(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId)
        throws TasteSyncException;

    TSRestaurantBuzzCompleteObj showRestaurantBuzzComplete(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException;

    TSRestaurantDetailsObj showRestaurantDetail(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId)
        throws TasteSyncException;

    TSRestaurantObj showRestaurantDetail(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException;

    TSRestaurantRecommendersDetailsObj showRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException;

    TSMenuObj showRestaurantDetailMenu(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException;

    TSRestaurantExtendInfoObj showRestaurantDetailMoreInfo(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException;

    List<TSRestaurantPhotoObj> showRestaurantDetailPhotos(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException;

    List<TSRestaurantTipsAPSettingsObj> showRestaurantDetailTipAPSettings(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException;

    List<TSRestaurantObj> showRestaurantsDetailsList(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException;

    void submitAddOrRemoveFromFavs(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantFavFlag) throws TasteSyncException;

    TSRestaurantQuesionNonTsAssignedObj submitRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String questionText, String postQuestionOnForum,
        String[] recommendersUserIdList, String[] friendsFacebookIdList)
        throws TasteSyncException;

    void submitRestaurantDetailTip(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String tipText, String shareOnFacebook, String shareOnTwitter)
        throws TasteSyncException;

    void submitSaveOrUnsaveRestaurant(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantSavedFlag) throws TasteSyncException;
}
