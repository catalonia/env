//
//  FacebookFriendsVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/16/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "CRequest.h"

@interface FacebookFriendsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate,UIAlertViewDelegate, RequestDelegate>
{
    __weak IBOutlet UITableView *tbvFriends,*tbvResult,*tbvFilter;
    __weak IBOutlet UITextField *tfSearch;
    __weak IBOutlet UIScrollView *scrollViewMain;
}

@property (nonatomic, strong) NSMutableArray *arrData1, *arrData2, *arrDataFriends, *arrDataFilter;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionHideKeyPad:(id)sender;

@end
