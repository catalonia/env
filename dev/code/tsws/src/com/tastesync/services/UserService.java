package com.tastesync.services;

import com.tastesync.bos.UserBo;
import com.tastesync.bos.UserBoImpl;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSAboutObj;
import com.tastesync.model.objects.TSAskSubmitLoginObj;
import com.tastesync.model.objects.TSCityObj;
import com.tastesync.model.objects.TSErrorObj;
import com.tastesync.model.objects.TSFacebookUserDataObj;
import com.tastesync.model.objects.TSFriendObj;
import com.tastesync.model.objects.TSGlobalObj;
import com.tastesync.model.objects.TSInitObj;
import com.tastesync.model.objects.TSListFacebookUserDataObj;
import com.tastesync.model.objects.TSListNotificationSettingsObj;
import com.tastesync.model.objects.TSListPrivacySettingsObj;
import com.tastesync.model.objects.TSListSocialSettingObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSSuccessObj;
import com.tastesync.model.objects.TSUserObj;
import com.tastesync.model.objects.TSUserProfileObj;
import com.tastesync.model.objects.TSUserProfileRestaurantsObj;
import com.tastesync.model.response.UserResponse;
import com.tastesync.model.vo.HeaderDataVO;

import com.tastesync.oauth.bos.OAuthBO;
import com.tastesync.oauth.bos.OAuthBOImpl;
import com.tastesync.oauth.model.vo.OAuthDataExtInfoVO;

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
 * Web Service class to expose common functionality related to "user" via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
@Path("/user")
@Consumes({MediaType.APPLICATION_JSON
})
@Produces({MediaType.APPLICATION_JSON
})
public class UserService extends BaseService {
    /** Logger for this class */
    private static final Logger logger = Logger.getLogger(UserService.class);

    /**
     * oauth bo object - used for calling different methods exposed.
     */
    private OAuthBO oauthBo = new OAuthBOImpl();

    /**
     * user bo object - used for calling different methods exposed.
     */
    private UserBo userBo = new UserBoImpl();

    /**
     * Creates a new UserService object.
     */
    public UserService() {
        super();
    } // end UserService()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/checklogin")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response checkLogin(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings Success!");
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();
                userId = oauthUserId;

