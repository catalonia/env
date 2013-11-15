package com.tastesync.services;

import org.apache.log4j.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


/**
 * Web Service class to expose common functionality related to "browse" via different web service
 * methods
 * @author TasteSync
 * @version 0.1
 */
@Path("/browse")
@Consumes({MediaType.APPLICATION_JSON
} 
)
@Produces({MediaType.APPLICATION_JSON
} 
)
public class BrowseService extends BaseService {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(BrowseService.class);
} // end BrowseService
