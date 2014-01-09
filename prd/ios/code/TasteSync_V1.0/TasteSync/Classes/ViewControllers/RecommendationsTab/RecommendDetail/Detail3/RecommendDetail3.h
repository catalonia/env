//
//  RecommendDetail3.h
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObj.h"
#import "CustomDelegate.h"

@interface RecommendDetail3 : UIViewController

@property (nonatomic, strong) NotificationObj *notificationObj;

@property (nonatomic, assign) int indexOfNotification,totalNotification;
@property (nonatomic, strong) CustomDelegate *global;
@end
