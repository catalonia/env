//
//  CFacebook.m
//  TasteSync
//
//  Created by Victor on 1/18/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "CFacebook.h"
#import "CommonHelpers.h"

@interface CFacebook()
{
}

@end

@implementation CFacebook
@synthesize delegate=_delegate,
tag=_tag,
loadView=_loadView,
done=_done;

- (void) login:(id<CFacebookDelegate>) aDelegate tagAction:(int) aTag
{
    debug(@"login");
    if (!_done) {
        _done = TRUE;
        debug(@"loging in");
        
        if (![[FBSession activeSession] isOpen]) {
            [[CommonHelpers appDelegate] loginFB:self];
        }
    }
    
    
    
}

- (void) getUserInfo:(id<CFacebookDelegate>) aDelegate tagAction:(int) aTag
{
    self.delegate = aDelegate;
    self.tag = aTag;
    //
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        NSString *query = @"SELECT uid, first_name, last_name, email,locale, current_location, affiliations, pic_square,sex FROM user WHERE uid = me() ";
        [self callFQLQuery:query];
    }
    else
    {
        debug(@"invalided session");
        [self login:self tagAction:CFacebookTagActionLogin];
    }
    
}

- (void) getUserFriends:(id<CFacebookDelegate>) aDelegate tagAction:(int)aTag
{
    debug(@"CFacebook -> getUserFriends ");
    self.delegate = aDelegate;
    self.tag = aTag;
    //
    if (FBSession.activeSession.state == FBSessionStateOpen) {
        //NSString *query = @"SELECT uid, name, first_name, middle_name, last_name, sex , locale, username, birthday_date, third_party_id, friend_count, install_type, timezone, verified, devices, email, hometown_location, current_location, age_range, pic_square, relationship_status, likes_count, affiliations FROM user WHERE uid = me() OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ";
        
        NSString *query = @"SELECT uid, name, first_name, middle_name, last_name, sex , locale, username, birthday_date, third_party_id, friend_count, install_type, timezone, verified, devices, email, hometown_location, current_location, age_range, pic_square, relationship_status, likes_count, affiliations FROM user WHERE uid = me()";
        
        debug(@"CFacebook -> prepare callFQLQuery");
        
        [self callFQLQuery:query];
    }
    else
    {
        debug(@"CFacebook -> invalided session");
        [[CommonHelpers appDelegate] loginFB:self];
        
    }
}

- (void) callFQLQuery:(NSString *) query
{
    
    //    NSString *query = @"SELECT uid, name,username, pic_square, email FROM user WHERE uid = me() OR uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ";
    
    //    NSString *query = @"SELECT aid, owner, name, object_id FROM album WHERE owner = me()";
    
    if (_loadView) {
        _loadView.hidden = NO;
    }
    else
    {
        self.loadView = [[LoadView alloc] initWithFrame:CGRectZero];
        
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (!_done) {
        
        debug(@"CFacebook -> callFQLQuery");
        
        _done = TRUE;
        NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                    query, @"q", nil];
        [FBRequestConnection startWithGraphPath:@"/fql"
                                     parameters:queryParam
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  if (error) {
                                      _done = FALSE;
                                      debug(@"callFQLQuery->Error: %@", [error localizedDescription]);
                                      
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                      _loadView.hidden = YES;
                                      
                                      [self.delegate cFacebook:self didFinish:nil tagAction:CFacebookTagActionError];
                                      
                                  } else {
                                      debug(@"callFQLQuery->Result: %@", result);
                                      
                                      if ([result isKindOfClass:[NSDictionary class]]) {
                                          
                                          [self parserData:result];
                                      }
                                      
                                  }
                              }];
        
        debug(@"return main thread");
    }
    
    
}

