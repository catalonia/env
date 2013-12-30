//
//  TasteSyncFriends.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/24/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface TasteSyncFriends : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIActionSheetDelegate, RequestDelegate>
{
    __weak IBOutlet UITableView *tbvResult, *tbvFilter;
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UITextField *tfSearch;
}

@property (nonatomic, strong) UserObj  *user;
@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSMutableArray *arrData, *arrDataFilter;



- (IBAction)actionBack:(id)sender;


@end
