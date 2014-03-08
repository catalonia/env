//
//  GlobalNotification.h
//  TasteSync
//
//  Created by Victor on 1/29/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationObj.h"
#import "CRequest.h"
typedef enum
{
    RecommendationNotification = 1,
    RecommendationShuffle = 2
}RecommendationType;
@protocol NotificationDelegate
-(void)getDataSuccess:(RecommendationType)type;;
@end
@interface GlobalNotification : NSObject<RequestDelegate>

@property (nonatomic, assign) int total,unread,read, index;
@property (nonatomic, strong) NSMutableArray *arrData,*arrDataRead;
@property (nonatomic, strong) NSMutableArray *arrDataShuffle,*arrDataReadShuffle;
@property (nonatomic, strong) NotificationObj *notifObj;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) id<NotificationDelegate> delegate;
@property (nonatomic, assign) int pageLoad;
- (id) initWithALlType;

- (NotificationObj *) gotoNextNotification;

-(void)requestData:(UIView*)view Type:(RecommendationType)type;
-(void)reloadUpData:(int)pageReload view:(UIView*)view Type:(RecommendationType)type;
-(void)reloadDownData:(UIView*)view Type:(RecommendationType)type;
-(void)reloadDownDataToNotifycation:(int)countNumber View:(UIView*)view;
-(void)requestRestaurantData:(UIView*)view;
@end
