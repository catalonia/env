//
//  ResMenuVC.h
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface ResMenuVC : UIViewController<RequestDelegate,UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) RestaurantObj *restaurantObj;

-(id)initWithRestaurantObj:(RestaurantObj*)restaurantObj;

@end