- (void) parserData :(NSDictionary *) dataDict
{
    NSArray *dataArray = [dataDict objectForKey:@"data"];
    switch (_tag) {
        case CFacebookTagActionGetUserInfo:
        {
            debug(@"parser case CFacebookTagActionGetUserInfo");
            
            UserObj *user = [[UserObj alloc] init];
            
            
            
            if (dataArray.count > 0) {
                NSDictionary* objDict = [dataArray objectAtIndex:0];
                user.uid = [objDict objectForKey:@"uid"];
                user.firstname = [objDict objectForKey:@"first_name"];
                user.lastname = [objDict objectForKey:@"last_name"];
                user.email = [objDict objectForKey:@"email"];
                user.avatarUrl = [objDict objectForKey:@"pic_square"];
                
                
                user.gender = [[objDict objectForKey:@"sex"] isEqualToString:@"male"];
                id locationDict = [objDict objectForKey:@"current_location"];
                debug(@"location class -> %@",[locationDict class]);
                if (![locationDict isKindOfClass:([NSNull class])]) {
                    user.city = [locationDict objectForKey:@"city"];
                    user.state = [locationDict objectForKey:@"state"];
                    debug(@"User Location -> %@",locationDict);
                }
                
                
                
            }
            
            [self debugUser:user];
            
            user.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
            
            
            [self.delegate cFacebook:self didFinish:user tagAction:_tag];
            
        }
            break;
            
        case CFacebookTagActionGetFriendsInfo:
        {
            NSMutableArray *arrFriends = [[NSMutableArray alloc] init];
            
            debug(@"parser case CFacebookTagActionGetFriendsInfo");
            int i = 0;
            
            if (dataArray.count > 0) {
                NSDictionary* objDict = [dataArray objectAtIndex:0];
                
                UserObj *user = [[UserObj alloc] init];
                
                user.uid                    = [objDict objectForKey:@"uid"];
                NSLog(@"ID: %@",[objDict objectForKey:@"uid"]);
                user.firstname              = [objDict objectForKey:@"first_name"];
                user.lastname               = [objDict objectForKey:@"last_name"];
                user.avatarUrl              = [objDict objectForKey:@"pic_square"];
                user.email                  = [objDict objectForKey:@"email"];
                user.gender                 = [[objDict objectForKey:@"sex"] isEqualToString:@"male"];
                
                
                user.name                   = [objDict objectForKey:@"name"];
                user.middle_name            = [objDict objectForKey:@"middle_name"];
                user.username               = [objDict objectForKey:@"username"];
                user.birthday_date          = [objDict objectForKey:@"birthday_date"];
                user.third_party_id         = [objDict objectForKey:@"third_party_id"];
                user.install_type           = [objDict objectForKey:@"install_type"];
                user.relationship_status    = [objDict objectForKey:@"relationship_status"];
                NSString* locate            = [objDict objectForKey:@"locale"];
                
                user.state = [[locate componentsSeparatedByString:@"_"] objectAtIndex:1];
                
                user.device = @"iOS";
                user.checkIn = @"";
                user.friends = @"";
                user.permission = @"";
                
                NSString* facebookLink      = @"https://facebook.com/";
                user.link                   = [facebookLink stringByAppendingString:user.username];
                
                id locationDict = [objDict objectForKey:@"current_location"];
                if (![locationDict isKindOfClass:([NSNull class])]) {
                    user.city = [locationDict objectForKey:@"city"];
                    
                    user.locate = [[CommonHelpers getSymbolLocation:[locationDict objectForKey:@"country"]] uppercaseString];
                    user.hometown_location = [locationDict objectForKey:@"city"];
                    user.location = [CommonHelpers getSymbolLocation:[locationDict objectForKey:@"state"]];
                    
                    NSLog(@"CITY: %@, STATE: %@, COUNTRY: %@, ZIP: %@, NAME: %@",    [locationDict objectForKey:@"city"],
                          user.location,
                          user.locate,
                          [locationDict objectForKey:@"zip"],
                          [locationDict objectForKey:@"name"]
                          );
                }
                
                id ageDic = [objDict objectForKey:@"age_range"];
                if (![ageDic isKindOfClass:([NSNull class])]) {
                    int min = [[ageDic objectForKey:@"min"] intValue];
                    int max = [[ageDic objectForKey:@"max"] intValue];
                    
                    if (min >= 21) {
                        user.age_range = @"21+";
                    }
                    else
                    {
                        user.age_range = [NSString stringWithFormat:@"%d-%d", min, max];
                    }
                }
                
                //                id hometown_locationDict = [objDict objectForKey:@"hometown_location"];
                //                if (![hometown_locationDict isKindOfClass:([NSNull class])]) {
                //                    user.hometown_location = [hometown_locationDict objectForKey:@"city"];
                //
                //                    NSLog(@"CITY: %@, STATE: %@, COUNTRY: %@, ZIP: %@, NAME: %@", [hometown_locationDict objectForKey:@"city"], [hometown_locationDict objectForKey:@"state"], [hometown_locationDict objectForKey:@"country"], [hometown_locationDict objectForKey:@"zip"], [hometown_locationDict objectForKey:@"name"]
                //                          );
                //
                //                    user.location = [hometown_locationDict objectForKey:@"state"];
                //                }
                
                
                if (i == 0) {
                    debug(@"Add user infor");
                    user.avatar                 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
                    user.friend_count = [[objDict objectForKey:@"friend_count"] intValue];
                    user.timezone = [[objDict objectForKey:@"timezone"] intValue];
                    user.likes_count = [[objDict objectForKey:@"likes_count"] intValue];
                    user.verified = [[objDict objectForKey:@"verified"] boolValue];
                    
                    //                    user.uid = [[objDict objectForKey:@"uid"] longValue];
                    //                    user.firstname = [objDict objectForKey:@"first_name"];
                    //                    user.lastname = [objDict objectForKey:@"last_name"];
                    //                    user.avatarUrl = [objDict objectForKey:@"pic_square"];
                    debug(@"Save user's info to UserDefault");
                    
                    [UserDefault userDefault].user = user;
                    [UserDefault update];
                    
                }
                else
                {
                    //                    random tasteSync User remove in UAT
                    
                    //user.isTasteSyncUser = user.uid%2;
                    //                    end random
                    
                    [arrFriends addObject:user];
                    
                }
            }
            
                debug(@"numberOfFriend -> %d",arrFriends.count);
                
                [CommonHelpers appDelegate].arrDataFBFriends = arrFriends;
                
                [self.delegate cFacebook:self didFinish:arrFriends tagAction:_tag];
            
            
            break;
        }

        default:
            break;
        }
            
            _done = FALSE;
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            _loadView.hidden = YES;
            
            
    }

    - (void) debugUser:(UserObj *) user
    {
#ifdef DEBUG
        NSLog(@"USER - INFO");
        NSLog(@"email -> %@, city - > %@ , state -> %@ ",user.email,user.city,user.state);
        
        
#endif
    }

- (void)sendMessageToFBID:(NSString*)uid   Message:(NSString*)message
{
    
}

#pragma mark - CFacebookDelegate
    
    
    - (void) cFacebook:(CFacebook *)aCFacebook didFinish:(id)anObj tagAction:(int)aTag
    {
        debug(@"CFacebook -> cFacebookDidFinish");
        _done = FALSE;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        _loadView.hidden = YES;
        
        switch (aTag) {
            case CFacebookTagActionError:
            {
                
                debug(@"CFacebookTagActionError");
            }
                break;
            case CFacebookTagActionLogin:
            {
                //            [self getUserInfo:_delegate tagAction:CFacebookTagActionGetUserInfo];
                [self getUserFriends:_delegate tagAction:_tag];
                
            }
                break;
                
            default:
                break;
        }
        
    }

    @end
