//
//  RestaurantDetailVC.h
//  TasteSync
//
//  Created by Victor on 12/28/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObj.h"
#import "RestaurantObj.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface RestaurantDetailVC : UIViewController<RequestDelegate>

@property (nonatomic, strong) RestaurantObj *restaurantObj;
@property (nonatomic, assign) int selectedIndex;

- (id)initWithRestaurantObj:(RestaurantObj *)restaurantObj;
@end
