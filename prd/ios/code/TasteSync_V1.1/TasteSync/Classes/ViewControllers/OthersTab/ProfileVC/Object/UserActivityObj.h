//
//  UserActivityObj.h
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"

@interface UserActivityObj : NSObject

@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) NSString *content;

@end
