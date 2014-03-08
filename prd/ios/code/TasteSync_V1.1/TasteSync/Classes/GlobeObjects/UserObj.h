//
//  UserObj.h
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObj : NSObject

typedef enum _UserStatus {
    UserStatusFollower = 1,
    UserStatusFollow  =   2,
    UserStatusFriend  =   3
    
} UserStatus;

typedef enum _UserStatusAvatar {
    UserAvatarStatusNotLoad = 0,
    UserAvatarStatusLoading  =   1,
    UserAvatarStatusLoaded  =   2
    
} UserStatusAvatar;

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString *firstname, *lastname, *email, *city, *state;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *middle_name, *username, *birthday_date, *third_party_id, *install_type, *relationship_status, *name, *locate, *link, *age_range, *hometown_location, *location, *device, *checkIn, *friends, *permission;
@property (nonatomic, assign) int friend_count, timezone, likes_count;
@property (nonatomic, assign) BOOL verified;
//ARRAY devices
//STRUCT hometown_location, current_location
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign) int gender;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) int status_avatar; // 0 not load, 1 loading , 2 loaded
@property (nonatomic, assign) BOOL isTasteSyncUser;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL flag;
//uid, name, first_name, middle_name, last_name, sex , locale, username, birthday_date, third_party_id, friend_count, install_type, timezone, verified, devices, email, hometown_location, current_location, pic_square, relationship_status, likes_count, affiliations
@end
