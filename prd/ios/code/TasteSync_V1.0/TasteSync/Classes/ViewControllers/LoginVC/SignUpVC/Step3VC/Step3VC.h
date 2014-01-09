//
//  Step3VC.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface Step3VC : UIViewController

@property(nonatomic, strong) NSMutableArray *arrData,*arrMealData,*arrDataFilter,*arrDataSpot;
@property(nonatomic, strong) User *userObj;

@end
