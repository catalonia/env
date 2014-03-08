//
//  FriendsCell.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "CommonHelpers.h"
#import "FriendsCell.h"

@implementation FriendsCell

@synthesize btCheck,btInvite,lbName,ivAvatar;

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

- (void) initForCell:(User *) obj
{
    if (obj) {
        user = obj;
        if ([UserDefault userDefault].loginStatus == LoginViaFacebook) {
            lbName.text = [NSString stringWithFormat:@"%@ %@",obj.firstname,obj.lastname];

        }else if([UserDefault userDefault].loginStatus == LoginViaEmailId)
        {
            lbName.text = obj.email;

        }
        else
        {
            
        }
        
        if (obj.isTasteSyncUser) {
            btInvite.hidden = YES;
            btCheck.hidden = NO;
        }
        else
        {
            btInvite.hidden = NO;
            btCheck.hidden = YES;
        }
        
        if (obj.avatar !=nil) {
            debug(@"FriendsCell -> avatar # nil");
            ivAvatar.image = obj.avatar;
        }
        else if(obj.avatarUrl != nil)
        {
            debug(@"FriendsCell -> avatar == nil");
            
            if(obj.status_avatar == UserAvatarNotLoad)
            {
                debug(@"FriendCell -> avatar not load  urlAvatar-> %@",obj.avatarUrl);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    obj.status_avatar = UserAvatarLoading;
                    obj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.avatarUrl]]];
                    debug(@"load image finish -> user name -> %@", obj.firstname);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ivAvatar.image = obj.avatar;
                        obj.status_avatar = UserAvatarLoaded;
                    });
                    
                });
                
            }
        }
        else
        {
            debug(@"FriendsCell -> no avatar");
        }
    }
}

#pragma mark - IBAction Define

- (IBAction)actionInvite:(id)sender
{
    debug(@"actionInvite");
    NSString *msg ;
    if ([UserDefault userDefault].loginStatus == LoginViaFacebook)
    {
        msg = [NSString stringWithFormat:@"Are you sure to invite %@",user.email];
    }
    else
    {
        msg = [NSString stringWithFormat:@"Are you sure to invite %@ %@",user.firstname,user.lastname];

    }
    
    msg = @"Are you sure to invite this friend?";
    
    [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:msg delegate:self tag:1];
    
}

- (IBAction)actionCheck:(id)sender
{
    debug(@"actionCheck");

}

# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    debug(@"FriendsCell -> clickedButtonAtIndex %d",buttonIndex);
    if (buttonIndex == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
           
            sleep(2);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [btInvite setTitle:@"Invite Sent" forState:UIControlStateNormal];
                btInvite.enabled = NO;

            });
            
        });
    }
    
}


@end
