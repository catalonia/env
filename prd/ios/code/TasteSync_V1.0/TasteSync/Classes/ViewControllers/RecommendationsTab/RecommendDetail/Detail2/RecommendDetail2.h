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

@protocol RecommentDetail2Protocol <NSObject>
-(void)gotoNextNotify:(NotificationObj*)obj index:(int)index;
@end

@interface RecommendDetail2 : UIViewController<RequestDelegate, TextviewDelegate>

@property (nonatomic, strong) NotificationObj* notificationObj;
@property (nonatomic, assign) int indexOfNotification,totalNotification;
@property (nonatomic, assign) id<RecommentDetail2Protocol> delegate;
@property (nonatomic, strong) NSMutableArray *arrData,*arrDataRestaurant,*arrDataFilter;
@property (nonatomic, strong) CustomDelegate *global;

@end
