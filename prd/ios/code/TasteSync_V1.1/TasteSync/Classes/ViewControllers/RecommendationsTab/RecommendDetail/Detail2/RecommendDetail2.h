//
//  RecommendDetail2.h
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObj.h"
#import "CRequest.h"
#import "JSONKit.h"
#import "TextView.h"
#import "CustomDelegate.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7_0 @"7.0"

@protocol RecommentDetail2Protocol <NSObject>
-(void)gotoNextNotify:(NotificationObj*)obj index:(int)index;
-(int)nextReload:(UIView*)view;
@end

@interface RecommendDetail2 : UIViewController<RequestDelegate, TextviewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NotificationObj* notificationObj;
@property (nonatomic, assign) int indexOfNotification,totalNotification;
@property (nonatomic, assign) id<RecommentDetail2Protocol> delegate;
@property (nonatomic, strong) NSMutableArray *arrData,*arrDataRestaurant,*arrDataFilter;
@property (nonatomic, strong) CustomDelegate *global;

- (id)initWithShuffle;

@end
