//
//  PromptSignUpVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/28/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptSignUpVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbvFriends;
}

@property (nonatomic, strong) NSMutableArray *arrData;

- (IBAction)actionConnectFacebook:(id)sender;

@end
