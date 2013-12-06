package com.tastesync.services;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSErrorObj;
import com.tastesync.model.vo.HeaderDataVO;

import com.tastesync.oauth.bos.OAuthBO;
import com.tastesync.oauth.bos.OAuthBOImpl;
import com.tastesync.oauth.model.vo.OAuthDataExtInfoVO;

import com.tastesync.util.TSConstants;
import com.tastesync.util.TSResponseStatusCode;

import org.apache.log4j.Logger;

import org.codehaus.jackson.map.ObjectMapper;

import org.springframework.util.StringUtils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import java.sql.Connection;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.Response;


/**
 * Web Service class to expose common functionality related to "common" via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
public abstract class BaseService {
    /** Logger for this class */
    private static final Logger logger = Logger.getLogger(BaseService.class);

    /**
     * DOCUMENT ME!
     */
    public static Properties tsConfigProp = new Properties();

    static {
        try {
            if (1 != 1) {
                loadProperties();
            } // end if
        } // end try
        catch (TasteSyncException e) {
            e.printStackTrace();
        } // end catch
    }

    /**
     * DOCUMENT ME!
     */
    OAuthBO oauthBO = new OAuthBOImpl();

    /**
     * DOCUMENT ME!
     */
    public ObjectMapper mapper = new ObjectMapper();

    /**
     * DOCUMENT ME!
     */
    public boolean printDebugExtra = true;

    /**
     * DOCUMENT ME!
     *
     * @param tsDataSource DOCUMENT ME!
     * @param connection DOCUMENT ME!
     * @param identifierForVendor DOCUMENT ME!
     *
     * @throws TasteSyncException DOCUMENT ME!
     */
    public void deleteOAuthToken(TSDataSource tsDataSource,
        Connection connection, String identifierForVendor)
        throws TasteSyncException {
        try {
            oauthBO.deleteOAuthToken(tsDataSource, connection,
                identifierForVendor);
        } // end try
        catch (com.tastesync.oauth.exception.TasteSyncException e) {
            logger.error(e);
            throw new TasteSyncException(e.getMessage());
        } // end catch
    } // end deleteOAuthToken()

    /**
     * DOCUMENT ME!
     *
     * @param tsDataSource DOCUMENT ME!
     * @param connection DOCUMENT ME!
     * @param identifierForVendor DOCUMENT ME!
     * @param inputOauthToken DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     *
     * @throws TasteSyncException DOCUMENT ME!
     */
    public OAuthDataExtInfoVO getUserOAuthDataFrmDBBasedOnFromOAuthToken(
        TSDataSource tsDataSource, Connection connection,
        String identifierForVendor, String inputOauthToken)
        throws TasteSyncException {
        try {
            return oauthBO.getUserOAuthDataFrmDBBasedOnFromOAuthToken(tsDataSource,
                connection, identifierForVendor, inputOauthToken);
        } // end try
        catch (com.tastesync.oauth.exception.TasteSyncException e) {
            logger.error(e);
            throw new TasteSyncException(e.getMessage());
        } // end catch
    } // end getUserOAuthDataFrmDBBasedOnFromOAuthToken()

    /**
     * DOCUMENT ME!
     *
     * @param e DOCUMENT ME!
     * @param status DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public Response handleException(Exception e, int status) {
        return Response.status(status)
                       .header(TSConstants.EX_CLASS,
            e.getClass().getCanonicalName()).entity(e.getMessage()).build();
    } // end handleException()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     *
     * @throws TasteSyncException DOCUMENT ME!
     */
    public HeaderDataVO headerOauthDataChecks(HttpHeaders headers) {
        String identifierForVendor = null;

        if (headers.getRequestHeader("identifierForVendor") != null) {
            identifierForVendor = headers.getRequestHeader(
                    "identifierForVendor").get(0);
        } // end if

        String inputOauthToken = null;

        if (headers.getRequestHeader("ts_oauth_token") != null) {
            inputOauthToken = headers.getRequestHeader("ts_oauth_token").get(0);
        } // end if

        if ((identifierForVendor == null) || (inputOauthToken == null)) {
            return null;
        } // end if

        inputOauthToken = StringUtils.replace(inputOauthToken, "\r\n", "");

        HeaderDataVO headerDataVO = new HeaderDataVO(identifierForVendor,
                inputOauthToken);

        if (logger.isDebugEnabled()) {
            logger.debug("headerDataVO=" + headerDataVO.toString());
        } // end if

        return headerDataVO;
    } // end headerOauthDataChecks()

    /**
     * DOCUMENT ME!
     *
     * @throws TasteSyncException DOCUMENT ME!
     */
    private static void loadProperties() throws TasteSyncException {
        InputStream ifile = null;

        try {
            //ClassLoader loader = getClass().getClassLoader();
            //ifile = loader.getResourceAsStream("/Resources/config.properties");
            ifile = new FileInputStream(
                    "/Users/webonline/localroot/softwares/apps/tomcat/apache-tomcat/webapps/tsws/WEB-INF/classes/Resources/config.properties");
            //load a properties file
            tsConfigProp.load(ifile);
        } // end try
        catch (IOException ex) {
            logger.error(ex);
            throw new TasteSyncException(ex.getMessage());
        } // end catch
        finally {
            if (ifile != null) {
                try {
                    ifile.close();
                } // end try
                catch (Exception e) {
                    logger.error(e);
                } // end catch
            } // end if
        } // end finally
    } // end loadProperties()

    /**
     * DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public Response notAuthorised() {
        int status = TSResponseStatusCode.ERROR_UNAUTHORIZED.getValue();

        TSErrorObj tsErrorObj = new TSErrorObj();
        tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

        return Response.status(status).header("ts_oauth_token", "invalid")
                       .header("ts_oauth_token_msg",
            OAuthDataExtInfoVO.OAUTH_ERROR_CODE_DEFAULT_MSG)
                       .header("ts_oauth_token_msg_code",
            String.valueOf(OAuthDataExtInfoVO.OAUTH_ERROR_CODE_DEFAULT))
                       .entity(tsErrorObj).build();
    } // end notAuthorised()

    /**
     * DOCUMENT ME!
     *
     * @param oauthDataExtInfoVO DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    public Response notAuthorised(OAuthDataExtInfoVO oauthDataExtInfoVO) {
        int status = TSResponseStatusCode.ERROR_UNAUTHORIZED.getValue();

        TSErrorObj tsErrorObj = new TSErrorObj();
        tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);

        String tsOAuthMsg = OAuthDataExtInfoVO.OAUTH_ERROR_CODE_DEFAULT_MSG;
        String tsOAuthMsgcode = String.valueOf(OAuthDataExtInfoVO.OAUTH_ERROR_CODE_DEFAULT);

        if (oauthDataExtInfoVO == null) {
            tsOAuthMsgcode = String.valueOf(OAuthDataExtInfoVO.OAUTH_ERROR_CODE_UNKNOWN_USER_LOGIN);
            tsOAuthMsg = OAuthDataExtInfoVO.OAUTH_ERROR_CODE_UNKNOWN_USER_LOGIN_MSG;
        } else if (oauthDataExtInfoVO.getOauthDataVO() == null) {
            int oauthErrorCode = oauthDataExtInfoVO.getOauthErrorCode();
            tsOAuthMsgcode = String.valueOf(oauthErrorCode);
            //overwrite default msg
            tsOAuthMsg = oauthDataExtInfoVO.getDefaultOauthErrorCodeMsg();

            if (oauthErrorCode == OAuthDataExtInfoVO.OAUTH_ERROR_CODE_UNKNOWN_USER_LOGIN) {
                tsOAuthMsgcode = String.valueOf(oauthErrorCode);
                tsOAuthMsg = oauthDataExtInfoVO.getDefaultOauthErrorCodeMsg();
            } else if (oauthErrorCode == OAuthDataExtInfoVO.OAUTH_ERROR_CODE_USER_PROFILE_NOT_COMPLETED) {
                tsOAuthMsgcode = String.valueOf(oauthErrorCode);
                //overwrite default msg
                tsOAuthMsg = oauthDataExtInfoVO.getDefaultOauthErrorCodeMsg();
            }
        }

        return Response.status(status).header("ts_oauth_token", "invalid")
                       .header("ts_oauth_token_msg", tsOAuthMsg)
                       .header("ts_oauth_token_msg_code", tsOAuthMsgcode)
                       .entity(tsErrorObj).build();
    } // end notAuthorised()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     */
    public void processHttpHeaders(@Context
    HttpHeaders headers) {
        //validate , version check
        writeResponseheader(headers);
    } // end processHttpHeaders()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     */
    private void writeResponseheader(@Context
    HttpHeaders headers) {
        if (printDebugExtra) {
            Map<String, List<String>> map = headers.getRequestHeaders();

            if (logger.isDebugEnabled()) {
                logger.debug("Printing Response Header...\n");
            }

            for (Map.Entry<String, List<String>> entry : map.entrySet()) {
                if (logger.isDebugEnabled()) {
                    logger.debug("Key=" + entry.getKey() + " ,Value=" +
                        entry.getValue());
                }
            } // end for

            if (logger.isDebugEnabled()) {
                logger.debug("Writting of header...  Done");
            }
        } // end if
    } // end writeResponseheader()
} // end BaseService
