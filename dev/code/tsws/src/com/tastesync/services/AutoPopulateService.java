package com.tastesync.services;

import com.tastesync.bos.AutoPopulateBO;
import com.tastesync.bos.AutoPopulateBOImpl;

import com.tastesync.common.utils.CommonFunctionsUtil;

import com.tastesync.db.pool.TSDataSource;

import com.tastesync.exception.TasteSyncException;

import com.tastesync.model.objects.TSErrorObj;
import com.tastesync.model.objects.TSLocationSearchCitiesObj;
import com.tastesync.model.objects.TSRestaurantBasicObj;
import com.tastesync.model.objects.TSRestaurantObj;
import com.tastesync.model.objects.TSUserProfileBasicObj;

import com.tastesync.util.TSConstants;
import com.tastesync.util.TSResponseStatusCode;

import org.apache.log4j.Logger;

import org.codehaus.jettison.json.JSONArray;

import java.sql.Connection;
import java.sql.SQLException;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;


/**
 * Web Service class to expose functionality related to "Pre / Auto Populate fields " via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
@Path("/populate")
@Consumes({MediaType.APPLICATION_JSON
})
@Produces({MediaType.APPLICATION_JSON
})
public class AutoPopulateService extends BaseService {
    /**
     * Logger for this class
     */
    private static final Logger logger = Logger.getLogger(AutoPopulateService.class);

    /**
     * DOCUMENT ME!
     */
    private AutoPopulateBO autoPopulateBO = new AutoPopulateBOImpl();

    //-- TODO: INCOMPLETE
    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/cuisinetier1")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateCuisineTier1(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateCuisineTier1(tsDataSource,
                    connection);

            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
    } // end populateCuisineTier1()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/cuisinetier2")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateCuisineTier2(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateCuisineTier2(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
    } // end populateCuisineTier2()

    //TODO check
    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/locationsearchterms")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSLocationSearchCitiesObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateLocationSearchTerms(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        List<TSLocationSearchCitiesObj> tsLocationSearchCitiesObjList = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            tsLocationSearchCitiesObjList = autoPopulateBO.populateLocationSearchTerms(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(tsLocationSearchCitiesObjList)
                           .build();
        } // end try
        catch (TasteSyncException e1) {
            logger.error(e1);
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
    } // end populateLocationSearchTerms()

    //-- -- -- -- -- -- -- -- -- -- -- -- populateMoodSearchTerms	-- -- -- -- -- -- -- -- -- -- -- -- 
    //-- -- -- -- Need standard solution for "Auto-complete" i.e. is it DB based or JQUERY etc	-- -- -- -- -- -- -- -- 
    /**
     * Order of the results: CuisineTier1 CuisineTier2
     * OccasionDescriptor PriceDescriptor ThemeDescriptor TypeofrestDescriptor
     * WhoareyouwithDescriptor
     *
     * @param headers DOCUMENT ME!
     *
     * @return list of arrays in the orders as mentioned above in description.
     */
    @GET
    @Path("/moodsearchterms")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateMoodSearchTerms(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = new JSONArray();

            JSONArray jsonArrayCuisineTier1 = autoPopulateBO.populateCuisineTier1(tsDataSource,
                    connection);

            if (jsonArrayCuisineTier1 != null) {
                jsonArray.put(jsonArrayCuisineTier1);
            } // end if

            JSONArray jsonArrayCuisineTier2 = autoPopulateBO.populateCuisineTier2(tsDataSource,
                    connection);

            if (jsonArrayCuisineTier2 != null) {
                jsonArray.put(jsonArrayCuisineTier2);
            } // end if

            JSONArray jsonArrayOccasionDescriptor = autoPopulateBO.populateOccasionDescriptor(tsDataSource,
                    connection);

            if (jsonArrayOccasionDescriptor != null) {
                jsonArray.put(jsonArrayOccasionDescriptor);
            } // end if

            JSONArray jsonArrayPriceDescriptor = autoPopulateBO.populatePriceDescriptor(tsDataSource,
                    connection);

            if (jsonArrayPriceDescriptor != null) {
                jsonArray.put(jsonArrayPriceDescriptor);
            } // end if

            JSONArray jsonArrayThemeDescriptor = autoPopulateBO.populateThemeDescriptor(tsDataSource,
                    connection);

            if (jsonArrayThemeDescriptor != null) {
                jsonArray.put(jsonArrayThemeDescriptor);
            } // end if

            JSONArray jsonArrayTypeofrestDescriptor = autoPopulateBO.populateTypeofrestDescriptor(tsDataSource,
                    connection);

            if (jsonArrayTypeofrestDescriptor != null) {
                jsonArray.put(jsonArrayTypeofrestDescriptor);
            } // end if

            JSONArray jsonArrayWhoareyouwithDescriptor = autoPopulateBO.populateWhoareyouwithDescriptor(tsDataSource,
                    connection);

            if (jsonArrayWhoareyouwithDescriptor != null) {
                jsonArray.put(jsonArrayWhoareyouwithDescriptor);
            } // end if

            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
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
    } // end populateMoodSearchTerms()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/occasion")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateOccasionDescriptor(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateOccasionDescriptor(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
            logger.error("populateOccasionDescriptor(HttpHeaders)", e);
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
    } // end populateOccasionDescriptor()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/price")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populatePriceDescriptor(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populatePriceDescriptor(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
    } // end populatePriceDescriptor()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param key DOCUMENT ME!
     * @param cityId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/restaurantSearchTerms")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    private Response populateRestaurantSearchTerms(
        @Context
    HttpHeaders headers, @FormParam("key")
    String key, @FormParam("cityid")
    String cityId) {
        super.processHttpHeaders(headers);

        List<TSRestaurantObj> listRestaurant = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            key = CommonFunctionsUtil.converStringAsNullIfNeeded(key);

            cityId = CommonFunctionsUtil.converStringAsNullIfNeeded(cityId);
            connection = tsDataSource.getConnection();
            listRestaurant = autoPopulateBO.populateRestaurantSearchTerms(tsDataSource,
                    connection, key, cityId);
            responseDone = true;

            return Response.status(status).entity(listRestaurant).build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error("populateRestaurantSearchTerms(HttpHeaders, String, String)",
                e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
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
    } // end populateRestaurantSearchTerms()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param key DOCUMENT ME!
     * @param cityId DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/suggestrestaurantnames")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSRestaurantBasicObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateSuggestedRestaurantNames(
        @Context
    HttpHeaders headers, @FormParam("key")
    String key, @FormParam("cityid")
    String cityId) {
        super.processHttpHeaders(headers);

        List<TSRestaurantBasicObj> tsRestaurantBasicObjList = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            key = CommonFunctionsUtil.converStringAsNullIfNeeded(key);

            cityId = CommonFunctionsUtil.converStringAsNullIfNeeded(cityId);
            connection = tsDataSource.getConnection();
            tsRestaurantBasicObjList = autoPopulateBO.populateSuggestedRestaurantNames(tsDataSource,
                    connection, key, cityId);
            responseDone = true;

            return Response.status(status).entity(tsRestaurantBasicObjList)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
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
    } // end populateSuggestedRestaurantNames()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/theme")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateThemeDescriptor(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateThemeDescriptor(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
    } // end populateThemeDescriptor()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/typeofrest")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateTypeofrestDescriptor(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateTypeofrestDescriptor(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
    } // end populateTypeofrestDescriptor()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     * @param userId DOCUMENT ME!
     * @param key DOCUMENT ME!
     * @param excludeFollowees DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @POST
    @Path("/usersearchterms")
    @org.codehaus.enunciate.jaxrs.TypeHint(TSUserProfileBasicObj.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateUserSearchTerms(@Context
    HttpHeaders headers, @FormParam("userid")
    String userId, @FormParam("key")
    String key, @FormParam("excludefollowees")
    String excludeFollowees) {
        super.processHttpHeaders(headers);

        List<TSUserProfileBasicObj> tsUserProfileBasicObjList = null;

        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            key = CommonFunctionsUtil.converStringAsNullIfNeeded(key);

            userId = CommonFunctionsUtil.converStringAsNullIfNeeded(userId);
            excludeFollowees = CommonFunctionsUtil.converStringAsNullIfNeeded(excludeFollowees);
            connection = tsDataSource.getConnection();
            tsUserProfileBasicObjList = autoPopulateBO.populateUserSearchTerms(tsDataSource,
                    connection, userId, key, excludeFollowees);
            responseDone = true;

            return Response.status(status).entity(tsUserProfileBasicObjList)
                           .build();
        } // end try
        catch (TasteSyncException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
        } // end catch
        catch (SQLException e) {
            logger.error(e);
            status = TSResponseStatusCode.ERROR.getValue();

            TSErrorObj tsErrorObj = new TSErrorObj();

            tsErrorObj.setErrorMsg(TSConstants.ERROR_USER_SYSTEM_KEY);
            responseDone = true;

            return Response.status(status)
                           .header(TSConstants.EX_CLASS,
                e.getClass().getCanonicalName()).entity(tsErrorObj).build();
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
    } // end populateUserSearchTerms()

    /**
     * DOCUMENT ME!
     *
     * @param headers DOCUMENT ME!
     *
     * @return DOCUMENT ME!
     */
    @GET
    @Path("/whoareyouwith")
    @org.codehaus.enunciate.jaxrs.TypeHint(JSONArray.class)
    @Consumes({MediaType.APPLICATION_FORM_URLENCODED
    })
    @Produces({MediaType.APPLICATION_JSON
    })
    public Response populateWhoareyouwithDescriptor(@Context
    HttpHeaders headers) {
        super.processHttpHeaders(headers);

        JSONArray jsonArray = null;
        int status = TSResponseStatusCode.SUCCESS.getValue();
        boolean responseDone = false;
        TSDataSource tsDataSource = TSDataSource.getInstance();
        Connection connection = null;

        try {
            connection = tsDataSource.getConnection();
            jsonArray = autoPopulateBO.populateWhoareyouwithDescriptor(tsDataSource,
                    connection);
            responseDone = true;

            return Response.status(status).entity(jsonArray.toString()).build();
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
            logger.error("populateWhoareyouwithDescriptor(HttpHeaders)", e);
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
    } // end populateWhoareyouwithDescriptor()
} // end AutoPopulateService
