package com.tastesync.common;

public interface GlobalVariables {
	public static final String WEBSITE = "http://54.225.93.162/";
	public static final String SERVER_ROOT = "C://AppServ/www/";
	public static final String  USER_IMAGE_FOLDER = "web_services/images/users/";
	
	public static final String  LINK_DIRECT_USER_IMAGE = WEBSITE + USER_IMAGE_FOLDER;
	public static final String  UPLOADED_USER_FILE_PATH = SERVER_ROOT + USER_IMAGE_FOLDER;
	
	public static final String  APP_NAME = "TasteSync";
	public static final String  APP_NAME_TITLE = "[" + APP_NAME + "]";
	
	public static final String  NO_REPLY_EMAIL = "no-reply@tastesync.com";
	
	public static int RESULTS_PER_PAGE = 20;			//For pagination
	
	public static final String  FB_APP_ID = "491464770909746"; 
	public static final String  FB_APP_SECRET = "86896d618ec06323bbdf8dd5bd2ca82d";
	
	public static final String  DEFAULT_CITY_ID = "1";
	public static final String  DEFAULT_CITY_NAME = "Anchorage";
	public static final String  DEFAULT_STATE = "AK";
	public static final String  DEFAULT_COUNTRY = "us";
	
	public static final String  DEFAULT_RESTAURANT_ID = "0"; 	//For Story table
	
	public static final String  FB_DATA_API = "FB_DATA_API";
	public static final String  FB_NAME = "NAME";
	public static final String  FB_FIRST_NAME = "FIRST_NAME";
	public static final String  FB_MIDDLE_NAME = "MIDDLE_NAME";
	public static final String  FB_LAST_NAME = "LAST_NAME";
	public static final String  FB_GENDER = "GENDER";
	public static final String  FB_LOACALE = "LOCALE";
	public static final String  FB_LINK = "LINK";
	public static final String  FB_USERNAME = "USERNAME";
	public static final String  FB_AGE_RANGE = "AGE_RANGE";
	public static final String  FB_BIRTHDAY = "BIRTHDAY";
	public static final String  FB_THIRD_PARTY_ID = "THIRD_PARTY_ID";
	public static final String  FB_FRIENDLISTS = "FRIENDLISTS";
	public static final String  FB_INSTALLED = "INSTALLED";
	public static final String  FB_TIMEZONE = "TIMEZONE";
	public static final String  FB_UPDATE_TIME = "UPDATE_TIME";
	public static final String  FB_VERIFIED = "VERIFIED";
	public static final String  FB_DEVICES = "DEVICES";
	public static final String  FB_EMAIL = "EMAIL";
	public static final String  FB_HOMETOWN = "HOMETOWN";
	public static final String  FB_LOCATION = "LOCATION";
	public static final String  FB_PICTURE = "PICTURE";
	public static final String  FB_RELATIONSHIP_STATUS = "RELATIONSHIP_STATUS";
	public static final String  FB_CHECKINS = "CHECKINS";
	public static final String  FB_FRIENDS = "FRIENDS";
	public static final String  FB_LIKES = "LIKES";
	public static final String  FB_PERMISSIONS = "PERMISSIONS";
	
	public static final String  NATIVE_CUISINE = "Native";
	public static final String  FAV_CUISINE = "Favourite";
	
	public static final String  RECO_TRUSTED_TYPE_USER = "user";
	public static final String  RECO_TRUSTED_TYPE_SYSTEM = "system";
	
	public static final String  SEARCH_ASK_CONTENT_CUISINE = "cu";
	public static final String  SEARCH_ASK_CONTENT_OCCASION = "oc";
	public static final String  SEARCH_ASK_CONTENT_WHO_ARE_YOU_WITH = "wh";
	public static final String  SEARCH_ASK_CONTENT_PRICE = "pr";
	public static final String  SEARCH_ASK_CONTENT_THEME = "th";
	public static final String  SEARCH_ASK_CONTENT_TYPE_OF_RESTAURANT = "ty";
	public static final String  SEARCH_ASK_CONTENT_LOCATION = "lo";
	public static final String  SEARCH_ASK_CONTENT_RATING = "ra";
	public static final String  SEARCH_ASK_CONTENT_IS_SAVED = "issaved";
	public static final String  SEARCH_ASK_CONTENT_IS_FAVS = "isfavs";
	public static final String  SEARCH_ASK_CONTENT_IS_DEALS = "isdeals";
	
	public static final String  STORY_USER_JOIN_TASTESYNC = "JTS";
	public static final String  STORY_USER_ADDED_CUISINE = "AC";
	public static final String  STORY_USER_FOLLOWED_SOMEONE = "FOL";
	public static final String  STORY_USER_ADDED_FAVOURITE_SPOT = "AFS";
	public static final String  STORY_USER_ADDED_TRUSTED_FRIEND = "ATF";
	public static final String  STORY_ASKED_USER_FOR_A_RECOMMENDATION = "ARC";
	public static final String  STORY_REVIEWED_A_RESTAURANT = "REV";
	public static final String  STORY_SAVED_A_RESTAURANT = "SAV";
	
	public static final String  RESTAURANT_ULTIMATE_SOURCE_NAME = "foursquare for iPhone";
	
	public static final int RESTAURANT_PROFILE_DETAIL_TYPE_ALL = 0,
			RESTAURANT_PROFILE_DETAIL_TYPE_FAV = 1,
			RESTAURANT_PROFILE_DETAIL_TYPE_RECO = 2,
			RESTAURANT_PROFILE_DETAIL_TYPE_SAVED = 3,
			RESTAURANT_PROFILE_DETAIL_TYPE_TIPS = 4;
}
