package com.tastesync.bos;

import com.tastesync.db.dao.RestaurantDAO;
import com.tastesync.db.dao.RestaurantDAOImpl;
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


public class RestaurantBOImpl implements RestaurantBO {
    private RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    @Override
    @Deprecated
    public List<TSRestaurantBuzzObj> showRestaurantBuzz(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantBuzz(tsDataSource, connection,
            userId, restaurantId);
    }

    @Override
    public TSRestaurantBuzzCompleteObj showRestaurantBuzzComplete(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantBuzzComplete(tsDataSource,
            connection, userId, restaurantId);
    }

    @Override
    public TSRestaurantObj showRestaurantDetail(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantDetail(tsDataSource, connection,
            restaurantId);
    }

    @Override
    public TSRestaurantDetailsObj showRestaurantDetail(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantDetail(tsDataSource, connection,
            userId, restaurantId);
    }

    @Override
    public TSRestaurantRecommendersDetailsObj showRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantDetailAsk(tsDataSource, connection,
            userId, restaurantId);
    }

    @Override
    public TSMenuObj showRestaurantDetailMenu(TSDataSource tsDataSource,
        Connection connection, String restaurantId) throws TasteSyncException {
        return restaurantDAO.showRestaurantDetailMenu(tsDataSource, connection,
            restaurantId);
    }

    @Override
    public TSRestaurantExtendInfoObj showRestaurantDetailMoreInfo(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException {
        return restaurantDAO.showRestaurantDetailMoreInfo(tsDataSource,
            connection, restaurantId);
    }

    @Override
    public List<TSRestaurantPhotoObj> showRestaurantDetailPhotos(
        TSDataSource tsDataSource, Connection connection, String restaurantId)
        throws TasteSyncException {
        return restaurantDAO.showRestaurantDetailPhotos(tsDataSource,
            connection, restaurantId);
    }

    @Override
    public List<TSRestaurantTipsAPSettingsObj> showRestaurantDetailTipAPSettings(
        TSDataSource tsDataSource, Connection connection, String userId)
        throws TasteSyncException {
        return restaurantDAO.showRestaurantDetailTipAPSettings(tsDataSource,
            connection, userId);
    }

    @Override
    public List<TSRestaurantObj> showRestaurantsDetailsList(
        TSDataSource tsDataSource, Connection connection)
        throws TasteSyncException {
        return restaurantDAO.showRestaurantsDetailsList(tsDataSource, connection);
    }

    @Override
    public void submitAddOrRemoveFromFavs(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantFavFlag) throws TasteSyncException {
        restaurantDAO.submitAddOrRemoveFromFavs(tsDataSource, connection,
            userId, restaurantId, userRestaurantFavFlag);
    }

    @Override
    public TSRestaurantQuesionNonTsAssignedObj submitRestaurantDetailAsk(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String questionText, String postQuestionOnForum,
        String[] recommendersUserIdList, String[] friendsFacebookIdList)
        throws TasteSyncException {
        return restaurantDAO.submitRestaurantDetailAsk(tsDataSource,
            connection, userId, restaurantId, questionText,
            postQuestionOnForum, recommendersUserIdList, friendsFacebookIdList);
    }

    @Override
    public void submitRestaurantDetailTip(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String tipText, String shareOnFacebook, String shareOnTwitter)
        throws TasteSyncException {
        restaurantDAO.submitRestaurantDetailTip(tsDataSource, connection,
            userId, restaurantId, tipText, shareOnFacebook, shareOnTwitter);
    }

    @Override
    public void submitSaveOrUnsaveRestaurant(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String userRestaurantSavedFlag) throws TasteSyncException {
        restaurantDAO.submitSaveOrUnsaveRestaurant(tsDataSource, connection,
            userId, restaurantId, userRestaurantSavedFlag);
    }
}
