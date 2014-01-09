//
//  ResRecommendDetailVC.h
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResRecommendObj.h"
#import "RestaurantObj.h"
#import "TextView.h"
#import "ReplyRecomendationObj.h"

@interface ResRecommendDetailVC : UIViewController<TextviewDelegate>

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) ResRecommendObj *resRecommendObj;
@property (nonatomic, strong) RestaurantObj *restaurantObj;
@property (nonatomic, strong) ReplyRecomendationObj *replyRecomendationObj;
@property (nonatomic, assign) BOOL fromRecomendation;

@end
