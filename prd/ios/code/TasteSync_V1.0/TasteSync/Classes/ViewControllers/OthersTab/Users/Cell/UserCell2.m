//
//  UserCell2.m
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "UserCell2.h"

@interface UserCell2 ()
{
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName, *lbStatus;
    __weak IBOutlet UIButton *btFollow,*btAvatar;
    UserObj *userObj;
}
- (IBAction)actionFollow:(id)sender;

@end

@implementation UserCell2


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

# pragma mark - IBAction Define

- (IBAction)actionFollow:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       sleep(1);
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          userObj.status = UserStatusFollow;
                                          [self initForView:userObj];
                                      });
                   });
   
    
}


# pragma  mark - public's method

- (void) initForView :(UserObj *) user
{
    btAvatar.tag = self.tag;
    userObj = user;
    if (user) {
        ivAvatar.image = user.avatar;
        lbName.text = [NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname];
        if (user.status== UserStatusFollower) {
            lbStatus.text = @"(Follows You)";
            btFollow.hidden = NO;

            
        }
        else if (user.status ==UserStatusFriend)
        {
            lbStatus.text = @"(Your Friend)";
            btFollow.hidden = YES;

            
        }
        else if(user.status ==UserStatusFollow)
        {
            lbStatus.text = @"(You Follow him)";
            btFollow.hidden = YES;
        }
        else
        {
            lbStatus.text = @"";
            btFollow.hidden = YES;

        }
    }
    
}
@end
