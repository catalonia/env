//
//  ResRecommendVC.h
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResRecommendObj.h"
#import "RestaurantObj.h"
#import "ResRecommendCell.h"

@interface ResRecommendVC : UIViewController<RequestDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) ResRecommendObj *resRecommendObj;
@property (nonatomic, strong) RestaurantObj *restaurantObj;
@end
