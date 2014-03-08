//
//  ResQuestionVC.h
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import "CRequest.h"
#import "JSONKit.h"
#import "RestaurantQuestionCell.h"

@interface ResQuestionVC : UIViewController<RequestDelegate, RestaurantQuestionDelegate>

@property (nonatomic, strong) NSMutableArray *arrData, *arrDataFilter, *arrDataFriends;
@property (nonatomic, strong) RestaurantObj *restaurantObj;

-(id)initWithRestaurantObj:(RestaurantObj*)obj;

@end
