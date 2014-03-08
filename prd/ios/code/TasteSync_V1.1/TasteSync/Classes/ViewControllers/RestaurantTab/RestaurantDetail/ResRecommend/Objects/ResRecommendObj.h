//
//  ResRecommendObj.h
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserObj.h"
typedef enum
{
    TipNone = 1,
    TipFrom4SQ = 2,
    TipFromTS = 3
}RecomendationType;
@interface ResRecommendObj : NSObject

@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *title,*detail;
@property (nonatomic, strong) NSString *recotext;
@property (nonatomic, assign) int numberOfLikes;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) RecomendationType tipID;

@end
