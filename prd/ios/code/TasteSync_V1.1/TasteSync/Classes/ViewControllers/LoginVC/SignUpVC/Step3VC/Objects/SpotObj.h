//
//  SpotObj.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotObj : NSObject

@property (nonatomic, strong) NSString *name,*defaultMeal;

- (id) initWithName:(NSString *)i_name defaultMeal :(NSString *)i_defaultMeal;

@end
