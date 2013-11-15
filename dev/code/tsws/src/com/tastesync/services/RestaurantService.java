package com.tastesync.services;

import com.tastesync.bos.RestaurantBO;
import com.tastesync.bos.RestaurantBOImpl;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSErrorObj;
import com.tastesync.model.objects.TSMenuObj;
import com.tastesync.model.objects.TSRestaurantDetailsObj;
import com.tastesync.model.objects.TSRestaurantExtendInfoObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSRestaurantPhotoObj;
import com.tastesync.model.objects.TSRestaurantQuesionNonTsAssignedObj;
import com.tastesync.model.objects.TSRestaurantTipsAPSettingsObj;
import com.tastesync.model.objects.TSSuccessObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzCompleteObj;
import com.tastesync.model.objects.derived.TSRestaurantBuzzObj;
import com.tastesync.model.objects.derived.TSRestaurantRecommendersDetailsObj;
import com.tastesync.model.vo.HeaderDataVO;

import com.tastesync.oauth.model.vo.OAuthDataVO;

import com.tastesync.util.TSConstants;
import com.tastesync.util.TSResponseStatusCode;

import org.apache.log4j.Logger;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import java.io.IOException;

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
 * Web Service class to expose common functionality related to "restaurant" via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
@Path("/restaurant")
@Consumes({MediaType.APPLICATION_JSON
})
@Produces({MediaType.APPLICATION_JSON
})
public class RestaurantService extends BaseService {
    /** Logger for this class */
    private static final Logger logger = Logger.getLogger(RestaurantService.class);

