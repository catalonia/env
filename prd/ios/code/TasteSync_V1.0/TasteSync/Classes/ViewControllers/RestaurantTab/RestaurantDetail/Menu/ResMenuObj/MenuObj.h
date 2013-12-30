//
//  MenuObj.h
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodObj.h"

@interface MenuObj : NSObject

@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSMutableArray *foodArr;


@end
