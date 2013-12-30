//
//  UserDefault.h
//  TasteSync
//
//  Created by Victor on 12/21/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"
#import "TSCityObj.h"

#define IS_LOGIN    @"defaultIsLogin"
#define IS_NOTIFICATION    @"defaultIsNotification"
#define IS_LOCATION    @"defaultIsLogin"
#define CITY            @"city"
#define STATE           @"state"
#define EMAIL_ID    @"emailID"
#define PASSWORD    @"password"
#define User_EMAIL  @"User_EMAIL"
#define User_PASSWORD   @"User_PASSWORD"
#define User_FIRST_NAME @"User_FIRST_NAME"
#define User_LAST_NAME  @"User_LAST_NAME"
#define User_CITY   @"User_CITY"
#define User_STATE  @"User_STATE"
#define User_GENDER @"User_GENDER"
#define User_AVATAR @"User_AVATAR"
#define LOGIN_STATUS    @"LOGIN_STATUS"
#define UserLogID @"User_LOG_ID"
#define UserID @"User_ID"
#define IPADRESS @"IPAdress"
#define CITY_ID @"CITY_ID"
#define CITY_NAME @"CITY_NAME"
#define CITY_STATE @"CITY_STATE"
#define CITY_COUNTRY @"CITY_COUNTRY"
#define OAUTH_TOKEN @"OAUTH_TOKEN"
#define DEVICE_TOKEN @"DeviceToken"
#define USERDATA @"UserDATA"

@interface UserDefault : NSObject<NSCoding>
{
 
}

typedef enum _LoginStatus
{
    NotLogin            =   0,
    LoginViaFacebook    =   1,
    LoginViaEmailId     =   2
    
} LoginStatus;

@property (nonatomic, assign) int loginStatus;
@property (nonatomic, assign) BOOL isNotification;
@property (nonatomic, assign) BOOL isLocation;
@property (nonatomic, strong) NSString *emailID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *city,*state;
@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) TSCityObj *cityObj;
@property (nonatomic, strong) NSString *userLogID, *userID;
@property (nonatomic, strong) NSString *IPAdress;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *oauth_token;
@property (nonatomic, strong) NSString *userData;

+ (UserDefault *) userDefault;
- (void) update;
+ (void) update;
+ (void) resetValue;

@end
