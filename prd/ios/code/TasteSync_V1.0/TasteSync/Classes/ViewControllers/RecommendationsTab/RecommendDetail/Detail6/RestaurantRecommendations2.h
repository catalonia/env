//
//  RestaurantRecommendations2.h
//  TasteSync
//
//  Created by Victor on 3/14/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NotificationObj.h"
#import "CRequest.h"
#import "JSONKit.h"
#import "CustomDelegate.h"

@interface RestaurantRecommendations2 : UIViewController<RequestDelegate>
{
    __weak IBOutlet UITableView *tbv;
}
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NotificationObj *notificationObj;
@property (nonatomic, assign) int indexOfNotification,totalNotification;
@property (nonatomic, strong) CustomDelegate *global;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsFeed:(id)sender;

@end
