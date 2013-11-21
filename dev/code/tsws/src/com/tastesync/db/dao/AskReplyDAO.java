package com.tastesync.db.dao;

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

public interface AskReplyDAO {
    String showAskForRecommendationFriends(TSDataSource tsDataSource,
        Connection connection, String recoRequestId) throws TasteSyncException;

    TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResults(
        TSDataSource tsDataSource, Connection connection, String userId,
        String restaurantId, String neighborhoodId, String cityId,
        String stateName, String[] cuisineTier1IdList, String[] priceIdList,
        String rating, String savedFlag, String favFlag, String dealFlag,
        String chainFlag, String paginationId) throws TasteSyncException;

    TSRestaurantsTileSearchExtendedInfoObj showListOfRestaurantsSearchResultsBasedOnRecoId(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String paginationId) throws TasteSyncException;

    List<TSRestaurantBasicObj> showRecommendationDidYouLike(
        TSDataSource tsDataSource, Connection connection, String recorequestId)
        throws TasteSyncException;

    TSSenderUserObj showRecommendationMessage(TSDataSource tsDataSource,
        Connection connection, String messageId, String recipientUserId)
        throws TasteSyncException;

    TSRecommendationsFollowupObj showRecommendationsFollowup(
        TSDataSource tsDataSource, Connection connection, String userId,
        String questionId) throws TasteSyncException;

    TSRecommendationsForYouObj showRecommendationsForYou(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recorequestId) throws TasteSyncException;

    List<TSRecoNotificationBaseObj> showRecommendationsList(
        TSDataSource tsDataSource, Connection connection, String userId,
        String paginationId) throws TasteSyncException;

    TSRecoRequestObj showRecommendationsRequest(TSDataSource tsDataSource,
        Connection connection, String userId, String recorequestId)
        throws TasteSyncException;

    TSRecommendeeUserObj showRecommendationsShowLikes(
        TSDataSource tsDataSource, Connection connection, String recoLikeId,
        String recommenderUserId) throws TasteSyncException;

    TSRecoRequestNonAssignedObj submitAskForRecommendationFriends(
        TSDataSource tsDataSource, Connection connection, String userId,
        String recoRequestId, String recoRequestFriendText,
        String[] friendsFacebookIdList, String postRecoRequestOnFacebook)
        throws TasteSyncException;

    String submitAskForRecommendationSearch(TSDataSource tsDataSource,
        Connection connection, String userId, String[] cuisineTier1IdList,
        String[] cuisineTier2IdList, String[] priceIdList,
        String[] themeIdList, String[] whoareyouwithIdList,
        String[] typeOfRestaurantIdList, String[] occasionIdList,
        String neighborhoodId, String cityId, String stateName)
        throws TasteSyncException;

    void submitAskForRecommendationTsContact(TSDataSource tsDataSource,
        Connection connection, String recorequestId, String assignedUserId)
        throws TasteSyncException;

    void submitRecommendationDidYouLikeLikes(TSDataSource tsDataSource,
        Connection connection, String userId, String restaurantId,
        String likeFlag) throws TasteSyncException;

    void submitRecommendationFollowupAnswer(TSDataSource tsDataSource,
        Connection connection, String userId, String questionId,
        String replyText, String[] restaurantIdList) throws TasteSyncException;

    void submitRecommendationMessageAnswer(TSDataSource tsDataSource,
        Connection connection, String newMessageText, String previousMessageId,
        String newMessageRecipientUserId, String newMessageSenderUserId,
        String[] restaurantIdList) throws TasteSyncException;

    void submitRecommendationRequestAnswer(TSDataSource tsDataSource,
        Connection connection, String recorequestId, String recommenderUserId,
        String[] restaurantIdList, String replyText) throws TasteSyncException;
}
