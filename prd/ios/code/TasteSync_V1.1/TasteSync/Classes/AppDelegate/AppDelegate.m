//
//  AppDelegate.m
//  TasteSync
//
//  Created by Victor on 12/18/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonHelpers.h"
#import "LoginVC.h"
#import "TSGlobalObj.h"
#import "Flurry.h"
#import "UserDefault.h"
#import "AskObject.h"
#import "Reachability.h"

NSString *const SessionStateChangedNotification = @"com.facebook.CFacebook:SessionStateChangedNotification";


@implementation AppDelegate

@synthesize tabbarBaseVC,window,delegate,arrDataFBFriends,
arrayNotification, arrayShuffle,
askSubmited=_askSubmited;


#pragma mark - AppDelegate Function

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Flurry code starts
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"XBJR4NPGCB47HF8JK2GJ"];
    //Flurry code ends
        
        if([CLLocationManager locationServicesEnabled]){
            self.currentLocation = [[CLLocationManager alloc] init];
            self.currentLocation.delegate = self;
            self.currentLocation.desiredAccuracy = kCLLocationAccuracyBest;
            [self.currentLocation startUpdatingLocation];
        }else
        {
            [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Share your location with Tastesync to find nearby restaurants." delegate:nil tag:100];
        }
        

        if ([UserDefault userDefault].isNotification != YES) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TasteSync Would Like to Send You Push Notifications" message:MSG_NOTIFICATION delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
            alert.tag = 1;
            [alert show];
        }
        
        //[UserDefault userDefault].oauth_token = @"";
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        
        [UserDefault update];
        
        [self initData];
        [NSThread detachNewThreadSelector:@selector(requestData) toTarget:self withObject:nil];
        [NSThread detachNewThreadSelector:@selector(requestCity) toTarget:self withObject:nil];

        if ([UserDefault userDefault].userID == nil) {
            [self showLogin];
        }
        else
        {
            [Flurry setUserID:[UserDefault userDefault].userID];
            [NSThread detachNewThreadSelector:@selector(parseFriend) toTarget:self withObject:nil];
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus != NotReachable)
            {
                CRequest* request = [[CRequest alloc]initWithURL:@"checklogin" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:nil];
                [request setFormPostValue:@"" forKey:@""];
                request.delegate = self;
                [request startFormRequest];
                
                CRequest* request2 = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2 WithView:nil];
                request2.delegate = self;
                [request2 setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
                [request2 startFormRequest];
            }
            [self showAskTab];
            
        }
    self.stillOnApp = YES;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    self.location = newLocation;
    [self.currentLocation stopUpdatingLocation];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"zoom in");
    self.stillOnApp = NO;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        if ([UserDefault userDefault].user != nil) {
            CRequest* request = [[CRequest alloc]initWithURL:@"setStatus" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:nil];
            request.delegate = self;
            [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
            [request setFormPostValue:@"n" forKey:@"status"];
            [request startFormRequest];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"zoom out");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus != NotReachable) {
        if ([UserDefault userDefault].user != nil) {
            CRequest* request = [[CRequest alloc]initWithURL:@"setStatus" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:nil];
            request.delegate = self;
            [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
            [request setFormPostValue:@"y" forKey:@"status"];
            [request startFormRequest];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    
    
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        //       [FBSession.activeSession close];
    }
}

-(void)initData
{
    self.arrCuisine = [[NSMutableArray alloc] init];
    self.arrOccasion = [[NSMutableArray alloc] init];
    self.arrPrice = [[NSMutableArray alloc] init];
    self.arrTheme   = [[NSMutableArray alloc] init];
    self.arrRate    = [[NSMutableArray alloc] init];
    self.arrTypeOfRestaurant = [[NSMutableArray alloc] init];
    self.arrWhoAreUWith = [[NSMutableArray alloc] init];
    self.arrDropdown = [[NSMutableArray alloc] init];
    self.arrDataFBFriends = [[NSMutableArray alloc] init];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    debug(@"application openURL -> %@ and sourceApplication -> %@ ",url, sourceApplication);
    
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark - Init Data

// init static data


# pragma mark - global's function


//- (void) getNotifications
//{
//    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//    
//    debug(@"AppDelegate -> getNotifications in background thread");
//    self.globalNotification = [[GlobalNotification alloc] initWithALlType];
//    [self.globalNotification requestData];
//    // });
//}
-(void)parseFriend
{
    NSDictionary* dicFriend = [[CommonHelpers readStringFromFile] objectFromJSONString];
    NSArray* array = [dicFriend objectForKey:@"Friend"];
    for (NSDictionary* dic in array) {
        UserObj* user = [[UserObj alloc]init];
        user.uid                    = [dic objectForKey:@"id"];
        user.firstname              = [dic objectForKey:@"firstname"];
        user.middle_name              = [dic objectForKey:@"middle_name"];
        user.lastname               = [dic objectForKey:@"lastname"];
        user.avatarUrl              = [dic objectForKey:@"avatarUrl"];
        user.email                  = [dic objectForKey:@"email"];
        user.name                   = [dic objectForKey:@"name"];
        user.state                  = [dic objectForKey:@"state"];
        user.city                   = [dic objectForKey:@"city"];
        [self.arrDataFBFriends addObject:user];
    }
}
- (void)requestCity
{
    @autoreleasepool
    {
        NSString* response = [CommonHelpers getCityString];
        
        NSLog(@"Response: %@",response);
        
        NSArray* array = [response objectFromJSONString];
        
        //parse cuisine 1
        self.arrayNeighberhood = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in array) {
            AskObject* askObject = [[AskObject alloc]init];
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.uid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"] ];
            global.name = [dic objectForKey:@"name"];
            global.type = GlobalDataCity;
            NSDictionary* name = [dic objectForKey:@"city"];
            TSCityObj* cityObj = nil;
            if (name != (id)[NSNull null]) {
                cityObj = [[TSCityObj alloc]init];
                cityObj.uid = [NSString stringWithFormat:@"%@", [name objectForKey:@"cityId"]];
                if ([cityObj.uid isEqualToString:global.uid]) {
                    cityObj.neighbourhoodID = @"";
                }
                else
                    cityObj.neighbourhoodID = global.uid;
                cityObj.country = [name objectForKey:@"country"];
                cityObj.stateName = [name objectForKey:@"state"];
                cityObj.cityName = [name objectForKey:@"city"];
            }
            global.cityObj = cityObj;
            askObject.object = global;
            askObject.selected = NO;
            [self.arrayNeighberhood addObject:askObject];
        }
    }
    NSLog(@"self.arrayNeighberhood: %d"                     , [self.arrayNeighberhood count]);
}
- (void)requestData
{
    @autoreleasepool
    {
        NSString* response = [CommonHelpers getJSONString];
        
        NSLog(@"Response: %@",response);
        
        NSDictionary* dic = [response objectFromJSONString];
        
        //parse cuisine 1
        NSArray* arrayCuisine1 = [dic objectForKey:@"cuisine1"];
        for (NSDictionary* dic in arrayCuisine1) {
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            obj.type = GlobalDataCuisine_1;
            obj.uid = [dic objectForKey:@"id"];
            obj.name = [dic objectForKey:@"name"];
            obj.imageURL = [dic objectForKey:@"tilePicture"];
            [self.arrCuisine addObject:obj];
        }
        
        //parse cuisine 2
        NSArray* arrayCuisine2 = [dic objectForKey:@"cuisine2"];
        for (NSDictionary* dic in arrayCuisine2) {
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            obj.type = GlobalDataCuisine_2;
            obj.uid = [dic objectForKey:@"id"];
            obj.name = [dic objectForKey:@"name"];
            obj.imageURL = [dic objectForKey:@"tilePicture"];
            [self.arrDropdown addObject:obj];
        }
        
        //parse occasion
        self.arrayAmbience = [[NSMutableArray alloc]init];
        NSArray* arrayData = [dic objectForKey:@"ambience"];
        for (NSDictionary* dic in arrayData) {
            NSString* type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            if ([type isEqualToString:@"occasion"]) {
                obj.type = GlobalDataOccasion;
                obj.uid = [dic objectForKey:@"id"];
                obj.name = [dic objectForKey:@"name"];
                obj.imageURL = [dic objectForKey:@"tilePicture"];
                [self.arrOccasion addObject:obj];
            }
            if ([type isEqualToString:@"theme"]) {
                obj.type = GlobalDataTheme;
                obj.uid = [dic objectForKey:@"id"];
                obj.name = [dic objectForKey:@"name"];
                obj.imageURL = [dic objectForKey:@"tilePicture"];
                [self.arrTheme addObject:obj];
            }
            if ([type isEqualToString:@"typeOfRest"]) {
                
                obj.type = GlobalDataTypeOfRestaurant;
                obj.uid = [dic objectForKey:@"id"];
                obj.name = [dic objectForKey:@"name"];
                obj.imageURL = [dic objectForKey:@"tilePicture"];
                [self.arrTypeOfRestaurant addObject:obj];
            }
            [self.arrayAmbience addObject:obj];
        }
        
        //parse price
        NSArray* arrayPrice = [dic objectForKey:@"price"];
        for (NSDictionary* dic in arrayPrice) {
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            obj.type = GlobalDataPrice;
            obj.uid = [dic objectForKey:@"id"];
            obj.name = [dic objectForKey:@"name"];
            obj.imageURL = [dic objectForKey:@"tilePicture"];
            [self.arrPrice addObject:obj];
        }
        
        
        
        //parse whoAreYou
        NSArray* arrayWhoAreYou = [dic objectForKey:@"whoAreYou"];
        for (NSDictionary* dic in arrayWhoAreYou) {
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            obj.type = GlobalDataWhoAreUWith;
            obj.uid = [dic objectForKey:@"id"];
            obj.name = [dic objectForKey:@"name"];
            obj.imageURL = [dic objectForKey:@"tilePicture"];
            [self.arrWhoAreUWith addObject:obj];
        }
        
        //parse Rate
        NSArray* arrayRate = [dic objectForKey:@"rate"];
        for (NSDictionary* dic in arrayRate) {
            AskObject* askObject = [[AskObject alloc]init];
            TSGlobalObj* obj = [[TSGlobalObj alloc]init];
            obj.type = GlobalDataRate;
            obj.uid = [dic objectForKey:@"id"];
            obj.name = [dic objectForKey:@"name"];
            askObject.object = obj;
            askObject.selected = NO;
            
            
            [self.arrRate addObject:askObject];
        }
        
        NSLog(@"arrCuisine: %d"                     , [self.arrCuisine count]);
        NSLog(@"arrOccasion: %d"                  , [self.arrOccasion count]);
        NSLog(@"arrPrice: %d"                         , [self.arrPrice count]);
        NSLog(@"arrTheme: %d"                      , [self.arrTheme count]);
        NSLog(@"arrTypeOfRestaurant: %d"   , [self.arrTypeOfRestaurant count]);
        NSLog(@"arrWhoAreUWith: %d"          , [self.arrWhoAreUWith count]);
        NSLog(@"arrDropdown: %d"                 , [self.arrDropdown count]);
    }
}

- (void) showLogin
{
    
    [UserDefault userDefault].userLogID = nil;
    [UserDefault userDefault].user = nil;
    [UserDefault userDefault].userID = nil;
    [UserDefault update];
    [CommonHelpers appDelegate].isHaveError = NO;
    [CommonHelpers appDelegate].errorMessage = @"";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [CommonHelpers setBottomValue:@"0"];
    [UserDefault userDefault].oauth_token = nil;
    [UserDefault update];
    
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    UINavigationController *rootCtr = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = rootCtr;
}

-(void)showAlertError
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"TasteSync" message:[CommonHelpers appDelegate].errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.tag = 3;
    [alert show];
}

