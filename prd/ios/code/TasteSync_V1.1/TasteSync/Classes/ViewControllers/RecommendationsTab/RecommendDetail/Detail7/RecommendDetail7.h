//
//  RecommendDetail1.h
//  TasteSync
//
//  Created by Victor on 12/26/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObj.h"
#import "TextView.h"
#import "CustomDelegate.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface RecommendDetail7 : UIViewController<TextviewDelegate, RequestDelegate>

@property (nonatomic, strong) NotificationObj *notificationObj;
@property (nonatomic, assign) int indexOfNotification,totalNotification;

@property (nonatomic, strong) NSMutableArray *arrData,*arrDataRestaurant,*arrDataFilter;
@property (nonatomic, strong) CustomDelegate *global;
@end
