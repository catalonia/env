//
//  FriendProfileCell.h
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@interface FriendProfileCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbName;
    __weak IBOutlet UIImageView *ivAvatar;
    
}


- (void) initCell:(UserObj *)anUserObj;
- (IBAction)actionSelectUser:(id)sender;

@end
