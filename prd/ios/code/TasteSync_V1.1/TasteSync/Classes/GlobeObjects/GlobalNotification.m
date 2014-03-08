//
//  GlobalNotification.m
//  TasteSync
//
//  Created by Victor on 1/29/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "GlobalNotification.h"
#import "UserDefault.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "CommonHelpers.h"

@interface GlobalNotification ()
{
    int indexLoad;
    int nextLoad;
    int pageReload, pageShuffle;
    UIView* _view;
    int _numberData;
}

@end

@implementation GlobalNotification


- (id)initWithALlType
{
    self = [super init];
    if (self) {
        self.arrData = [[NSMutableArray alloc] init];
        self.arrDataRead = [[NSMutableArray alloc] init];
        self.arrDataShuffle = [[NSMutableArray alloc] init];
        self.arrDataReadShuffle = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)requestData:(UIView*)view Type:(RecommendationType)type
{
    _view = view;
    if(type == RecommendationNotification)
    {
        NSString* link = [NSString stringWithFormat:@"recolist?userid=%@&paginationid=1",[UserDefault userDefault].userID];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:1 WithView:view];
        request.delegate = self;
        [request startFormRequest];
    }
    else
    {
        CRequest* request = [[CRequest alloc]initWithURL:@"shufflerecorequests" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:6 WithView:view];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:@"1" forKey:@"paginationid"];
        request.delegate = self;
        [request startFormRequest];
    }
}

-(void)reloadUpData:(int)pageload view:(UIView*)view Type:(RecommendationType)type;
{
    _view = view;
    AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(type == RecommendationNotification)
    {

        self.arrData = [[NSMutableArray alloc]initWithArray:deleate.arrayNotification];
        NSString* link = [NSString stringWithFormat:@"recolist?userid=%@&paginationid=%d",[UserDefault userDefault].userID, pageload];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:2 WithView:view];
        request.delegate = self;
        [request startFormRequest];
    }
    else
    {
        self.arrDataShuffle = [[NSMutableArray alloc]initWithArray:deleate.arrayShuffle];
        CRequest* request = [[CRequest alloc]initWithURL:@"shufflerecorequests" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:7 WithView:view];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:[NSString stringWithFormat:@"%d",pageload] forKey:@"paginationid"];
        request.delegate = self;
        [request startFormRequest];
    }
}
-(void)reloadDownData:(UIView*)view Type:(RecommendationType)type;
{
    _view = view;

    AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(type == RecommendationNotification)
    {
        [self reloadUpData:1 view:view Type:type];
        self.arrData = [[NSMutableArray alloc]initWithArray:deleate.arrayNotification];
        int index = self.arrData.count;
        NSString* link = [NSString stringWithFormat:@"recolist?userid=%@&paginationid=%d",[UserDefault userDefault].userID, index/50 + 1];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:view];
        request.delegate = self;
        [request startFormRequest];
    }
    else
    {
        self.arrDataShuffle = [[NSMutableArray alloc]initWithArray:deleate.arrayShuffle];
        int index = self.arrDataShuffle.count;
        CRequest* request = [[CRequest alloc]initWithURL:@"shufflerecorequests" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:8 WithView:view];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:[NSString stringWithFormat:@"%d",index/20 + 1] forKey:@"paginationid"];
        request.delegate = self;
        [request startFormRequest];
    }
}
-(void)requestRestaurantData:(UIView*)view;
{
    TSCityObj* _cityObj = [CommonHelpers setDefaultCityObj];
    //NSString* link = [NSString stringWithFormat:@"recosrestaurantsearchresults?userid=%@&restaurantid=%@&neighborhoodid=%@&cityid=%@&statename=%@&cuisineidtier1idlist=%@&priceidlist=%@&rating=%@&savedflag=%@&favflag=%@&dealflag=%@&chainflag=%@&paginationid=%@",[UserDefault userDefault].userID,@"",@"", _cityObj.uid, _cityObj.stateName,@"",@"",@"",@"",@"",@"",@"",@"1"];
    
    
    
    CRequest* request = [[CRequest alloc]initWithURL:@"restsearchresults" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:5 WithView:view];
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
    NSString* openFlag  = @"0";
    NSString* savedFlag = @"0";
    NSString* favFlag   = @"0";
    NSString* chainFlag = @"0";
    
    [request setFormPostValue:@""               forKey:@"cuisinetier1idlist"];
    [request setFormPostValue:@""               forKey:@"cuisinetier2idlist"];
    [request setFormPostValue:@""               forKey:@"priceidlist"];
    [request setFormPostValue:@""               forKey:@"themeidlist"];
    [request setFormPostValue:@""               forKey:@"whoareyouwithidlist"];
    [request setFormPostValue:@""               forKey:@"typeofrestaurantidList"];
    [request setFormPostValue:@""               forKey:@"occasionidlist"];
    [request setFormPostValue:@""               forKey:@"rating"];
    [request setFormPostValue:openFlag          forKey:@"opennownlag"];
    [request setFormPostValue:savedFlag         forKey:@"savedflag"];
    [request setFormPostValue:favFlag           forKey:@"favflag"];
    [request setFormPostValue:@"0"              forKey:@"dealflag"];
    [request setFormPostValue:chainFlag         forKey:@"chainflag"];
    [request setFormPostValue:@"1"             forKey:@"paginationid"];
    [request setFormPostValue:@""               forKey:@"neighborhoodid"];
    [request setFormPostValue:[CommonHelpers getDefaultCityObj].cityObj.uid forKey:@"cityid"];
    [request setFormPostValue:[CommonHelpers getDefaultCityObj].cityObj.stateName forKey:@"statename"];
    
    
    
    
    request.delegate = self;
    [request startFormRequest];
    
    
    
    
    
//    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:5 WithView:view];
//    request.delegate = self;
//    [request startFormRequest];
}
-(void)startReload:(UIView*)view
{
        NSString* link = [NSString stringWithFormat:@"recolist?userid=%@&paginationid=%d",[UserDefault userDefault].userID, self.pageLoad];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:4 WithView:_view];
        request.delegate = self;
        [request startFormRequest];
    
    
    
}