                // check user current status
            } // end if

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return notAuthorised();

            //return Response.status(TSResponseStatusCode.ERROR.getValue()).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return notAuthorised();

            //return Response.status(TSResponseStatusCode.ERROR.getValue()).entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end checkLogin()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param key DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/getCity")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSGlobalObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response getCity(@Context
    HttpHeaders headers, @FormParam("key")
    String key) {
        super.processHttpHeaders(headers);

        List<TSGlobalObj> result = null;
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

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();
                userId = oauthUserId;
            } // end if

            result = userBo.getCity(tsDataSource, connection, key);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(result).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end getCity()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/getHomeProfile")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserProfileObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response getHomeProfile(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSUserProfileObj userProfileObj = null;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                //its different
                //userId = oauthUserId;
            } // end if

            userProfileObj = userBo.getUserHomeProfile(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(userProfileObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end getHomeProfile()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param key DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/getUserCity")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSCityObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response getUserCity(@Context
    HttpHeaders headers, @FormParam("key")
    String key) {
        super.processHttpHeaders(headers);

        List<TSCityObj> neighbourhoodCityObj = null;
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

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();
                userId = oauthUserId;
            } // end if

            neighbourhoodCityObj = userBo.getCityName(tsDataSource, connection,
                    key);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(neighbourhoodCityObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end getUserCity()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userFBID DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/getUserObject")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSFacebookUserDataObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response getUserId(@Context
    HttpHeaders headers, @FormParam("userID")
    String userFBID) {
        super.processHttpHeaders(headers);

        TSFacebookUserDataObj tsFacebookUserDataObj = null;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userFBID = CommonFunctionsUtil.converStringAsNullIfNeeded(userFBID);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsFacebookUserDataObj = userBo.getUserId(tsDataSource, connection,
                    userFBID);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsFacebookUserDataObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end getUserId()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param friendFBId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/inviteFriend")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response inviteFriend(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("friendFBId")
    String friendFBId) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.inviteFriend(tsDataSource, connection, userId, friendFBId);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Invite Friend Successfully!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end inviteFriend()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/loginAccount")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response loginAccount(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            String result = userBo.loginAccount(tsDataSource, connection, userId);

            if (result != null) {
                TSSuccessObj tsSuccessObj = new TSSuccessObj();
                tsSuccessObj.setSuccessMsg(result);

                return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                               .entity(tsSuccessObj).build();
            } // end if
            else {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            } // end else
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end loginAccount()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param senderID DOCUMENT ME!
     * @param recipientID DOCUMENT ME!
     * @param content DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/sendMessageToUser")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response sendMessageToUser(@Context
    HttpHeaders headers, @FormParam("senderID")
    String senderID, @FormParam("recipientID")
    String recipientID, @FormParam("content")
    String content) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            senderID = CommonFunctionsUtil.converStringAsNullIfNeeded(senderID);
            recipientID = CommonFunctionsUtil.converStringAsNullIfNeeded(recipientID);
            content = CommonFunctionsUtil.converStringAsNullIfNeeded(content);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.sendMessageToUser(tsDataSource, connection, senderID,
                recipientID, content);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Sending succesfully!");

            try {
                CommonFunctionsUtil.execAsync(TSConstants.SEND_PUSH_NOTIFICATIONS_SCRIPT,
                    TSConstants.BASENAME_SEND_PUSH_NOTIFICATIONS_SCRIPT);
            } // end try
            catch (com.tastesync.common.exception.TasteSyncException e) {
                logger.error("sendMessageToUser(HttpHeaders, String, String, String)",
                    e);
            } // end catch

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end sendMessageToUser()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param statusUser DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/setStatus")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response setStatus(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("status")
    String statusUser) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.setStatus(tsDataSource, connection, userId, statusUser);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg(statusUser);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end setStatus()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param aboutId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showAboutTastesync")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSAboutObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showAboutTastesync(@Context
    HttpHeaders headers, @FormParam("AboutId")
    String aboutId) {
        super.processHttpHeaders(headers);

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

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            //TODO get aboutid for the userId!!
            TSAboutObj tsAboutObj = userBo.showAboutTastesync(tsDataSource,
                    connection, aboutId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsAboutObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showAboutTastesync()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param followerUserId DOCUMENT ME!
     * @param followeeUserId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showFollowStatus")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showFollowStatus(@Context
    HttpHeaders headers, @FormParam("followerUserId")
    String followerUserId, @FormParam("followeeUserId")
    String followeeUserId) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            followeeUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(followeeUserId);
            followerUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(followerUserId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            boolean followed = userBo.getFollowStatus(tsDataSource, connection,
                    followeeUserId, followerUserId);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();

            if (followed) {
                tsSuccessObj.setSuccessMsg("1");
            } // end if
            else {
                tsSuccessObj.setSuccessMsg("0");
            } // end else

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showFollowStatus()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showProfileFollowers")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserProfileObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showProfileFollowers(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        List<TSUserProfileObj> tsFacebookUserDataObjList = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsFacebookUserDataObjList = userBo.showProfileFollowers(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsFacebookUserDataObjList).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showProfileFollowers()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showProfileFollowing")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserProfileObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showProfileFollowing(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        List<TSUserProfileObj> tsFacebookUserDataObjList = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsFacebookUserDataObjList = userBo.showProfileFollowing(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsFacebookUserDataObjList).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showProfileFollowing()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showProfileFriends")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSFriendObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showProfileFriends(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSFriendObj tsfriend = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            List<TSUserObj> tsFacebookUserDataObjList = userBo.showProfileFriends(tsDataSource,
                    connection, userId);
            List<String> tsInviteFacebookUserDataObjList = userBo.showInviteFriends(tsDataSource,
                    connection, userId);

            tsfriend = new TSFriendObj();
            tsfriend.setFriendTasteSync(tsFacebookUserDataObjList);
            tsfriend.setInviteFriend(tsInviteFacebookUserDataObjList);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsfriend).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showProfileFriends()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param type DOCUMENT ME!
     * @param from DOCUMENT ME!
     * @param to DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showProfileRestaurants")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserProfileRestaurantsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showProfileRestaurants(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("type")
    int type, @FormParam("from")
    int from, @FormParam("to")
    int to) {
        super.processHttpHeaders(headers);

        List<TSUserProfileRestaurantsObj> userProfileRestaurants = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO Check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userProfileRestaurants = userBo.getUserProfileRestaurants(tsDataSource,
                    connection, userId, type, from, to);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(userProfileRestaurants).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showProfileRestaurants()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param key DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showRestaurantSuggestion")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showRestaurantSuggestion(@Context
    HttpHeaders headers, @FormParam("key")
    String key, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        List<TSRestaurantObj> tsRestaurantObjList = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            key = CommonFunctionsUtil.converStringAsNullIfNeeded(key);
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsRestaurantObjList = userBo.showRestaurantSuggestion(tsDataSource,
                    connection, key, userId);

            if (tsRestaurantObjList != null) {
                return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                               .entity(tsRestaurantObjList).build();
            } // end if
            else {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            } // end else
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showRestaurantSuggestion()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showSettingsNotifications")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSListNotificationSettingsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showSettingsNotifications(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSListNotificationSettingsObj tsNotificationSettingsObj = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsNotificationSettingsObj = userBo.showSettingsNotifications(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsNotificationSettingsObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showSettingsNotifications()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/getAllData")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSInitObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showSettingsNotifications(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        TSInitObj tsInitObj = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            tsInitObj = userBo.getAllData(tsDataSource, connection);

            String identifierForVendor = headers.getRequestHeader(
                    "identifierForVendor").get(0);

            if (logger.isDebugEnabled()) {
                logger.debug(
                    "showSettingsNotifications(HttpHeaders) - identifierForVendor=" +
                    identifierForVendor);
            }

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsInitObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showSettingsNotifications()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showSettingsPrivacy")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSListPrivacySettingsObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showSettingsPrivacy(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSListPrivacySettingsObj tsPrivacySettingsObj = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsPrivacySettingsObj = userBo.showSettingsPrivacy(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsPrivacySettingsObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showSettingsPrivacy()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showSettingsSocial")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSListSocialSettingObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showSettingsSocial(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSListSocialSettingObj tsSocialSettingsObj = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsSocialSettingsObj = userBo.showSettingsSocial(tsDataSource,
                    connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSocialSettingsObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showSettingsSocial()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param destUserId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/showTrustedFriend")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showTrustedFriend(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("destUserId")
    String destUserId) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            int choise = userBo.showTrustedFriend(tsDataSource, connection,
                    userId, destUserId);
            String retString = "";

            switch (choise) {
            case 0:
                retString = "not trust";

                break;

            case 1:
                retString = "trusted";

                break;

            case 2:
                retString = "no friend";

                break;
            } // end switch

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg(retString);

            if (choise != 3) {
                return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                               .entity(tsSuccessObj).build();
            } // end if
            else {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            } // end else
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showTrustedFriend()

    //TODO check if used?
    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/userdetails")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response showUserDetail(@Context
    HttpHeaders headers, @QueryParam("userId")
    String userId) {
        super.processHttpHeaders(headers);

        TSUserObj tsUserObj = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsUserObj = userBo.selectUser(tsDataSource, connection, userId);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsUserObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showUserDetail()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/allusers")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    private Response showUsersDetailsList(@Context
    HttpHeaders headers) {
        List<TSUserObj> tsUserObjList = null;

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

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            tsUserObjList = userBo.selectUsers(tsDataSource, connection);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsUserObjList).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end showUsersDetailsList()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param followeeUserId DOCUMENT ME!
     * @param followerUserId DOCUMENT ME!
     * @param statusFlag DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitFollowUserStatusChange")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitFollowUserStatusChange(@Context
    HttpHeaders headers, @FormParam("followeeUserId")
    String followeeUserId, @FormParam("followerUserId")
    String followerUserId, @FormParam("statusFlag")
    String statusFlag) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            followerUserId = CommonFunctionsUtil.converStringAsNullIfNeeded(followerUserId);
            statusFlag = CommonFunctionsUtil.converStringAsNullIfNeeded(statusFlag);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.followUserStatusChange(tsDataSource, connection,
                followeeUserId, followerUserId, statusFlag);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Setting succesfully!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitFollowUserStatusChange()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param email DOCUMENT ME!
     * @param password DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/login")
    @org.codehaus.enunciate.jaxrs.TypeHint(UserResponse.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitLogin(@Context
    HttpHeaders headers, @FormParam("email")
    String email, @FormParam("password")
    String password) {
        super.processHttpHeaders(headers);

        UserResponse userResponse = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            userResponse = userBo.login(tsDataSource, connection, email,
                    password);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(userResponse).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitLogin()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param list_user_profile DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitLoginFacebook")
    @org.codehaus.enunciate.jaxrs.TypeHint(UserResponse.class)
    @Consumes({MediaType.APPLICATION_JSON
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitLoginFacebook(@Context
    HttpHeaders headers, TSListFacebookUserDataObj list_user_profile) {
        super.processHttpHeaders(headers);

        if (logger.isDebugEnabled()) {
            logger.debug(
                "---------------------------------------------------------------------------");
            logger.debug(list_user_profile.toString());
        } // end if

        UserResponse userResponse = null;

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();

            String accessToken = null;

            if (list_user_profile == null) {
                logger.info("list_user_profile is NULL ");

                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            }

            accessToken = list_user_profile.getFbAccessToken();

            if (accessToken == null) {
                logger.info("FbAccessToken is NULL ");

                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            }

            super.processUserAndFriendDataBasedonFbSingleAccessToken(tsDataSource,
                connection, accessToken);

            //Get from the header
            String identifierForVendor = null;

            if (headers.getRequestHeader("identifierForVendor") != null) {
                identifierForVendor = headers.getRequestHeader(
                        "identifierForVendor").get(0);
            } // end if

            userResponse = userBo.login_fb(tsDataSource, connection,
                    list_user_profile, identifierForVendor);

            if ((userResponse == null) || (userResponse.getUser() == null)) {
                return notAuthorised();
            }

            String userId = userResponse.getUser().getUserId();

            //Get from the header
            String deviceType = null;

            if (headers.getRequestHeader("user-agent") != null) {
                deviceType = headers.getRequestHeader("user-agent").get(0);
            } // end if

            String oAuthToken = oauthBo.getOAuthToken(tsDataSource, connection,
                    identifierForVendor, userId, deviceType);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .header("ts_oauth_token", oAuthToken)
                           .entity(userResponse).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (com.tastesync.oauth.exception.TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitLoginFacebook()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userLogId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitLogout")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitLogout(@Context
    HttpHeaders headers, @FormParam("userLogId")
    String userLogId) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userLogId = CommonFunctionsUtil.converStringAsNullIfNeeded(userLogId);

            connection = tsDataSource.getConnection();

            //check logid is associated with the same userId
            String userId = userBo.getAutoUserLogByUserId(tsDataSource,
                    connection, userLogId);

            if (userId == null) {
                return notAuthorised();
            } // end if

            String oauthUserId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                if (!oauthUserId.equals(userId)) {
                    return notAuthorised();
                } // end if

                deleteOAuthToken(tsDataSource, connection,
                    headerDataVO.getIdentifierForVendor());
            } // end if

            userBo.logout(tsDataSource, connection, userLogId, userId);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Logout success!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitLogout()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param aboutMeText DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitMyProfileAboutMe")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitMyProfileAboutMe(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("Content")
    String aboutMeText) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            // if userId is null, error!
            if (userId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(TSResponseStatusCode.INVALIDDATA.getValue())
                               .header("userId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            aboutMeText = CommonFunctionsUtil.converStringAsNullIfNeeded(aboutMeText);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Updating succesfully!");
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            boolean submitMyProfileAboutMeResponseDone = userBo.submitMyProfileAboutMe(tsDataSource,
                    connection, userId, aboutMeText);

            if (submitMyProfileAboutMeResponseDone) {
                return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                               .entity(tsSuccessObj).build();
            } // end if
            else {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

                return Response.status(TSResponseStatusCode.ERROR.getValue())
                               .entity(tsErrorObj).build();
            } // end else
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitMyProfileAboutMe()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param order DOCUMENT ME!
     * @param desc DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitSettingsContactUs")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitSettingscontactUs(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("Contact_Order")
    String order, @FormParam("Contact_Desc")
    String desc) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            // if userId is null, error!
            if (userId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(TSResponseStatusCode.INVALIDDATA.getValue())
                               .header("userId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.submitSettingscontactUs(tsDataSource, connection, userId,
                order, desc);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings success!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitSettingscontactUs()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param askObj DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitSignupDetail")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_JSON
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitSignupDetail(@Context
    HttpHeaders headers, TSAskSubmitLoginObj askObj) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Uploading successfully!");
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
                askObj.setUserId(userId);
            } // end if

            userBo.submitSignupDetail(tsDataSource, connection, askObj);

            userBo.initUserSettings(tsDataSource, connection, askObj.getUserId());

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitSignupDetail()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param dest_user_id DOCUMENT ME!
     * @param trustedFriendStatus DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("submitTrustedFriendStatusChange")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitTrustedFriendStatusChange(
        @Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("destUserId")
    String dest_user_id,
        @FormParam("trustedFriendStatus")
    String trustedFriendStatus) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            //TODO
            // destUserId should be from user' friend list

            // if userId is null, error!
            if (userId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(TSResponseStatusCode.INVALIDDATA.getValue())
                               .header("userId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            dest_user_id = CommonFunctionsUtil.converStringAsNullIfNeeded(dest_user_id);
            trustedFriendStatus = CommonFunctionsUtil.converStringAsNullIfNeeded(trustedFriendStatus);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.submitTrustedFriendStatusChange(tsDataSource, connection,
                userId, dest_user_id, trustedFriendStatus);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Updating succesfully!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitTrustedFriendStatusChange()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param reportText DOCUMENT ME!
     * @param reportedUser DOCUMENT ME!
     * @param reportedByUser DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/report")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitUserReport(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("reportText")
    String reportText, @FormParam("reportedUser")
    String reportedUser, @FormParam("reportedByUser")
    String reportedByUser) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            // if userId is null, error!
            if (userId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(TSResponseStatusCode.INVALIDDATA.getValue())
                               .header("userId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            reportText = CommonFunctionsUtil.converStringAsNullIfNeeded(reportText);
            reportedUser = CommonFunctionsUtil.converStringAsNullIfNeeded(reportedUser);
            reportedByUser = CommonFunctionsUtil.converStringAsNullIfNeeded(reportedByUser);
            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.submitUserReport(tsDataSource, connection, userId,
                reportText, reportedUser, reportedByUser);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings Success!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitUserReport()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param reportedUserId DOCUMENT ME!
     * @param reason DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitUserReport")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response submitUserReport(@Context
    HttpHeaders headers, @FormParam("userId")
    String userId, @FormParam("reportedUserId")
    String reportedUserId, @FormParam("reason")
    String reason) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);

            // if userId is null, error!
            if (userId == null) {
                TSErrorObj tsErrorObj = new TSErrorObj();
                tsErrorObj.setErrorMsg(TSConstants.ERROR_INVALID_INPUT_DATA_KEY);

                return Response.status(TSResponseStatusCode.INVALIDDATA.getValue())
                               .header("userId", TSConstants.EMPTY)
                               .entity(tsErrorObj).build();
            } // end if

            connection = tsDataSource.getConnection();

            String oauthUserId = null;

            //TODO check
            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
            } // end if

            userBo.submitUserReport(tsDataSource, connection, userId,
                reportedUserId, reason);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Reported Successfully!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();
            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end submitUserReport()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param social_setting_obj DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitSettingsSocial")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_JSON
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response updateSettingsAutoPublishSettings(
        @Context
    HttpHeaders headers, TSListSocialSettingObj social_setting_obj) {
        super.processHttpHeaders(headers);

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

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
                social_setting_obj.setUserId(userId);
            } // end if

            userBo.updateSettingsAutoPublishSettings(tsDataSource, connection,
                social_setting_obj);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings success!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end updateSettingsAutoPublishSettings()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param notificationSetting DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitSettingsNotifications")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_JSON
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response updateSettingsNotifications(@Context
    HttpHeaders headers, TSListNotificationSettingsObj notificationSetting) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings Success!");
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
                notificationSetting.setUserId(userId);
            } // end if

            userBo.updateSettingsNotifications(tsDataSource, connection,
                notificationSetting);

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end updateSettingsNotifications()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param privacySettingObj DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/submitSettingsPrivacy")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSSuccessObj.class)
    @Consumes({MediaType.APPLICATION_JSON
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response updateSettingsPrivacy(@Context
    HttpHeaders headers, TSListPrivacySettingsObj privacySettingObj) {
        super.processHttpHeaders(headers);

        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        // BO - DO- DBQuery
        try {
            connection = tsDataSource.getConnection();

            String oauthUserId = null;
            String userId = null;

            if (TSConstants.OAUTH_SWTICHED_ON) {
                HeaderDataVO headerDataVO = headerOauthDataChecks(headers);

                if (headerDataVO == null) {
                    return notAuthorised();
                } // end if

                OAuthDataExtInfoVO oauthDataExtInfoVO = getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                        connection, headerDataVO.getIdentifierForVendor(),
                        headerDataVO.getInputOauthToken());

                if ((oauthDataExtInfoVO == null) ||
                        (oauthDataExtInfoVO.getOauthDataVO() == null)) {
                    return notAuthorised(oauthDataExtInfoVO);
                } // end if

                oauthUserId = oauthDataExtInfoVO.getOauthDataVO().getUserId();

                userId = oauthUserId;
                privacySettingObj.setUserId(userId);
            } // end if

            userBo.updateSettingsPrivacy(tsDataSource, connection,
                privacySettingObj);

            TSSuccessObj tsSuccessObj = new TSSuccessObj();
            tsSuccessObj.setSuccessMsg("Settings success!");

            return Response.status(TSResponseStatusCode.SUCCESS.getValue())
                           .entity(tsSuccessObj).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

            return Response.status(TSResponseStatusCode.ERROR.getValue())
                           .entity(tsErrorObj).build();
        } // end catch
        finally {
            tsDataSource.closeConnection(connection);
        } // end finally
    } // end updateSettingsPrivacy()
} // end UserService
