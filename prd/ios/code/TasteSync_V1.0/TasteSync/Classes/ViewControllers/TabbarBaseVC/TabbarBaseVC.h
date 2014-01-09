//
//  TabbarBaseVC.h
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import "RestaurantObj.h"
#import "CRequest.h"
#import "JSONKit.h"

typedef enum
{
    TabbarRequestProfile = 1
}TabbarRequestKey;

@interface TabbarBaseVC : UITabBarController<RequestDelegate>

- (id) init;
- (id) initWithRecomend;
- (void) actionAsk;
- (void) actionRecommendations;
- (void) actionRestaurant;
- (void) actionRestaurantViaAskTab:(NSString*)recorequestID;
- (void) actionOthers;
- (void) actionNewsfeed;
- (void) actionProfile:(UserObj *) user;
//- (void) actionDeal:(RestaurantObj *) aRestaurantObj;
- (void) actionSelectRestaurant:(RestaurantObj *) aRestaurantObj selectedIndex:(int)aSelectedIndex;
- (void)hideTabBar;
- (void)showTabBar;
- (void) actionRecommendationsShowMore:(RestaurantObj*)restaurantObj;
- (void)gotoProfile:(UserObj*)obj;
- (void) actionBackToSelectedIndex:(int) aSelectedIndex;

@end
