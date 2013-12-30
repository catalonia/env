//
//  Recommend2Obj.h
//  TasteSync
//
//  Created by Victor on 3/14/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantObj.h"
#import "UserActivityObj.h"

@interface Recommend2Obj : NSObject

@property (nonatomic, strong) RestaurantObj *restaurant;
@property (nonatomic, strong) NSMutableArray *arrUserRecommendations;

@end
