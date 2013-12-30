//
//  AppDelegate.h
//  TasteSync
//
//  Created by Victor on 12/18/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import "TabbarBaseVC.h"
#import "CFacebook.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CFacebookDelegate,UIAlertViewDelegate, RequestDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabbarBaseVC *tabbarBaseVC;
@property (strong, nonatomic) UITabBar *cTabbar;

@property (nonatomic, strong) id<CFacebookDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *arrDataFBFriends;
@property (nonatomic, strong) NSMutableArray *arrayAmbience;

@property (nonatomic, strong) NSMutableArray *arrWhoAreUWith, *arrOccasion, *arrTypeOfRestaurant, *arrCuisine, *arrPrice, *arrTheme;

@property (nonatomic, strong) NSMutableArray *arrDropdown, *arrayNeighberhood;

@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSMutableArray *arrayNotification;
@property (nonatomic, strong) NSMutableArray *arrayRestaurant;
@property (nonatomic, assign) int numberPage, numberPageRecomendation;

@property (nonatomic, strong) CLLocationManager *currentLocation;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, assign) BOOL askSubmited;
@property (nonatomic, assign) BOOL isHaveError;
@property (nonatomic, assign) BOOL stillOnApp;
@property (nonatomic, assign) BOOL reloadNotifycation;

- (void) showLogin;

- (void) showAskTab;
-(void)showAlertError;
- (void) loginFB:(id<CFacebookDelegate>) aDelegate;

- (void) showLoginDialog;

- (void) showRecomendTab;
@end
