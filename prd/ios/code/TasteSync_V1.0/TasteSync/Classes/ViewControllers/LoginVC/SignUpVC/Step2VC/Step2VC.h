//
//  Step2VC.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

#define MAX_NATIVE_CUSINE   2

@interface Step2VC : UIViewController

@property (nonatomic, strong) NSMutableArray *arrData,*arrOtherData,*arrDataNatives;
@property (nonatomic, strong) User *userObj;
@property (nonatomic, assign) BOOL IS_EDIT_PROFILE;

@end
