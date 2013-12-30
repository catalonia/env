//
//  CFacebook.h
//  TasteSync
//
//  Created by Victor on 1/18/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoadView.h"



@class CFacebook;

@protocol CFacebookDelegate <NSObject>

@optional

- (void) cFacebook:(CFacebook *)aCFacebook didFinish:(id) anObj tagAction:(int) aTag;


@end

@interface CFacebook : NSObject<CFacebookDelegate>
{
    
}

enum {
    
    CFacebookTagActionLogin =   1,
    CFacebookTagActionGetUserInfo   =   2,
    CFacebookTagActionGetFriendsInfo    =   3,
    CFacebookTagActionError     =   -1
    
};

@property (nonatomic, strong) id<CFacebookDelegate> delegate;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL done;
@property (nonatomic, strong) LoadView *loadView;

- (void) getUserInfo:(id<CFacebookDelegate>) aDelegate tagAction:(int) aTag;

- (void) getUserFriends:(id<CFacebookDelegate>) aDelegate tagAction:(int) aTag;

- (void) login:(id<CFacebookDelegate>) aDelegate tagAction:(int) aTag;

- (void)sendMessageToFBID:(NSString*)uid   Message:(NSString*)message;
@end
