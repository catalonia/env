package com.tastesync.services;

import com.tastesync.bos.AskReplyBO;
import com.tastesync.bos.AskReplyBOImpl;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSErrorObj;
import com.tastesync.model.objects.TSKeyValueObj;
import com.tastesync.model.objects.TSRecoNotificationBaseObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSSuccessObj;
import com.tastesync.model.objects.derived.TSRecoRequestNonAssignedObj;
import com.tastesync.model.objects.derived.TSRecoRequestObj;
import com.tastesync.model.objects.derived.TSRecommendationsFollowupObj;
import com.tastesync.model.objects.derived.TSRecommendationsForYouObj;
import com.tastesync.model.objects.derived.TSRecommendeeUserObj;
import com.tastesync.model.objects.derived.TSRestaurantsTileSearchExtendedInfoObj;
import com.tastesync.model.objects.derived.TSSenderUserObj;
import com.tastesync.model.vo.HeaderDataVO;

import com.tastesync.oauth.model.vo.OAuthDataVO;

import com.tastesync.util.TSConstants;
import com.tastesync.util.TSResponseStatusCode;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.SQLException;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


/**
 * Web Service class to expose functionality related to "Ask" via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
@Path("/ask")
@Consumes({MediaType.APPLICATION_JSON
})
@Produces({MediaType.APPLICATION_JSON
})
public class AskReplyService extends BaseService {
    /**
     * Logger for this class
     */
    private static final Logger logger = Logger.getLogger(AskReplyService.class);

    /**
     * DOCUMENT ME!
     */
    private AskReplyBO askReplyBO = new AskReplyBOImpl();

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param recoRequestId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recofriends")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSKeyValueObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showAskForRecommendationFriends(
        @Context
    HttpHeaders headers, @QueryParam("recorequestid")
    String recoRequestId) {
        super.processHttpHeaders(headers);

        boolean responseDone = false;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        recoRequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recoRequestId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            //TODO check if input recoRequestId is associated with the corresponding userId
            String recoRequestText = askReplyBO.showAskForRecommendationFriends(tsDataSource,
                    connection, recoRequestId);

            responseDone = true;

            TSKeyValueObj tsKeyValueObj = new TSKeyValueObj();
            tsKeyValueObj.setKeyName(TSKeyValueObj.KEY);
            tsKeyValueObj.setKeyNameValue("recorequesttext");

            tsKeyValueObj.setValueName(TSKeyValueObj.VALUE);
            tsKeyValueObj.setValueNameValue(recoRequestText);
            responseDone = true;

            return Response.status(status).entity(tsKeyValueObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showAskForRecommendationFriends()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param neighborhoodId DOCUMENT ME!
     * @param cityId DOCUMENT ME!
     * @param stateName DOCUMENT ME!
     * @param cuisineTier1IdList DOCUMENT ME!
     * @param priceIdList DOCUMENT ME!
     * @param rating DOCUMENT ME!
     * @param savedFlag DOCUMENT ME!
     * @param favFlag DOCUMENT ME!
     * @param dealFlag DOCUMENT ME!
     * @param chainFlag DOCUMENT ME!
     * @param paginationId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recosrestaurantsearchresults")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantsTileSearchExtendedInfoObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showListOfRestaurantsSearchResults(
        @Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId, @QueryParam("neighborhoodid")
    String neighborhoodId, @QueryParam("cityid")
    String cityId, @QueryParam("statename")
    String stateName,
        @QueryParam("cuisineidtier1idlist")
    String cuisineTier1IdList, @QueryParam("priceidlist")
    String priceIdList, @QueryParam("rating")
    String rating, @QueryParam("savedflag")
    String savedFlag, @QueryParam("favflag")
    String favFlag, @QueryParam("dealflag")
    String dealFlag, @QueryParam("chainflag")
    String chainFlag, @QueryParam("paginationid")
    String paginationId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        //To Be removed!!
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);
        neighborhoodId = CommonFunctionsUtil.converStringAsNullIfNeeded(neighborhoodId);
        cityId = CommonFunctionsUtil.converStringAsNullIfNeeded(cityId);
        stateName = CommonFunctionsUtil.converStringAsNullIfNeeded(stateName);
        cuisineTier1IdList = CommonFunctionsUtil.converStringAsNullIfNeeded(cuisineTier1IdList);
        priceIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(priceIdList);
        rating = CommonFunctionsUtil.converStringAsNullIfNeeded(rating);

        if ("0".equals(rating)) {
            rating = null;
        } // end if

        savedFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(savedFlag);

        if ("0".equals(savedFlag)) {
            savedFlag = null;
        } // end if

        favFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(favFlag);

        if ("0".equals(favFlag)) {
            favFlag = null;
        } // end if

        dealFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(dealFlag);

        if ("0".equals(dealFlag)) {
            dealFlag = null;
        } // end if

        chainFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(chainFlag);
        paginationId = CommonFunctionsUtil.converStringAsNullIfNeeded(paginationId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRestaurantsTileSearchExtendedInfoObj tsRestaurantsTileSearchExtendedInfoObj =
                askReplyBO.showListOfRestaurantsSearchResults(tsDataSource,
                    connection, userId, restaurantId, neighborhoodId, cityId,
                    stateName,
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        cuisineTier1IdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        priceIdList), rating, savedFlag, favFlag, dealFlag,
                    chainFlag, paginationId);
            responseDone = true;

            return Response.status(status)
                           .entity(tsRestaurantsTileSearchExtendedInfoObj)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showListOfRestaurantsSearchResults()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param recoRequestId DOCUMENT ME!
     * @param paginationId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recosidrestaurantsearchresults")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantsTileSearchExtendedInfoObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showListOfRestaurantsSearchResultsBasedOnRecoId(
        @Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("recorequestid")
    String recoRequestId, @QueryParam("paginationid")
    String paginationId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        recoRequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recoRequestId);
        paginationId = CommonFunctionsUtil.converStringAsNullIfNeeded(paginationId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRestaurantsTileSearchExtendedInfoObj tsRestaurantsTileSearchExtendedInfoObj =
                askReplyBO.showListOfRestaurantsSearchResultsBasedOnRecoId(tsDataSource,
                    connection, userId, recoRequestId, paginationId);
            responseDone = true;

            return Response.status(status)
                           .entity(tsRestaurantsTileSearchExtendedInfoObj)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showListOfRestaurantsSearchResultsBasedOnRecoId()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param recorequestId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recommendedrestaurants")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantBasicObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationDidYouLike(@Context
    HttpHeaders headers, @QueryParam("recorequestid")
    String recorequestId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        recorequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recorequestId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            List<TSRestaurantBasicObj> tsRestaurantObjList = askReplyBO.showRecommendationDidYouLike(tsDataSource,
                    connection, recorequestId);
            responseDone = true;

            return Response.status(status).entity(tsRestaurantObjList).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationDidYouLike()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param messageId DOCUMENT ME!
     * @param recipientUserId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recomsg")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSenderUserObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationMessage(@Context
    HttpHeaders headers, @QueryParam("messageid")
    String messageId, @QueryParam("recipientuserid")
    String recipientUserId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        messageId = CommonFunctionsUtil.converStringAsNullIfNeeded(messageId);
        recipientUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(recipientUserId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSSenderUserObj tsSenderUserObj = askReplyBO.showRecommendationMessage(tsDataSource,
                    connection, messageId, recipientUserId);
            responseDone = true;

            return Response.status(status).entity(tsSenderUserObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationMessage()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param questionId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recosfollowup")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecommendationsFollowupObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationsFollowup(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("questionid")
    String questionId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        questionId = CommonFunctionsUtil.converStringAsNullIfNeeded(questionId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRecommendationsFollowupObj tsRecommendationsFollowupObj = askReplyBO.showRecommendationsFollowup(tsDataSource,
                    connection, userId, questionId);
            responseDone = true;

            return Response.status(status).entity(tsRecommendationsFollowupObj)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationsFollowup()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param recorequestId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recos4you")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecommendationsForYouObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationsForYou(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("recorequestid")
    String recorequestId) {
        super.processHttpHeaders(headers);

        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        recorequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recorequestId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRecommendationsForYouObj tsRecommendationsForYou = askReplyBO.showRecommendationsForYou(tsDataSource,
                    connection, userId, recorequestId);
            responseDone = true;

            return Response.status(status).entity(tsRecommendationsForYou)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationsForYou()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param paginationId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recolist")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecoNotificationBaseObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationsList(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("paginationid")
    String paginationId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            //parameters check
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            paginationId = CommonFunctionsUtil.converStringAsNullIfNeeded(paginationId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            List<TSRecoNotificationBaseObj> recoNotificationBase = askReplyBO.showRecommendationsList(tsDataSource,
                    connection, userId, paginationId);

            responseDone = true;

            return Response.status(status).entity(recoNotificationBase).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationsList()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param recorequestId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recorequest")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecoRequestObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationsRequest(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("recorequestid")
    String recorequestId) {
        super.processHttpHeaders(headers);

        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        recorequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recorequestId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRecoRequestObj tsRecoRequestObj = askReplyBO.showRecommendationsRequest(tsDataSource,
                    connection, userId, recorequestId);

            if (tsRecoRequestObj == null) {
                status = TSResponseStatusCode.INVALIDDATA.getValue();

                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);
                responseDone = true;

                return Response.status(status).entity(tsErrorObj).build();
            } // end if

            responseDone = true;

            return Response.status(status).entity(tsRecoRequestObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationsRequest()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param recoLikeId DOCUMENT ME!
     * @param recommenderUserId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/recosandlikes")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecommendeeUserObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRecommendationsShowLikes(@Context
    HttpHeaders headers, @QueryParam("recolikeid")
    String recoLikeId, @QueryParam("recommenderuserid")
    String recommenderUserId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        recoLikeId = CommonFunctionsUtil.converStringAsNullIfNeeded(recoLikeId);
        recommenderUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(recommenderUserId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRecommendeeUserObj tsRecommendeeUser = askReplyBO.showRecommendationsShowLikes(tsDataSource,
                    connection, recoLikeId, recommenderUserId);
            responseDone = true;

            return Response.status(status).entity(tsRecommendeeUser).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end showRecommendationsShowLikes()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param recoRequestId DOCUMENT ME!
     * @param recoRequestFriendText DOCUMENT ME!
     * @param friendsFacebookIdList DOCUMENT ME!
     * @param postRecoRequestOnFacebook DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/saverecofriends")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRecoRequestNonAssignedObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    private Response submitAskForRecommendationFriends(
        @Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("recorequestid")
    String recoRequestId,
        @FormParam("recorequestfriendtext")
    String recoRequestFriendText,
        @FormParam("friendsfacebookidlist")
    String friendsFacebookIdList,
        @FormParam("postonfacebook")
    String postRecoRequestOnFacebook) {
        super.processHttpHeaders(headers);

        //    	-- TODO: SAVE "POSTONFACEBOOK" IN HISTORICAL SHARED TABLE
        //
        //    	-- For Loop over each friend in listOfFriends{facebookId}
        //    	-- solved for single facebookId below
        //
        //    	-- calculate1 Logic

        //parameters check
        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            recoRequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recoRequestId);
            recoRequestFriendText = CommonFunctionsUtil.converStringAsNullIfNeeded(recoRequestFriendText);
            friendsFacebookIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(friendsFacebookIdList);
            postRecoRequestOnFacebook = CommonFunctionsUtil.converStringAsNullIfNeeded(postRecoRequestOnFacebook);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            TSRecoRequestNonAssignedObj tsRecoRequestNonAssignedObj = askReplyBO.submitAskForRecommendationFriends(tsDataSource,
                    connection, userId, recoRequestId, recoRequestFriendText,
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        friendsFacebookIdList), postRecoRequestOnFacebook);

            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status).entity(tsRecoRequestNonAssignedObj)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitAskForRecommendationFriends()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param cuisineTier1IdList DOCUMENT ME!
     * @param cuisineTier2IdList DOCUMENT ME!
     * @param priceIdList DOCUMENT ME!
     * @param themeIdList DOCUMENT ME!
     * @param whoareyouwithIdList DOCUMENT ME!
     * @param typeOfRestaurantIdList DOCUMENT ME!
     * @param occasionIdList DOCUMENT ME!
     * @param neighborhoodId DOCUMENT ME!
     * @param cityId DOCUMENT ME!
     * @param stateName DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/recosearch")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitAskForRecommendationSearch(
        @Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("cuisinetier1idlist")
    String cuisineTier1IdList,
        @FormParam("cuisineiier2idlist")
    String cuisineTier2IdList, @FormParam("priceidlist")
    String priceIdList, @FormParam("themeidlist")
    String themeIdList,
        @FormParam("whoareyouwithidlist")
    String whoareyouwithIdList,
        @FormParam("typeofrestaurantidList")
    String typeOfRestaurantIdList,
        @FormParam("occasionidlist")
    String occasionIdList, @FormParam("neighborhoodid")
    String neighborhoodId, @FormParam("cityid")
    String cityId, @FormParam("statename")
    String stateName) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            cuisineTier1IdList = CommonFunctionsUtil.converStringAsNullIfNeeded(cuisineTier1IdList);
            cuisineTier2IdList = CommonFunctionsUtil.converStringAsNullIfNeeded(cuisineTier2IdList);
            priceIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(priceIdList);
            themeIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(themeIdList);
            whoareyouwithIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(whoareyouwithIdList);
            typeOfRestaurantIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(typeOfRestaurantIdList);
            occasionIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(occasionIdList);
            neighborhoodId = CommonFunctionsUtil.converStringAsNullIfNeeded(neighborhoodId);

            cityId = CommonFunctionsUtil.converStringAsNullIfNeeded(cityId);
            stateName = CommonFunctionsUtil.converStringAsNullIfNeeded(stateName);

            // if cityId is null, error!
            if (cityId == null) {
                status = TSResponseStatusCode.INVALIDDATA.getValue();

                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);
                responseDone = true;

                return Response.status(status)
                               .header("cityId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            String recoRequestId = askReplyBO.submitAskForRecommendationSearch(tsDataSource,
                    connection, userId,
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        cuisineTier1IdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        cuisineTier2IdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        priceIdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        themeIdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        whoareyouwithIdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        typeOfRestaurantIdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        occasionIdList), neighborhoodId, cityId, stateName);

            TSKeyValueObj tsKeyValueObj = new TSKeyValueObj();
            tsKeyValueObj.setKeyName(TSKeyValueObj.KEY);
            tsKeyValueObj.setKeyNameValue("recorequestid");
            tsKeyValueObj.setValueName(TSKeyValueObj.VALUE);
            tsKeyValueObj.setValueNameValue(recoRequestId);
            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.TRIGGER_ALGO1_SCRIPT +
                    " " + recoRequestId,
                    TSConstants.BASENAME_TRIGGER_ALGO1_SCRIPT1);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status).entity(tsKeyValueObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitAskForRecommendationSearch()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param likeFlag DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/likesunlikes")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRecommendationDidYouLikeLikes(
        @Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("restaurantid")
    String restaurantId, @FormParam("likeflag")
    String likeFlag) {
        super.processHttpHeaders(headers);

        //Should be triggered on every like or Un-like click. Should update Faves list of the user

        //parameters check
        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);
            likeFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(likeFlag);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            askReplyBO.submitRecommendationDidYouLikeLikes(tsDataSource,
                connection, userId, restaurantId, likeFlag);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status).entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitRecommendationDidYouLikeLikes()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param questionId DOCUMENT ME!
     * @param replyText DOCUMENT ME!
     * @param restaurantIdList DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/recofollowupanswer")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRecommendationFollowupAnswer(
        @Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("questiondid")
    String questionId, @FormParam("replytext")
    String replyText, @FormParam("restaurantidlist")
    String restaurantIdList) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            questionId = CommonFunctionsUtil.converStringAsNullIfNeeded(questionId);
            replyText = CommonFunctionsUtil.converStringAsNullIfNeeded(replyText);
            restaurantIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantIdList);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            askReplyBO.submitRecommendationFollowupAnswer(tsDataSource,
                connection, userId, questionId, replyText,
                CommonFunctionsUtil.convertStringListAsArrayList(
                    restaurantIdList));

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status).entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitRecommendationFollowupAnswer()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param newMessageText DOCUMENT ME!
     * @param previousMessageId DOCUMENT ME!
     * @param newMessageRecipientUserId DOCUMENT ME!
     * @param newMessageSenderUserId DOCUMENT ME!
     * @param restaurantIdList DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/recomsgans")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRecommendationMessageAnswer(
        @Context
    HttpHeaders headers, @FormParam("newmessagetext")
    String newMessageText,
        @FormParam("previousmessageid")
    String previousMessageId,
        @FormParam("newmessagerecipientuserid")
    String newMessageRecipientUserId,
        @FormParam("newmessagesenderuserid")
    String newMessageSenderUserId,
        @FormParam("restaurantidlist")
    String restaurantIdList) {
        super.processHttpHeaders(headers);

        //parameters check
        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            newMessageText = CommonFunctionsUtil.converStringAsNullIfNeeded(newMessageText);
            previousMessageId = CommonFunctionsUtil.converStringAsNullIfNeeded(previousMessageId);
            newMessageRecipientUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(newMessageRecipientUserId);
            newMessageSenderUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(newMessageSenderUserId);

            if (newMessageRecipientUserId == null) {
                status = TSResponseStatusCode.INVALIDDATA.getValue();

                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);
                responseDone = true;

                try {
                    CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                        TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
                } // end try
                catch (com.tastesync.common.exception.TasteSyncException e) {
                    logger.error(e);
                } // end catch

                return Response.status(status)
                               .header("recipientyId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            askReplyBO.submitRecommendationMessageAnswer(tsDataSource,
                connection, newMessageText, previousMessageId,
                newMessageRecipientUserId, newMessageSenderUserId,
                CommonFunctionsUtil.convertStringListAsArrayList(
                    restaurantIdList));

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            responseDone = true;

            return Response.status(status).entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitRecommendationMessageAnswer()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param recorequestId DOCUMENT ME!
     * @param recommenderUserId DOCUMENT ME!
     * @param restaurantIdList DOCUMENT ME!
     * @param replyText DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/recoreqans")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRecommendationRequestAnswer(
        @Context
    HttpHeaders headers, @FormParam("recorequestid")
    String recorequestId,
        @FormParam("recommenderuserid")
    String recommenderUserId,
        @FormParam("restaurantidlist")
    String restaurantIdList, @FormParam("replytext")
    String replyText) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            //parameters check
            recorequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recorequestId);
            recommenderUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(recommenderUserId);
            restaurantIdList = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantIdList);
            replyText = CommonFunctionsUtil.converStringAsNullIfNeeded(replyText);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
                userId = oauthUserId;
            } // end if

            askReplyBO.submitRecommendationRequestAnswer(tsDataSource,
                connection, recorequestId, recommenderUserId,
                CommonFunctionsUtil.convertStringListAsArrayList(
                    restaurantIdList), replyText);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status).entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
    } // end submitRecommendationRequestAnswer()
    
    
    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param recorequestId DOCUMENT ME!
     * @param assignedUserId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/recoreqtscontact")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitAskForRecommendationTsContact(
        @Context
    HttpHeaders headers, @FormParam("recorequestid")
    String recorequestId,
        @FormParam("assigneduserid")
    String assignedUserId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            //parameters check
            recorequestId = CommonFunctionsUtil.converStringAsNullIfNeeded(recorequestId);
            assignedUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(assignedUserId);

            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataVO oauthDataVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if (oauthDataVO == null) {
                    return notAuthorised();
                } // end if

                oauthUserId = oauthDataVO.getUserId();
            } // end if

            askReplyBO.submitAskForRecommendationTsContact(tsDataSource,
                connection, recorequestId, assignedUserId);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            responseDone = true;
            return Response.status(status).entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);

            if (status != TSResponseStatusCode.SUCCESS.getValue()) {
                if (!responseDone) {
                    status = TSResponseStatusCode.ERROR.getValue();

                    TSErrorObj tsErrorObj = new TSErrorObj();
                    tsErrorObj.setErrorMsg(TSConstants.ERROR_UNKNOWN_SYSTEM_KEY);

                    return Response.status(status).entity(tsErrorObj).build();
                } // end if
            } // end if
        } // end finally
        
    }
    
    
} // end AskReplyService
