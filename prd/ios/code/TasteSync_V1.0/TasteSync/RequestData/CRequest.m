//
//  CRequest.m
//  TasteSync
//
//  Created by HP on 7/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "CRequest.h"
#import "UserDefault.h"
#import "CommonHelpers.h"
#import "Reachability.h"


#define LINK_REQUEST @"http://prdws.tastesync.com/tsws/services/"

#define USER_REQUEST @"user/"
#define RESTAURANT_REQUEST @"restaurant/"
#define ASK_REQUEST @"ask/"
#define POPULATE_REQUEST @"populate/"

@interface CRequest()
{
    NSString* _url;
    NSMutableData* _data;
    ASIHTTPRequest* _request;
    ASIFormDataRequest* _formRequest;
    UIView* viewAnimater;
    UIView* viewmain;
}
@end

@implementation CRequest
-(id)initWithURL:(NSString*)url RQType:(RequestType)type RQData:(RequestData)data RQCategory:(RequestCategory)category WithView:(UIView*)view
{
    self = [super init];
    if (self) {
        viewmain = view;
        
        self.showIndicate = NO;
        //_url = @"http://localhost:8080";//[@"http://" stringByAppendingString:[UserDefault userDefault].IPAdress];
        _url = LINK_REQUEST;
        if (data == RequestDataUser)
            _url = [_url stringByAppendingString:USER_REQUEST];
        if (data == RequestDataRestaurant)
            _url = [_url stringByAppendingString:RESTAURANT_REQUEST];
        if (data == RequestDataAsk)
            _url = [_url stringByAppendingString:ASK_REQUEST];
        if (data == RequestPopulate)
            _url = [_url stringByAppendingString:POPULATE_REQUEST];
        _url = [_url stringByAppendingString:url];
        
        NSLog(@"url: %@", _url);
        
        _data = [[NSMutableData alloc]init];
        
        NSURL* linkRequest = [NSURL URLWithString:_url];
        
        self.key = 0;
        
        if (category == ApplicationForm) {
            _formRequest = [ASIFormDataRequest requestWithURL:linkRequest];
            _formRequest.delegate = self;
            if (type == RequestTypePost){
                [_formRequest setRequestMethod:@"POST"];
            }
            else
            {
                [_formRequest setRequestMethod:@"GET"];
                [_formRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            }
        }
        else
        {
            _request = [ASIHTTPRequest requestWithURL:linkRequest];
            _request.delegate = self;
            
            if (type == RequestTypePost){
                [_request setRequestMethod:@"POST"];
            }
            else
            {
                [_request setRequestMethod:@"GET"];
            }
        }
        [self setDefaultHeader];
    }
    return self;
}

-(id)initWithURL:(NSString*)url RQType:(RequestType)type RQData:(RequestData)data RQCategory:(RequestCategory)category withKey:(int)key WithView:(UIView*)view
{
    self = [super init];
    if (self) {
        viewmain = view;
        self.showIndicate = NO;
        //_url = [@"http://" stringByAppendingString:[UserDefault userDefault].IPAdress];
       // _url = @"http://localhost:8080";
        _url = LINK_REQUEST;
        if (data == RequestDataUser)
            _url = [_url stringByAppendingString:USER_REQUEST];
        if (data == RequestDataRestaurant)
            _url = [_url stringByAppendingString:RESTAURANT_REQUEST];
        if (data == RequestDataAsk)
            _url = [_url stringByAppendingString:ASK_REQUEST];
        if (data == RequestPopulate)
            _url = [_url stringByAppendingString:POPULATE_REQUEST];
        _url = [_url stringByAppendingString:url];
        
        NSLog(@"url: %@", _url);
        
        _data = [[NSMutableData alloc]init];
        
        NSURL* linkRequest = [NSURL URLWithString:_url];
        
        self.key = key;
        
        if (category == ApplicationForm) {
            _formRequest = [ASIFormDataRequest requestWithURL:linkRequest];
            _formRequest.delegate = self;
            if (type == RequestTypePost){
                [_formRequest setRequestMethod:@"POST"];
            }
            else
            {
                [_formRequest setRequestMethod:@"GET"];
                [_formRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            }
        }
        else
        {
            _request = [ASIHTTPRequest requestWithURL:linkRequest];
            _request.delegate = self;
            
            if (type == RequestTypePost){
                [_request setRequestMethod:@"POST"];
            }
            else
            {
                [_request setRequestMethod:@"GET"];
            }
        }
        [self setDefaultHeader];
    }
    return self;
}

-(id)initWithLink:(NSString*)url RQType:(RequestType)type RQCategory:(RequestCategory)category withKey:(int)key WithView:(UIView*)view
{
    self = [super init];
    if (self) {
        if (view != nil) {
            viewmain = view;
        }
        self.showIndicate = NO;
        _url = url;
        
        NSLog(@"url: %@", _url);
        
        _data = [[NSMutableData alloc]init];
        
        NSURL* linkRequest = [NSURL URLWithString:_url];
        
        self.key = key;
        
        if (category == ApplicationForm) {
            _formRequest = [ASIFormDataRequest requestWithURL:linkRequest];
            _formRequest.delegate = self;
            if (type == RequestTypePost){
                [_formRequest setRequestMethod:@"POST"];
            }
            else
            {
                [_formRequest setRequestMethod:@"GET"];
                [_formRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
            }
        }
        else
        {
            _request = [ASIHTTPRequest requestWithURL:linkRequest];
            _request.delegate = self;
            
            if (type == RequestTypePost){
                [_request setRequestMethod:@"POST"];
            }
            else
            {
                [_request setRequestMethod:@"GET"];
            }
        }
        [self setDefaultHeader];
    }
    return self;
}

-(void)setDefaultHeader
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    //change your version here
    NSString* version = @"12302013";
    NSLog(@"[currentDevice identifierForVendor]: %@",[[currentDevice identifierForVendor] UUIDString]);
    //NSMutableDictionary* dic1 = [NSMutableDictionary dictionary];
    //[dic1 setValue:version forKey:@"ts_version_date"];
    [_formRequest addRequestHeader:@"ts_version_date" value:version];
    [_request addRequestHeader:@"ts_version_date" value:version];
   
    NSString* oauth = @"";
    if ([UserDefault userDefault].oauth_token != nil) {
        oauth = [UserDefault userDefault].oauth_token;
    }
    //NSMutableDictionary* dic2 = [NSMutableDictionary dictionary];
    [_formRequest addRequestHeader:@"ts_oauth_token" value:oauth];
    //[dic2 setValue:oauth forKey:@"ts_oauth_token"];
    [_request addRequestHeader:@"ts_oauth_token" value:oauth];
    //NSMutableDictionary* dic3 = [NSMutableDictionary dictionary];
    [_request addRequestHeader:@"identifierForVendor" value:[[currentDevice identifierForVendor] UUIDString] ];
    [_formRequest addRequestHeader:@"identifierForVendor" value:[[currentDevice identifierForVendor] UUIDString] ];
}
-(void)setHeader:(HeaderType)type
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (type == HeaderTypeJSON)
    {
        [_formRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [dic setValue:@"application/json" forKey:@"Content-Type"];
        [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    }
    if (type == HeaderTypeTEXT)
    {
        [_formRequest addRequestHeader:@"Content-Type" value:@"application/text"];
        [dic setValue:@"application/text" forKey:@"Content-Type"];
        [_request addRequestHeader:@"Content-Type" value:@"application/text"];
    }

    
}

-(void)setJSON:(NSString*)JsonText
{
    [_request appendPostData:[JsonText dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)startRequest
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [CommonHelpers showInfoAlertConnectInternet];
    }
    else
    {
        if (viewmain != nil) {
            [NSThread detachNewThreadSelector:@selector(loadView) toTarget:self withObject:nil];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [_request startSynchronous];
    }
    
}

-(void)setFormPostValue:(NSString*)value forKey:(NSString*)key
{
    [_formRequest setPostValue:value forKey:key];
    
}


-(void)startFormRequest
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [CommonHelpers showInfoAlertConnectInternet];
    }
    else
    {
        if (viewmain != nil) {
            [NSThread detachNewThreadSelector:@selector(loadView) toTarget:self withObject:nil];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [_formRequest startSynchronous];
    }
    
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"requestStarted");
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    int code = [request responseStatusCode];
    NSLog(@"Status Code: %d",code);
    if (code == 401) {
        //[CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:[responseHeaders objectForKey:@"ts_oauth_token_msg"] delegate:nil tag:0];
        [CommonHelpers appDelegate].errorMessage = [responseHeaders objectForKey:@"ts_oauth_token_msg"];
        [[CommonHelpers appDelegate] showAlertError];
        [CommonHelpers appDelegate].isHaveError = YES;
        
    }
    else
    {
        [CommonHelpers appDelegate].isHaveError = NO;
    }
    
    
    NSString* oauth = [responseHeaders objectForKey:@"ts_oauth_token"];
    if (oauth != nil) {
        [UserDefault userDefault].oauth_token = oauth;
        [UserDefault update];
    }
    else
        NSLog(@"No oauth");
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
    NSLog(@"willRedirectToURL");
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"key: %d", self.key);
    [self.delegate responseData:_data WithKey:self.key  UserData:self.userData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [viewAnimater removeFromSuperview];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"requestFailed");
}
- (void)requestRedirected:(ASIHTTPRequest *)request{
    NSLog(@"requestRedirected");
}
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request
{
    NSLog(@"authenticationNeededForRequest");
}
- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request
{
    NSLog(@"proxyAuthenticationNeededForRequest");
}
-(void)loadView
{
    viewAnimater = [[UIView alloc]initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(viewAnimater.frame.size.width/2 - 10, viewAnimater.frame.size.height/2 - 10, 20, 20)];
    if (self.blackcolor)
        viewAnimater.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    else
        viewAnimater.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [viewAnimater addSubview:activity];
    [activity startAnimating];
    [viewmain addSubview:viewAnimater];
}

@end
