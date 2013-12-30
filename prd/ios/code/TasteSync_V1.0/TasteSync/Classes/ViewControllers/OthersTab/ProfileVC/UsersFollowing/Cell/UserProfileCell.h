//
//  UserProfileCell.h
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@class UserProfileCell;

@protocol UserProfileCellDelegate <NSObject>

- (void) userProfileCell:(UserProfileCell *) userProfileCell action:(id) anObj;

@end

@interface UserProfileCell : UITableViewCell
{
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName;
    __weak IBOutlet UIButton *btUnfollow;
}

@property (nonatomic, assign) BOOL allowUnfollow;
@property (nonatomic, strong) id<UserProfileCellDelegate> delegate;

- (void) initCell:(UserObj *) anUserObj;

- (IBAction)actionAvatar:(id)sender;

- (IBAction)actionUnfollow:(id)sender;

@end
