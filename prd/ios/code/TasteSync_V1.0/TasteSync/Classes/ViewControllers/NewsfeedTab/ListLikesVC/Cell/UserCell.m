//
//  UserCell.m
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "UserCell.h"
#import "CommonHelpers.h"

@interface UserCell ()
{
   __weak IBOutlet UIImageView *ivAvatar;
   __weak IBOutlet UILabel *lbName;
    UserObj *userObj;
}

- (IBAction)actionAvatar:(id)sender;

@end

@implementation UserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

# pragma  mark - public's method

- (void) initForView :(UserObj *) user
{
    userObj = user;
    if (user) {
        ivAvatar.image = user.avatar;
        lbName.text = [NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname];
    }
   
}

- (IBAction)actionAvatar:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];
}


@end
