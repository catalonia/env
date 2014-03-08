//
//  Step1VC.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "User.h"

@interface Step1VC : UIViewController

@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableArray *arrDataFilter,*arrDataFriends;
@property (nonatomic, strong) User *userObj;
@end
