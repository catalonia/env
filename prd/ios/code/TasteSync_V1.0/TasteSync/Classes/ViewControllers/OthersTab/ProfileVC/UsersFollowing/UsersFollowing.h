//
//  UsersFollowing.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/15/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import "CRequest.h"

@interface UsersFollowing : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, RequestDelegate>
{
    __weak IBOutlet UITableView *tbvResult, *tbvFilter;
    __weak IBOutlet UITextField *tfSearch;
    __weak IBOutlet UILabel *lbTitle, *lbSwipe;
    __weak IBOutlet UIView *viewSearch;
}


@property (nonatomic, assign) BOOL viewFollowing;
@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) NSMutableArray *arrData, *arrDataUser, *arrDataFilter;

@end
