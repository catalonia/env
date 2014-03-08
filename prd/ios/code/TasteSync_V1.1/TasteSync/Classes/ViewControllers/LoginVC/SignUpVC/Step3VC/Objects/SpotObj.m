//
//  SpotObj.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "SpotObj.h"

@implementation SpotObj
@synthesize name,defaultMeal;

- (id) initWithName:(NSString *)i_name defaultMeal :(NSString *)i_defaultMeal
{
    self = [super init];
    if (self) {
        self.name = i_name;
        self.defaultMeal = i_defaultMeal;
    }
    return self;
}

@end
