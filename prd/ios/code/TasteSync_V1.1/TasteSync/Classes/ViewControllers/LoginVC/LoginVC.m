//
//  LoginVC.m
//  TasteSync
//
//  Created by Victor NGO on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "LoginVC.h"
#import "LoginScreenVC.h"
#import "GlobalVariables.h"
#import "CommonHelpers.h"
#import "CFacebook.h"
#import "UserDefault.h"
#import <CoreLocation/CoreLocation.h>
#import "ConfigProfileVC.h"
#import "JSONKit.h"
#import "CRequest.h"
#import "TSGlobalObj.h"
#import "GlobalNotification.h"
#import "SBJson4Writer.h"
#import "Reachability.h"
#import "Flurry.h"

@interface LoginVC ()<UIAlertViewDelegate,CFacebookDelegate,RequestDelegate>
{
    __weak IBOutlet UIView *coverView;
    UserDefault *userDefault;
    CFacebook *facebook;
    BOOL isPushnotify;
    NSString* isHaveAccount;
}


- (IBAction)actionConnectWithFacebook:(id)sender;

- (IBAction)actionCreateProfile:(id)sender;

- (IBAction)actionSkipThis:(id)sender;

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isPushnotify = NO;
    }
    return self;
}
- (id)initWithPushNotify
{
    self = [super initWithNibName:@"LoginVC" bundle:nil];
    if (self) {
        isPushnotify = YES;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    [CommonHelpers setBackgroudImageForView:self.view];
    [CommonHelpers setBackgroudImageForView:coverView];
    //    [CommonHelpers clearUserDefault];
    [UserDefault resetValue];
    userDefault = [UserDefault userDefault];
    facebook = [[CFacebook alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    coverView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [CommonHelpers showInfoAlertConnectInternet];
    }
    
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self actionConnectWithFacebook:nil];
    }
}



#pragma mark - IBAction define

- (IBAction)actionConnectWithFacebook:(id)sender
{
    
    debug(@"actionConnectWithFacebook");
    
    //[facebook getUserInfo:self tagAction:CFacebookTagActionGetUserInfo];
    
    [facebook getUserFriends:self tagAction:CFacebookTagActionGetFriendsInfo];
    
    
}

- (IBAction)actionCreateProfile:(id)sender
{
    debug(@"actionCreateProfile");
    LoginScreenVC *loginScreenVC = [[LoginScreenVC alloc] initWithNibName:@"LoginScreenVC" bundle:nil];
    [self.navigationController pushViewController:loginScreenVC animated:YES];
    
    debug(@"LoginVC -actionCreateProfile - create test data - remove in UAT ");
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        UserObj  *obj = [[UserObj alloc] init];
        switch (i) {
            case 0:
            {
                obj.firstname = @"Anna";
                obj.lastname = @"Nguyen";
            }
                break;
            case 1:
            {
                obj.firstname = @"Brea";
                obj.lastname = @"Tran";
            }
                break;
            case 2:
            {
                obj.firstname = @"Chi";
                obj.lastname = @"Le";
            }
                break;
            case 3:
            {
                obj.firstname = @"Duong";
                obj.lastname = @"Thai";
            }
                break;
            case 4:
            {
                obj.firstname = @"Victor";
                obj.lastname = @"Ngo";
            }
                break;
            case 5:
            {
                obj.firstname = @"Flex";
                obj.lastname = @"Alexx";
            }
                break;
                
            default:
            {
                obj.firstname = [NSString stringWithFormat:@"Thuong %d",i];
                obj.lastname = @"Vo";
            }
                break;
                
        }
        obj.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
        //obj.uid = i+1;
        
        [arr addObject:obj];
    }
    
    [CommonHelpers appDelegate].arrDataFBFriends = arr;
}

- (IBAction)actionSkipThis:(id)sender
{
    debug(@"actionSkipThis");
    userDefault.loginStatus = NotLogin;
    [UserDefault update];
    [[CommonHelpers appDelegate] showAskTab];
    
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
        if (buttonIndex==1) {
            userDefault.isNotification = YES;
            [userDefault update];
        }
        
    }else if(alertView.tag == 100)
    {
        debug(@"Open Settings");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
    }
    else
    {
        [self hideCoverView];
    }
    
    
}

# pragma mark - Others

- (void) hideCoverView
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         coverView.frame=CGRectMake(-320, 0, 320, 480);
                     }
                     completion:^(BOOL finished){
                         debug(@"hide done");
                         
                     }];
    
}

#pragma mark - CFacebookDelegate

