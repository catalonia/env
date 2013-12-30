//
//  AskObject.h
//  TasteSync
//
//  Created by Phu Phan on 11/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSGlobalObj.h"

@interface AskObject : NSObject
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,strong) TSGlobalObj* object;
@end
