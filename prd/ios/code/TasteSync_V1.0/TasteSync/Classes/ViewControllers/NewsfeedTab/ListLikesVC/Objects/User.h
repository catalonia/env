//
//  User.h
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
#define USER_STATUS_FOLLOWER  1
#define USER_STATUS_FOLLOW  2
#define USER_STATUS_FRIEND  3

*/

@interface User : NSObject

typedef enum _UserStatus {
    UserFollower = 1,
    UserFollow  =   2,
    UserFriend  =   3
    
} UserStatus;

typedef enum _UserStatusAvatar {
    UserAvatarNotLoad = 0,
    UserAvatarLoading  =   1,
    UserAvatarLoaded  =   2
    
} UserStatusAvatar;

@property (nonatomic, assign) long uid;
@property (nonatomic, strong) NSString *firstname, *lastname,*email,*city,*states;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) int gender;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) int status_avatar; // 0 not load, 1 loading , 2 loaded
@property (nonatomic, assign) BOOL isTasteSyncUser;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL flag;

@end
