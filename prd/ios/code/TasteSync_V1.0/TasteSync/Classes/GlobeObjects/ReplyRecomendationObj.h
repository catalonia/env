//
//  ReplyRecomendationObj.h
//  TasteSync
//
//  Created by HP on 9/25/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"
@interface ReplyRecomendationObj : NSObject
@property(nonatomic,strong) NSString* replyText;
@property(nonatomic,strong) NSString* recommenderUserFolloweeFlag;
@property(nonatomic,strong) UserObj* userObj;
@end
