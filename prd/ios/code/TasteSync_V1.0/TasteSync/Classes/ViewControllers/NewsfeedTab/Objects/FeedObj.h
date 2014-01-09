//
//  FeedObj.h
//  TasteSync
//
//  Created by Victor on 12/21/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"

@interface FeedObj : NSObject

@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, assign) int numberOfLikes,numberOfComments;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL isLike;

@end