- (void) showAskTab
{
    self.tabbarBaseVC = [[TabbarBaseVC alloc] init];
    self.window.rootViewController = self.tabbarBaseVC;
}

- (void) showRecomendTab
{
    self.tabbarBaseVC = [[TabbarBaseVC alloc] initWithRecomend];
    self.window.rootViewController = self.tabbarBaseVC;
}

- (void) loginFB:(id<CFacebookDelegate>) aDelegate
{
    
    self.delegate = aDelegate;
    
    if (![self openSessionWithAllowLoginUI:NO]) {
        
        debug(@"begin login with LoginUI");
        [self openSessionWithAllowLoginUI:YES];
    }
}



- (void)sessionStateChanged:(FBSession *)session  state:(FBSessionState)state error:(NSError *)error
{
    
    NSLog(@"sessionStateChanged");
    
    
    switch (state) {
        case FBSessionStateOpen: {
            
            NSLog(@"FBSessionStateOpen");
            
            //            [self.delegate cFacebookDidFinish:nil withTag:CFacebookTagActionLogin];
            [self.delegate cFacebook:nil didFinish:nil tagAction:CFacebookTagActionLogin];
            //            [self populateUserDetails];
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
        }
            break;
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
            
            break;
        case FBSessionStateClosedLoginFailed:
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            NSLog(@"FBSessionStateClosedLoginFailed");
            
            [self showLogin];
            
            break;
        default:
            
            NSLog(@"default");
            
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SessionStateChangedNotification
                                                        object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_friends",
                            @"user_location",
                            @"user_hometown",
                            @"user_birthday",
                            @"friends_birthday",
                            @"friends_hometown",
                            @"friends_location",
                            @"email",
                            @"user_likes",
                            @"user_checkins",
                            @"user_photos",
                            nil];
    

    

    
    
    
    
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                     }];
}




