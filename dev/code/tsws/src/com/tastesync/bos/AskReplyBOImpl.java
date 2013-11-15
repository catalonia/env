package com.tastesync.bos;

import com.tastesync.db.dao.AskReplyDAO;
import com.tastesync.db.dao.AskReplyDAOImpl;
import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSRecoNotificationBaseObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.derived.TSRecoRequestNonAssignedObj;
import com.tastesync.model.objects.derived.TSRecoRequestObj;
import com.tastesync.model.objects.derived.TSRecommendationsFollowupObj;
import com.tastesync.model.objects.derived.TSRecommendationsForYouObj;
import com.tastesync.model.objects.derived.TSRecommendeeUserObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchExtendedInfoObj;
import com.tastesync.model.objects.derived.TSSenderUserObj;

import java.sql.Connection;

import java.util.List;


public class AskReplyBOImpl implements AskReplyBO {
    private AskReplyDAO askReplyDAO = new AskReplyDAOImpl();

    @Override
    public String showAskForRecommendationFriends(TSDataSource tsDataSource,
        Connection connection, String recoRequestId) throws TasteSyncException {
        return askReplyDAO.showAskForRecommendationFriends(tsDataSource,
            connection, recoRequestId);
    }

    @Override
    public TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String neighborhoodId, String cityId,
        String stateName, String[] cuisineTier1IdList, String[] priceIdList,
        String rating, String savedFlag, String favFlag, String dealFlag,
        String chainFlag, String paginationId) throws TasteSyncException {
        return askReplyDAO.showListOfRestaurantsSearchResults(tsDataSource,
            connection, userId, restaurantId, neighborhoodId, cityId,
            stateName, cuisineTier1IdList, priceIdList, rating, savedFlag,
            favFlag, dealFlag, chainFlag, paginationId);
    }

    public TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResultsBasedOnRecoId(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String paginationId) throws TasteSyncException {
        return askReplyDAO.showListOfRestaurantsSearchResultsBasedOnRecoId(tsDataSource,
            connection, userId, recoRequestId, paginationId);
    }

    @Override
    public List<TSRestaurantBasicObj> showRecommendationDidYouLike(
        TSDataSource tsDataSource, Connection connection, String recorequestId)
        throws TasteSyncException {
        return askReplyDAO.showRecommendationDidYouLike(tsDataSource,
            connection, recorequestId);
    }

    @Override
    public TSSenderUserObj showRecommendationMessage(
        TSDataSource tsDataSource, Connection connection, String messageId,
        String recipientUserId) throws TasteSyncException {
        return askReplyDAO.showRecommendationMessage(tsDataSource, connection,
            messageId, recipientUserId);
    }

    @Override
    public TSRecommendationsFollowupObj showRecommendationsFollowup(
        TSDataSource tsDataSource, Connection connection, String userId,
        String questionId) throws TasteSyncException {
        return askReplyDAO.showRecommendationsFollowup(tsDataSource,
            connection, userId, questionId);
    }

    @Override
    public TSRecommendationsForYouObj showRecommendationsForYou(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recorequestId) throws TasteSyncException {
        return askReplyDAO.showRecommendationsForYou(tsDataSource, connection,
            userId, recorequestId);
    }

    @Override
    public List<TSRecoNotificationBaseObj> showRecommendationsList(
        TSDataSource tsDataSource, Connection connection, String userId,
        String paginationId) throws TasteSyncException {
        return askReplyDAO.showRecommendationsList(tsDataSource, connection,
            userId, paginationId);
    }

    @Override
    public TSRecoRequestObj showRecommendationsRequest(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recorequestId) throws TasteSyncException {
        return askReplyDAO.showRecommendationsRequest(tsDataSource, connection,
            userId, recorequestId);
    }

    @Override
    public TSRecommendeeUserObj showRecommendationsShowLikes(
        TSDataSource tsDataSource, Connection connection, String recoLikeId,
        String recommenderUserId) throws TasteSyncException {
        return askReplyDAO.showRecommendationsShowLikes(tsDataSource,
            connection, recoLikeId, recommenderUserId);
    }

    @Override
    public TSRecoRequestNonAssignedObj submitAskForRecommendationFriends(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String recoRequestFriendText,
        String[] friendsFacebookIdList, String postRecoRequestOnFacebook)
        throws TasteSyncException {
        return askReplyDAO.submitAskForRecommendationFriends(tsDataSource,
            connection, userId, recoRequestId, recoRequestFriendText,
            friendsFacebookIdList, postRecoRequestOnFacebook);
    }

    @Override
    public String submitAskForRecommendationSearch(TSDataSource tsDataSource,
        Connection connection, String userId, String[] cuisineTier1IdList,
        String[] cuisineTier2IdList, String[] priceIdList,
        String[] themeIdList, String[] whoareyouwithIdList,
        String[] typeOfRestaurantIdList, String[] occasionIdList,
        String neighborhoodId, String cityId, String stateName)
        throws TasteSyncException {
        return askReplyDAO.submitAskForRecommendationSearch(tsDataSource,
            connection, userId, cuisineTier1IdList, cuisineTier2IdList,
            priceIdList, themeIdList, whoareyouwithIdList,
            typeOfRestaurantIdList, occasionIdList, neighborhoodId, cityId,
            stateName);
    }

    @Override
    public void submitRecommendationDidYouLikeLikes(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String likeFlag) throws TasteSyncException {
        askReplyDAO.submitRecommendationDidYouLikeLikes(tsDataSource,
            connection, userId, restaurantId, likeFlag);
    }

    @Override
    public void submitRecommendationFollowupAnswer(TSDataSource tsDataSource,
        Connection connection, String userId, String questionId,
        String replyText, String[] restaurantIdList) throws TasteSyncException {
        askReplyDAO.submitRecommendationFollowupAnswer(tsDataSource,
            connection, userId, questionId, replyText, restaurantIdList);
    }

    @Override
    public void submitRecommendationMessageAnswer(TSDataSource tsDataSource,
        Connection connection, String newMessageText, String previousMessageId,
        String newMessageRecipientUserId, String newMessageSenderUserId,
        String[] restaurantIdList) throws TasteSyncException {
        askReplyDAO.submitRecommendationMessageAnswer(tsDataSource, connection,
            newMessageText, previousMessageId, newMessageRecipientUserId,
            newMessageSenderUserId, restaurantIdList);
    }

    @Override
    public void submitRecommendationRequestAnswer(TSDataSource tsDataSource,
        Connection connection, String recorequestId, String recommenderUserId,
        String[] restaurantIdList, String replyText) throws TasteSyncException {
        askReplyDAO.submitRecommendationRequestAnswer(tsDataSource, connection,
            recorequestId, recommenderUserId, restaurantIdList, replyText);
    }
}