    /**
     * DOCUMENT ME!
     */
    private RestaurantBO restaurantBO = new RestaurantBOImpl();

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @Deprecated
    @GET
    @Path("/buzz")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantBuzzObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    private Response showRestaurantBuzz(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        boolean responseDone = false;
        List<TSRestaurantBuzzObj> restaurantBuzzObjList = null;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            if (restaurantId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(status).entity(tsErrorObj).build();
            } // end if

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

            restaurantBuzzObjList = restaurantBO.showRestaurantBuzz(tsDataSource,
                    connection, userId, restaurantId);

            responseDone = true;

            return Response.status(status).entity(restaurantBuzzObjList).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

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
    } // end showRestaurantBuzz()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/buzzcomplete")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantBuzzObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantBuzzComplete(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            if (restaurantId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(status).entity(tsErrorObj).build();
            } // end if

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

            TSRestaurantBuzzCompleteObj tsRestaurantBuzzCompleteObj = restaurantBO.showRestaurantBuzzComplete(tsDataSource,
                    connection, userId, restaurantId);

            responseDone = true;

            return Response.status(status).entity(tsRestaurantBuzzCompleteObj)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

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
    } // end showRestaurantBuzzComplete()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/details")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantDetailsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetail(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        //    	
        //    	-- -- -- -- -- -- -- -- -- -- -- -- showRestaurantDetail -- -- -- -- -- -- -- -- -- -- -- -- 
        //    	-- TODO: Define factual_restaurant_deals table
        TSRestaurantDetailsObj tsRestaurantDetailsObj = null;
        boolean responseDone = false;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantDetailsObj = restaurantBO.showRestaurantDetail(tsDataSource,
                    connection, userId, restaurantId);
            responseDone = true;

            return Response.status(status).entity(tsRestaurantDetailsObj).build();
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
    } // end showRestaurantDetail()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/restaurantdetails")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    private Response showRestaurantDetail(@Context
    HttpHeaders headers, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        TSRestaurantObj tsRestaurantObj = null;
        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

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

            tsRestaurantObj = restaurantBO.showRestaurantDetail(tsDataSource,
                    connection, restaurantId);

            if (printDebugExtra) {
                try {
                    if (logger.isDebugEnabled()) {
                        logger.debug(mapper.defaultPrettyPrintingWriter()
                                           .writeValueAsString(tsRestaurantObj));
                    }
                } // end try
                catch (JsonGenerationException e) {
                    logger.error(e);
                } // end catch
                catch (JsonMappingException e) {
                    logger.error(e);
                } // end catch
                catch (IOException e) {
                    logger.error(e);
                } // end catch
            } // end if

            responseDone = true;

            return Response.status(status).entity(tsRestaurantObj).build();
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
    } // end showRestaurantDetail()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/askdetails")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantRecommendersDetailsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetailAsk(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        TSRestaurantRecommendersDetailsObj tsRestaurantRecommendersDetailsObj = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();

        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantRecommendersDetailsObj = restaurantBO.showRestaurantDetailAsk(tsDataSource,
                    connection, userId, restaurantId);
            responseDone = true;

            return Response.status(status)
                           .entity(tsRestaurantRecommendersDetailsObj).build();
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
    } // end showRestaurantDetailAsk()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/menu")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSMenuObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetailMenu(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        TSMenuObj tsMenuObj = null;
        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsMenuObj = restaurantBO.showRestaurantDetailMenu(tsDataSource,
                    connection, restaurantId);
            responseDone = true;

            return Response.status(status).entity(tsMenuObj).build();
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
    } // end showRestaurantDetailMenu()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/extendedinfo")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantExtendInfoObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetailMoreInfo(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        TSRestaurantExtendInfoObj tsRestaurantExtendInfoObj = null;
        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantExtendInfoObj = restaurantBO.showRestaurantDetailMoreInfo(tsDataSource,
                    connection, restaurantId);
            responseDone = true;

            return Response.status(status).entity(tsRestaurantExtendInfoObj)
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
    } // end showRestaurantDetailMoreInfo()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/photos")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantPhotoObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetailPhotos(@Context
    HttpHeaders headers, @QueryParam("userid")
    String userId, @QueryParam("restaurantid")
    String restaurantId) {
        super.processHttpHeaders(headers);

        List<TSRestaurantPhotoObj> tsRestaurantPhotoObjList = null;
        boolean responseDone = false;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantPhotoObjList = restaurantBO.showRestaurantDetailPhotos(tsDataSource,
                    connection, restaurantId);
            responseDone = true;

            return Response.status(status).entity(tsRestaurantPhotoObjList)
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
    } // end showRestaurantDetailPhotos()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/aptips")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantTipsAPSettingsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantDetailTipAPSettings(
        @Context
    HttpHeaders headers, @QueryParam("userid")
    String userId) {
        super.processHttpHeaders(headers);

        List<TSRestaurantTipsAPSettingsObj> tsRestaurantTipsAPSettingsObjList = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantTipsAPSettingsObjList = restaurantBO.showRestaurantDetailTipAPSettings(tsDataSource,
                    connection, userId);
            responseDone = true;

            return Response.status(status)
                           .entity(tsRestaurantTipsAPSettingsObjList).build();
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
    } // end showRestaurantDetailTipAPSettings()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param userRestaurantFavFlag DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/savefavs")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitAddOrRemoveFromFavs(@Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("restaurantid")
    String restaurantId,
        @FormParam("userrestaurantfavflag")
    String userRestaurantFavFlag) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;

        //check userRestaurantFavFlag is either 1 or 0
        try {
            Integer.parseInt(userRestaurantFavFlag);
        } // end try
        catch (NumberFormatException nfe) {
            status = TSResponseStatusCode.INVALIDDATA.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);
            responseDone = true;

            return Response.status(status)
                           .header("userrestaurantfavflag",
                (userRestaurantFavFlag != null) ? userRestaurantFavFlag
                                                : TSConstants.EMPTY)
                           .entity(tsErrorObj).build();
        } // end catch

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);
            userRestaurantFavFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(userRestaurantFavFlag);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
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

            restaurantBO.submitAddOrRemoveFromFavs(tsDataSource, connection,
                userId, restaurantId, userRestaurantFavFlag);

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
    } // end submitAddOrRemoveFromFavs()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param questionText DOCUMENT ME!
     * @param postQuestionOnForum DOCUMENT ME!
     * @param recommendersUserIdList DOCUMENT ME!
     * @param friendsFacebookIdList DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/askquestion")
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRestaurantDetailAsk(@Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("restaurantid")
    String restaurantId, @FormParam("questiontext")
    String questionText,
        @FormParam("postquestiononforum")
    String postQuestionOnForum,
        @FormParam("recommendersuseridlist")
    String recommendersUserIdList,
        @FormParam("friendsfacebookidlist")
    String friendsFacebookIdList) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();

        //check postQuestionOnForum is either 1 or 0
        try {
            Integer.parseInt(postQuestionOnForum);
        } // end try
        catch (NumberFormatException nfe) {
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch

        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        boolean responseDone = false;
        TSRestaurantQuesionNonTsAssignedObj tsRestaurantQuesionNonTsAssignedObj = null;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            tsRestaurantQuesionNonTsAssignedObj = restaurantBO.submitRestaurantDetailAsk(tsDataSource,
                    connection, userId, restaurantId, questionText,
                    postQuestionOnForum,
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        recommendersUserIdList),
                    CommonFunctionsUtil.convertStringListAsArrayList(
                        friendsFacebookIdList));

            responseDone = true;

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error(e);
            } // end catch

            return Response.status(status)
                           .entity(tsRestaurantQuesionNonTsAssignedObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

            return Response.status(status).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = false;

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
    } // end submitRestaurantDetailAsk()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param tipText DOCUMENT ME!
     * @param shareOnFacebook DOCUMENT ME!
     * @param shareOnTwitter DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/savetips")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitRestaurantDetailTip(@Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("restaurantid")
    String restaurantId, @FormParam("tiptext")
    String tipText, @FormParam("shareonfacebook")
    String shareOnFacebook, @FormParam("shareontwitter")
    String shareOnTwitter) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
        restaurantId = CommonFunctionsUtil.converStringAsNullIfNeeded(restaurantId);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
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

            restaurantBO.submitRestaurantDetailTip(tsDataSource, connection,
                userId, restaurantId, tipText, shareOnFacebook, shareOnTwitter);

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
    } // end submitRestaurantDetailTip()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param restaurantId DOCUMENT ME!
     * @param userRestaurantSavedFlag DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/save")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitSaveOrUnsaveRestaurant(@Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("restaurantid")
    String restaurantId,
        @FormParam("userrestaurantsavedflag")
    String userRestaurantSavedFlag) {
        super.processHttpHeaders(headers);

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;

        //check userRestaurarntSavedFlag is either 1 or 0
        try {
            Integer.parseInt(userRestaurantSavedFlag);
        } // end try
        catch (NumberFormatException nfe) {
            status = TSResponseStatusCode.INVALIDDATA.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);
            responseDone = true;

            return Response.status(status)
                           .header("userrestaurantsavedflag",
                (userRestaurantSavedFlag != null) ? userRestaurantSavedFlag
                                                  : TSConstants.EMPTY)
                           .entity(tsErrorObj).build();
        } // end catch

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
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

            restaurantBO.submitSaveOrUnsaveRestaurant(tsDataSource, connection,
                userId, restaurantId, userRestaurantSavedFlag);

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
    } // end submitSaveOrUnsaveRestaurant()
} // end RestaurantService