#pragma mark - CFacebookDelegate

- (void) cFacebook:(CFacebook *)aCFacebook didFinish:(id)anObj tagAction:(int)aTag
{
    switch (aTag) {
        case CFacebookTagActionError:
            debug(@"AppDelegate -> CFacebookTagActionError");
            break;
            
        case CFacebookTagActionLogin:
        {
            debug(@"AppDelegate -> CFacebookTagActionLogin");
            
            UserDefault *userDefault = [UserDefault userDefault];
            userDefault.loginStatus = LoginViaFacebook;
            [UserDefault update];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void) showLoginDialog
{
    [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"You should login to use this function" delegate:self tag:1];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
        if (buttonIndex==1) {
            [UserDefault userDefault].isNotification = YES;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        else
        {
            [UserDefault userDefault].isNotification = NO;
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        }
        
    }
    if (alertView.tag == 3) {
        [self showLogin];
    }
    if (alertView.tag == 4) {
        if (buttonIndex == 1) {
            self.reloadNotifycation = YES;
            [[CommonHelpers appDelegate].tabbarBaseVC actionRecommendations];
        }
    }
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    if (key == 2) {
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            [self.arrDataFBFriends addObject:userObject];
        }
    }
}

#pragma mark Push Notifycation
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //Removing the brackets from the device token
    NSString *tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"device_token"];
    NSString *tokenStr = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"device_token : %@",tokenStr);
    if (tokenStr != nil) {
        [UserDefault userDefault].deviceToken = tokenStr;
        [UserDefault update];
    }
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (self.stillOnApp) {
        NSDictionary* dic = [userInfo objectForKey:@"aps"];
        NSString* str = [dic objectForKey:@"alert"] ;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"TasteSync" message:str delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Read",nil];
        alert.tag = 4;
        [alert show];
    }
    else
    {
        [[CommonHelpers appDelegate] showRecomendTab];
        self.stillOnApp = YES;

    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
@end