- (void) cFacebook:(CFacebook *)aCFacebook didFinish:(id)anObj tagAction:(int)aTag
{
    debug(@"LoginVC -> cFacebookDidFinish tag -> %d",aTag);
    switch (aTag) {
        case CFacebookTagActionError:
        {
            debug(@"LoginVC -> CFacebookTagActionError");
            
        }
            break;
            
        case CFacebookTagActionGetUserInfo:
        {
            userDefault.loginStatus = LoginViaFacebook;
            UserObj *userObj = (UserObj *) anObj;
            userObj.city = userDefault.city;
            userObj.state = userDefault.state;
            userDefault.user = userObj;
            [UserDefault update];
            NSLog(@"Email: %@",userDefault.user.email);
            
            ConfigProfileVC *vc = [[ConfigProfileVC alloc] initWithNibName:@"ConfigProfileVC" bundle:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
            
        case CFacebookTagActionGetFriendsInfo:
        {
            userDefault.loginStatus = LoginViaFacebook;
            
            NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];
            
            if ([UserDefault userDefault].deviceToken != nil) {
                [nameElements setObject:[UserDefault userDefault].deviceToken forKey:@"device_token"];
            }
            else
            {
                [nameElements setObject:@"" forKey:@"device_token"];
            }
            //[nameElements setObject:[CommonHelpers getJSONUserObj:userDefault.user] forKey:@"user_profile_current"];
            
            //NSMutableArray* array= [[CommonHelpers appDelegate] arrDataFBFriends];
            NSMutableArray* dictionnary = [[NSMutableArray alloc] init];
            for (UserObj *userObj in (NSMutableArray*)anObj) {
                [dictionnary addObject:userObj.uid];
            }
            
            //[nameElements setObject:dictionnary forKey:@"list_user_profile_fb"];
            NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
            [nameElements setObject:fbAccessToken forKey:@"fbAccessToken"];
            
            NSString* jsonString = [nameElements JSONString];
            NSLog(@"%@",jsonString);
            
            
            NSMutableDictionary *nameFriendElements = [NSMutableDictionary dictionary];
            NSMutableArray* dictionnaryObj = [[NSMutableArray alloc] init];
            for (UserObj *userObj in (NSMutableArray*)anObj) {
                NSMutableDictionary* dicUser = [NSMutableDictionary dictionary];
                [dicUser setObject:userObj.uid forKey:@"id"];
                if (userObj.firstname != nil && ![userObj.firstname isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.firstname forKey:@"firstname"];
                }
                if (userObj.middle_name != nil && ![userObj.middle_name isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.middle_name forKey:@"middle_name"];
                }
                if (userObj.lastname != nil && ![userObj.lastname isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.lastname forKey:@"lastname"];
                }
                if (userObj.name != nil && ![userObj.name isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.name forKey:@"name"];
                }
                if (userObj.email != nil && ![userObj.email isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.email forKey:@"email"];
                }
                if (userObj.avatarUrl != nil && ![userObj.avatarUrl isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.avatarUrl forKey:@"avatarUrl"];
                }
                if (userObj.state != nil && ![userObj.state isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.state forKey:@"state"];
                }
                if (userObj.city != nil && ![userObj.city isKindOfClass:[NSNull class]]) {
                    [dicUser setObject:userObj.city forKey:@"city"];
                }
                [dictionnaryObj addObject:dicUser];
            }
            [nameFriendElements setObject:dictionnaryObj forKey:@"Friend"];
            NSString* jsonFriendObj = [nameFriendElements JSONString];
            
            [CommonHelpers writeStringToFile:jsonFriendObj];
            
            NSLog(@"%@",jsonFriendObj);
            
            CRequest* request = [[CRequest alloc]initWithURL:@"submitLoginFacebook" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationJson withKey:1 WithView:nil];
            request.delegate = self;
            [request setHeader:HeaderTypeJSON];
            [request setJSON:jsonString];
            [request startRequest];
            
           
            
        }
            break;
            
            
        default:
            break;
    }
    
}

-(void)submitLogin
{
//    CRequest* request = [[CRequest alloc]initWithURL:@"loginAccount" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:3 WithView:nil];
//    request.delegate = self;
//    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
//    [request startFormRequest];
    
    CRequest* request2 = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2 WithView:nil];
    request2.delegate = self;
    [request2 setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
    [request2 startFormRequest];
    
}

- (void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 1) {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
//        NSString* userLogID = [dic objectForKey:@"user_log_id"];
//        [UserDefault userDefault].userLogID = userLogID;
        [UserDefault update];
        
        NSDictionary* dic2 = [dic objectForKey:@"user"];
        NSString* userID = [dic2 objectForKey:@"userId"];
        [Flurry setUserID:userID];
        NSString* status = [dic2 objectForKey:@"currentStatus"];
        [UserDefault userDefault].userID = userID;
        [UserDefault userDefault].user.uid = userID;
        TSCityObj* cityObj = [[TSCityObj alloc]init];
        cityObj.uid = [dic2 objectForKey:@"userCityId"];
        cityObj.cityName = [UserDefault userDefault].city;
        cityObj.stateName = [dic2 objectForKey:@"userState"];
        cityObj.country = [dic2 objectForKey:@"userCountry"];
        [UserDefault userDefault].cityObj = cityObj;
        [UserDefault update];
        
        
        isHaveAccount = [dic objectForKey:@"is_have_account"];
        if ([[CommonHelpers getBoolValue:isHaveAccount] boolValue] == NO || [[NSString stringWithFormat:@"%@",status] isEqualToString:@"p"]) {
            [self submitLogin];
            ConfigProfileVC *vc = [[ConfigProfileVC alloc] initWithNibName:@"ConfigProfileVC" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([CommonHelpers appDelegate].isHaveError == NO)
        {
            [self submitLogin];
            [[CommonHelpers appDelegate] showAskTab];
            
        }
    }
    if (key == 2) {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            [[CommonHelpers appDelegate].arrDataFBFriends addObject:userObject];
        }
    }
    if (key == 3)
    {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* userLogID = [dic objectForKey:@"successMsg"];
        [UserDefault userDefault].userLogID = userLogID;
        [UserDefault update];
    }
    
    
    
}

@end
