//
//  FriendsCell.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FriendsCell : UITableViewCell<UIAlertViewDelegate>
{
    User *user;
}

@property (nonatomic, strong) IBOutlet UIImageView *ivAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lbName;
@property (nonatomic, strong) IBOutlet UIButton *btCheck,*btInvite;

- (void) initForCell:(User *) obj;

- (IBAction)actionInvite:(id)sender;
- (IBAction)actionCheck:(id)sender;


@end