-(void)reloadDownDataToNotifycation:(int)countNumber View:(UIView*)view;
{
    _numberData = countNumber;
    _view = view;
    [self startReload:view];
    
}
- (NotificationObj *) gotoNextNotification
{
    if (self.index < [self.arrData count]) {
        self.isSend = TRUE;
        NotificationObj* obj = [self.arrData objectAtIndex:self.index];
        for(int i = self.index + 1; i < [self.arrData count]; i++)
        {
            NotificationObj* objCompare = [self.arrData objectAtIndex:i];
            if ([obj.user.uid isEqualToString:objCompare.user.uid]) {
                self.index = i;
                return [self.arrData objectAtIndex:i];
            }
        }
        return nil;
    }
    else
    {
        self.index = 0;
        self.isSend = FALSE;
    }
    return nil;
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    //1: Recorequest Needed; 2: Recommendations for You (Recorequest Answer); 3: Follow-up question for you (Restaurant ASK related questions); 4: Message For You; 5: Someone Liked your Recommendation; 6: Did You Like any of these recommendations; 7: Deal
    if (key == 1) {
        _arrData = [[NSMutableArray alloc]init];
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        self.total = [array count];
        self.unread = [array count];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            obj.type = [[dic objectForKey:@"recoNotificationType"] intValue];
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"idBase"]];
            UserObj *user = [[UserObj alloc] init];
            
            NSString* unreadCounter = [dic objectForKey:@"unreadCounter"];
            [CommonHelpers setBottomValue:unreadCounter];
            [CommonHelpers appDelegate].numberPageRecomendation = [[dic objectForKey:@"maxPaginationId"] intValue];
            NSString* unread;
            NSString* replied;
            
            
            
            if (obj.type == NotificationMessageForYou) {
                obj.description = [dic objectForKey:@"message"];
                NSDictionary* dicObj = [dic objectForKey:@"senderUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                
            }
            if (obj.type == NotificationFollowUpQuestion) {
                obj.description = [dic objectForKey:@"questionText"];
                NSDictionary* dicObj = [dic objectForKey:@"questionUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
            }
            if (obj.type == NotificationRecorequestNeeded) {
                obj.description = [dic objectForKey:@"recorequestText"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"recorequestassignedViewed"];
                replied = [dic objectForKey:@"recorequestassignedActioned"];
            }
            
            if (obj.type == NotificationRecommendationsForYou) {
                NSDictionary* dicObj = [dic objectForKey:@"recommendationsForYou"];
                obj.description = [dicObj objectForKey:@"recorequestText"];
                NSDictionary* lastestUser = [dicObj objectForKey:@"latestRecommendeeUser"];
                user.name = [lastestUser objectForKey:@"name"];
                user.avatarUrl = [lastestUser objectForKey:@"photo"];
                user.uid = [lastestUser objectForKey:@"userId"];
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
            }
            if (obj.type == NotificationDidYouLike) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSArray* arrayRes = [dic objectForKey:@"restaurantbasic"];
                obj.arrayRestaurant = [[NSMutableArray alloc]init];
                for (NSDictionary* dicRes in arrayRes) {
                    RestaurantObj* objRes = [[RestaurantObj alloc]init];
                    objRes.uid     = [dicRes objectForKey:@"restaurantId"];
                    objRes.name    = [dicRes objectForKey:@"restaurantName"];
                    [obj.arrayRestaurant addObject:objRes];
                }
            }
            
            if ([unread isKindOfClass:[NSNull class]] || [unread isEqualToString:@""]) {
                obj.unread = YES;
            }
            if ([replied isEqualToString:@"1"]) {
                obj.replied = YES;
            }
            
            obj.user = user;
            
            indexLoad = i;
            [self.arrData addObject:obj];
            i++;
        }
        deleate.arrayNotification = [[NSMutableArray alloc]initWithArray:_arrData];
    }
    if (key == 2) {
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        
        self.total = [array count];
        self.unread = [array count];
        //self.read = 0;
        self.arrDataRead = [[NSMutableArray alloc]init];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            obj.type = [[dic objectForKey:@"recoNotificationType"] intValue];
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"idBase"]];
            UserObj *user = [[UserObj alloc] init];
            
            NSString* unreadCounter = [dic objectForKey:@"unreadCounter"];
            [CommonHelpers setBottomValue:unreadCounter];
            
            NSString* unread;
            NSString* replied;
            
            if (obj.type == NotificationMessageForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"message"];
                NSDictionary* dicObj = [dic objectForKey:@"senderUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                NSLog(@"1");
            }
            if (obj.type == NotificationFollowUpQuestion) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"questionText"];
                NSDictionary* dicObj = [dic objectForKey:@"questionUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                NSLog(@"2");
            }
            if (obj.type == NotificationRecorequestNeeded) {
                obj.description = [dic objectForKey:@"recorequestText"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"recorequestassignedViewed"];
                replied = [dic objectForKey:@"recorequestassignedActioned"];
                NSLog(@"3");
            }
            if (obj.type == NotificationRecommendationsForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendationsForYou"];
                obj.description = [dicObj objectForKey:@"recorequestText"];
                NSDictionary* lastestUser = [dicObj objectForKey:@"latestRecommendeeUser"];
                user.name = [lastestUser objectForKey:@"name"];
                user.avatarUrl = [lastestUser objectForKey:@"photo"];
                user.uid = [lastestUser objectForKey:@"userId"];
                NSLog(@"4");
            }
            if (obj.type == NotificationDidYouLike) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSArray* arrayRes = [dic objectForKey:@"restaurantbasic"];
                obj.arrayRestaurant = [[NSMutableArray alloc]init];
                for (NSDictionary* dicRes in arrayRes) {
                    RestaurantObj* objRes = [[RestaurantObj alloc]init];
                    objRes.uid     = [dicRes objectForKey:@"restaurantId"];
                    objRes.name    = [dicRes objectForKey:@"restaurantName"];
                    [obj.arrayRestaurant addObject:objRes];
                    
                }
                NSLog(@"5");
            }
            if ([unread isKindOfClass:[NSNull class]] || [unread isEqualToString:@""]) {
                obj.unread = YES;
            }
            if ([replied isEqualToString:@"1"]) {
                obj.replied = YES;
            }
            obj.user = user;
            
            indexLoad = i;
            [self.arrDataRead addObject:obj];
            [NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        NSLog(@"finish");
        if (self.arrData.count > 0) {
            NotificationObj* objData = [self.arrData objectAtIndex:0];
            NSString* str2 = [NSString stringWithFormat:@"%@",objData.linkId];
            i = 0;
            for (NotificationObj*obj in self.arrDataRead) {
                NSString* str1 = [NSString stringWithFormat:@"%@",obj.linkId];
                if (![str1 isEqualToString:str2]) {
                    [self.arrData insertObject:obj atIndex:i];
                    i++;
                }
                else
                    break;
            }
            if (i == self.arrDataRead.count) {
                pageReload++;
                [self reloadUpData:pageReload view:_view Type:RecommendationNotification];
            }
            else
            {
                deleate.arrayNotification = [[NSMutableArray alloc]initWithArray:_arrData];
                [self.delegate getDataSuccess:RecommendationNotification];
            }
        }
    }
    if (key == 3) {
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.arrDataRead = [[NSMutableArray alloc]init];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        self.total = [array count];
        self.unread = [array count];
        //self.read = 0;
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            obj.type = [[dic objectForKey:@"recoNotificationType"] intValue];
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"idBase"]];
            UserObj *user = [[UserObj alloc] init];
            
            NSString* unreadCounter = [dic objectForKey:@"unreadCounter"];
            [CommonHelpers setBottomValue:unreadCounter];
            
            NSString* unread;
            NSString* replied;
            
            if (obj.type == NotificationMessageForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"message"];
                NSDictionary* dicObj = [dic objectForKey:@"senderUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                NSLog(@"1");
                
            }
            if (obj.type == NotificationFollowUpQuestion) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"questionText"];
                NSDictionary* dicObj = [dic objectForKey:@"questionUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                NSLog(@"2");
            }
            if (obj.type == NotificationRecorequestNeeded) {
                obj.description = [dic objectForKey:@"recorequestText"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"recorequestassignedViewed"];
                replied = [dic objectForKey:@"recorequestassignedActioned"];
                NSLog(@"3");
            }
            if (obj.type == NotificationRecommendationsForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendationsForYou"];
                obj.description = [dicObj objectForKey:@"recorequestText"];
                NSDictionary* lastestUser = [dicObj objectForKey:@"latestRecommendeeUser"];
                user.name = [lastestUser objectForKey:@"name"];
                user.avatarUrl = [lastestUser objectForKey:@"photo"];
                user.uid = [lastestUser objectForKey:@"userId"];
                NSLog(@"4");
            }
            if (obj.type == NotificationDidYouLike) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSArray* arrayRes = [dic objectForKey:@"restaurantbasic"];
                obj.arrayRestaurant = [[NSMutableArray alloc]init];
                for (NSDictionary* dicRes in arrayRes) {
                    RestaurantObj* objRes = [[RestaurantObj alloc]init];
                    objRes.uid     = [dicRes objectForKey:@"restaurantId"];
                    objRes.name    = [dicRes objectForKey:@"restaurantName"];
                    [obj.arrayRestaurant addObject:objRes];
                }
                NSLog(@"5");
            }
            if ([unread isKindOfClass:[NSNull class]] || [unread isEqualToString:@""]) {
                obj.unread = YES;
            }
            if ([replied isEqualToString:@"1"]) {
                obj.replied = YES;
            }
            obj.user = user;
            indexLoad = i;
            [self.arrDataRead addObject:obj];
            [NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        NSLog(@"finish");
        if (self.arrData.count > 0) {
            NotificationObj* objData = [self.arrData objectAtIndex:(self.arrData.count - 1)];
            NSString* str2 = [NSString stringWithFormat:@"%@",objData.linkId];
            for (int j = self.arrDataRead.count - 1; j >= 0; j-- ) {
                NotificationObj*obj = [self.arrDataRead objectAtIndex:j];
                NSString* str1 = [NSString stringWithFormat:@"%@",obj.linkId];
                if (![str1 isEqualToString:str2]) {
                    [self.arrData addObject:obj];
                }
                else
                    break;
            }
            deleate.arrayNotification = [[NSMutableArray alloc]initWithArray:_arrData];
            [self.delegate getDataSuccess:RecommendationNotification];
        }
    }
    if (key == 4) {
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.arrDataRead = [[NSMutableArray alloc]init];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        self.total = [array count];
        self.unread = [array count];
        //self.read = 0;
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            obj.type = [[dic objectForKey:@"recoNotificationType"] intValue];
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"idBase"]];
            UserObj *user = [[UserObj alloc] init];
            
            NSString* unreadCounter = [dic objectForKey:@"unreadCounter"];
            [CommonHelpers setBottomValue:unreadCounter];
            
            NSString* unread;
            NSString* replied;
            
            if (obj.type == NotificationMessageForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"message"];
                NSDictionary* dicObj = [dic objectForKey:@"senderUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                
            }
            if (obj.type == NotificationFollowUpQuestion) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                obj.description = [dic objectForKey:@"questionText"];
                NSDictionary* dicObj = [dic objectForKey:@"questionUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
            }
            if (obj.type == NotificationRecorequestNeeded) {
                obj.description = [dic objectForKey:@"recorequestText"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
                user.name = [dicObj objectForKey:@"name"];
                user.avatarUrl = [dicObj objectForKey:@"photo"];
                user.uid = [dicObj objectForKey:@"userId"];
                unread = [dic objectForKey:@"recorequestassignedViewed"];
                replied = [dic objectForKey:@"recorequestassignedActioned"];
            }
            if (obj.type == NotificationRecommendationsForYou) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSDictionary* dicObj = [dic objectForKey:@"recommendationsForYou"];
                obj.description = [dicObj objectForKey:@"recorequestText"];
                NSDictionary* lastestUser = [dicObj objectForKey:@"latestRecommendeeUser"];
                user.name = [lastestUser objectForKey:@"name"];
                user.avatarUrl = [lastestUser objectForKey:@"photo"];
                user.uid = [lastestUser objectForKey:@"userId"];
            }
            if (obj.type == NotificationDidYouLike) {
                unread = [dic objectForKey:@"viewed"];
                replied = [dic objectForKey:@"actioned"];
                NSArray* arrayRes = [dic objectForKey:@"restaurantbasic"];
                obj.arrayRestaurant = [[NSMutableArray alloc]init];
                for (NSDictionary* dicRes in arrayRes) {
                    RestaurantObj* objRes = [[RestaurantObj alloc]init];
                    objRes.uid     = [dicRes objectForKey:@"restaurantId"];
                    objRes.name    = [dicRes objectForKey:@"restaurantName"];
                    [obj.arrayRestaurant addObject:objRes];
                }
            }
            if ([unread isKindOfClass:[NSNull class]] || [unread isEqualToString:@""]) {
                obj.unread = YES;
            }
            if ([replied isEqualToString:@"1"]) {
                obj.replied = YES;
            }
            obj.user = user;
            indexLoad = i;
            [self.arrDataRead addObject:obj];
            [NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        NSLog(@"finish");
        for (int j = 0; j < self.arrDataRead.count; j++ ) {
            NotificationObj*obj = [self.arrDataRead objectAtIndex:j];
            if (delegate.arrayNotification.count <= _numberData) {
                [delegate.arrayNotification addObject:obj];
            }
        }
        
        
        if (delegate.arrayNotification.count < _numberData) {
            self.pageLoad++;
            [self startReload:_view];
        }
        else
            [self.delegate getDataSuccess:RecommendationNotification];
        
    }
    if (key == 5) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseRestaurant: %@",response);
        NSDictionary* dicAll = [response objectFromJSONString];
        [CommonHelpers appDelegate].numberPage = [[dicAll objectForKey:@"maxPaginationId"] integerValue];
        
        [CommonHelpers appDelegate].arrayRestaurant = [[NSMutableArray alloc]init];
        
        
        NSArray* array = [dicAll objectForKey:@"restaurantsSearchListTileObj"];
        for (NSDictionary* dic in array) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.type = GlobalDataRestaurant;
            
            
            
            global.uid = [dic objectForKey:@"restaurantId"];
            global.name = [dic objectForKey:@"restaurantName"];
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid =  [dic objectForKey:@"restaurantId"];
            restaurantObj.name = [dic objectForKey:@"restaurantName"];
            restaurantObj.cuisineTier2 = [dic objectForKey:@"cuisineTier2Name"];
            restaurantObj.price     = [dic objectForKey:@"price"];
            restaurantObj.deal      =  [dic objectForKey:@"restaurantDealFlag"];
            restaurantObj.rates     = [[dic objectForKey:@"restaurantRating"] floatValue];
            
            restaurantObj.lattitude     = [[dic objectForKey:@"restaurantLat"] floatValue];
            restaurantObj.longtitude    = [[dic objectForKey:@"restaurantLong"] floatValue];
            restaurantObj.cityObj = [[TSCityObj alloc]init];
            restaurantObj.cityObj.cityName = [dic objectForKey:@"restaurantCity"];
            
            global.restaurantObj = restaurantObj;
            [_arrData addObject:global];
            [[CommonHelpers appDelegate].arrayRestaurant addObject:global];
        }
        //_arrData = _arrDataRestaurant;
    }
    if (key == 6) {
        _arrDataShuffle = [[NSMutableArray alloc]init];
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        NSDictionary* dictionary = [response objectFromJSONString];
        
        [CommonHelpers appDelegate].numberPageShuffle = [[dictionary objectForKey:@"maxPaginationId"] intValue];
        NSArray* array = [dictionary objectForKey:@"recoRequestShuffle"];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            NSString* follow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recommendeeUserFolloweeFlag"]];
            if ([follow isEqualToString:@"0"]) {
                obj.follow = NO;
            }
            else
            {
                obj.follow = YES;
            }
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"recorequestId"]];
            obj.type = NotificationRecorequestNeeded;
            UserObj *user = [[UserObj alloc] init];
        
            obj.description = [dic objectForKey:@"recorequestText"];
            NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
            user.name = [dicObj objectForKey:@"name"];
            user.avatarUrl = [dicObj objectForKey:@"photo"];
            user.uid = [dicObj objectForKey:@"userId"];
            
            obj.user = user;
            
            indexLoad = i;
            [self.arrDataShuffle addObject:obj];
            i++;
        }
        deleate.arrayShuffle = [[NSMutableArray alloc]initWithArray:_arrDataShuffle];
    }
    if (key == 7) {
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        self.arrDataReadShuffle = [[NSMutableArray alloc]init];
        NSDictionary* dictionary = [response objectFromJSONString];
        
        [CommonHelpers appDelegate].numberPageShuffle = [[dictionary objectForKey:@"maxPaginationId"] intValue];
        NSArray* array = [dictionary objectForKey:@"recoRequestShuffle"];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            NSString* follow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recommendeeUserFolloweeFlag"]];
            if ([follow isEqualToString:@"0"]) {
                obj.follow = NO;
            }
            else
            {
                obj.follow = YES;
            }
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"recorequestId"]];
            obj.type = NotificationRecorequestNeeded;
            UserObj *user = [[UserObj alloc] init];
            
            obj.description = [dic objectForKey:@"recorequestText"];
            NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
            user.name = [dicObj objectForKey:@"name"];
            user.avatarUrl = [dicObj objectForKey:@"photo"];
            user.uid = [dicObj objectForKey:@"userId"];
            
            obj.user = user;
            
            indexLoad = i;
            [self.arrDataReadShuffle addObject:obj];
            //[NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        NSLog(@"finish");
        if (self.arrDataShuffle.count > 0) {
            NotificationObj* objData = [self.arrDataShuffle objectAtIndex:0];
            NSString* str2 = [NSString stringWithFormat:@"%@",objData.linkId];
            i = 0;
            for (NotificationObj*obj in self.arrDataReadShuffle) {
                NSString* str1 = [NSString stringWithFormat:@"%@",obj.linkId];
                if (![str1 isEqualToString:str2]) {
                    [self.arrDataShuffle insertObject:obj atIndex:i];
                    i++;
                }
                else
                    break;
            }
            if (i == self.arrDataReadShuffle.count) {
                pageShuffle++;
                [self reloadUpData:pageShuffle view:_view Type:RecommendationShuffle];
            }
            else
            {
                deleate.arrayShuffle = [[NSMutableArray alloc]initWithArray:_arrDataShuffle];
                [self.delegate getDataSuccess:RecommendationShuffle];
            }
        }
    }
    if (key == 8) {
        AppDelegate* deleate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.arrDataReadShuffle = [[NSMutableArray alloc]init];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        NSDictionary* dictionary = [response objectFromJSONString];
        
        [CommonHelpers appDelegate].numberPageShuffle = [[dictionary objectForKey:@"maxPaginationId"] intValue];
        NSArray* array = [dictionary objectForKey:@"recoRequestShuffle"];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            NSString* follow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recommendeeUserFolloweeFlag"]];
            if ([follow isEqualToString:@"0"]) {
                obj.follow = NO;
            }
            else
            {
                obj.follow = YES;
            }
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"recorequestId"]];
            UserObj *user = [[UserObj alloc] init];
            
            obj.description = [dic objectForKey:@"recorequestText"];
            obj.type = NotificationRecorequestNeeded;
            NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
            user.name = [dicObj objectForKey:@"name"];
            user.avatarUrl = [dicObj objectForKey:@"photo"];
            user.uid = [dicObj objectForKey:@"userId"];
            
            obj.user = user;
            
            indexLoad = i;
            [self.arrDataShuffle addObject:obj];
            //[NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        deleate.arrayShuffle = [[NSMutableArray alloc]initWithArray:_arrDataShuffle];
        [self.delegate getDataSuccess:RecommendationShuffle];
        
    }
    if (key == 9) {
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.arrDataReadShuffle = [[NSMutableArray alloc]init];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
        NSDictionary* dictionary = [response objectFromJSONString];
        
        [CommonHelpers appDelegate].numberPageShuffle = [[dictionary objectForKey:@"maxPaginationId"] intValue];
        NSArray* array = [dictionary objectForKey:@"recoRequestShuffle"];
        int i = 0;
        for (NSDictionary* dic in array) {
            NotificationObj *obj = [[NotificationObj alloc] init];
            NSString* follow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recommendeeUserFolloweeFlag"]];
            if ([follow isEqualToString:@"0"]) {
                obj.follow = NO;
            }
            else
            {
                obj.follow = YES;
            }
            obj.linkId =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"recorequestId"]];
            UserObj *user = [[UserObj alloc] init];
            
            obj.description = [dic objectForKey:@"recorequestText"];
            obj.type = NotificationRecorequestNeeded;
            NSDictionary* dicObj = [dic objectForKey:@"recommendeeUser"];
            user.name = [dicObj objectForKey:@"name"];
            user.avatarUrl = [dicObj objectForKey:@"photo"];
            user.uid = [dicObj objectForKey:@"userId"];
            
            obj.user = user;
            
            indexLoad = i;
            [self.arrDataReadShuffle addObject:obj];
            //[NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
            i++;
        }
        NSLog(@"finish");
        for (int j = 0; j < self.arrDataReadShuffle.count; j++ ) {
            NotificationObj*obj = [self.arrDataReadShuffle objectAtIndex:j];
            if (delegate.arrayShuffle.count <= _numberData) {
                [delegate.arrayShuffle addObject:obj];
            }
        }
        
        
        if (delegate.arrayShuffle.count < _numberData) {
            self.pageLoad++;
            [self startReload:_view];
        }
        else
            [self.delegate getDataSuccess:RecommendationShuffle];
        
    }
}

-(void)loadImage
{
    int n = indexLoad;
    NotificationObj* notiObj = [self.arrData objectAtIndex:n];
    UserObj* obj = notiObj.user;
    obj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.avatarUrl]]];
    
}

-(void)loadImageData
{
    int n = nextLoad;
    NotificationObj* notiObj = [self.arrDataRead objectAtIndex:n];
    UserObj* obj = notiObj.user;
    obj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.avatarUrl]]];
    
}

-(BOOL)checkNotify:(NotificationObj*)notifyObj
{
    for (NotificationObj* notify in self.arrData) {
        if ([notify.linkId isEqualToString:notifyObj.linkId]) {
            return NO;
        }
    }
    return YES;
}

@end
