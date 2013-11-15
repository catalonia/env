package com.tastesync.servlet;

import com.tastesync.services.AskReplyService;
import com.tastesync.services.AutoPopulateService;
import com.tastesync.services.RestaurantService;
import com.tastesync.services.UserService;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.core.Application;


public class TasteSyncApp extends Application {
    HashSet<Object> singletons = new HashSet<Object>();

    public TasteSyncApp() {
    	
    	singletons.add(new UserService());
		singletons.add(new RestaurantService());
	 	singletons.add(new AskReplyService());
	  	singletons.add(new AutoPopulateService());
        
    }

    @Override
    public Set<Class<?>> getClasses() {
        HashSet<Class<?>> set = new HashSet<Class<?>>();

        return set;
    }

    @Override
    public Set<Object> getSingletons() {
        return singletons;
    }
}
