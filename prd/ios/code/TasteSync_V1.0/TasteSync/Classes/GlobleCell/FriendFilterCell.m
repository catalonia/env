//
//  FriendFilterCell.m
//  TasteSync
//
//  Created by Victor on 1/7/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "FriendFilterCell.h"
#import "CommonHelpers.h"
@interface FriendFilterCell ()
{
    __weak IBOutlet UILabel *lbName;
    __weak IBOutlet UIImageView *ivAvatar;
    UserObj *userObj;
}

- (IBAction)actionAvatar:(id)sender;

@end

@implementation FriendFilterCell

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


- (void) initForCell:(UserObj *) user
{
    userObj = user;
    
    [self loadData];
    
}

- (void) initWithName:(NSString *) aName
{
    ivAvatar.hidden = YES;
    lbName.text = aName;
    [lbName setFrame:CGRectMake(5, lbName.frame.origin.y, lbName.frame.size.width, lbName.frame.size.height)];
    
}

- (void)loadData
{
    if (userObj) {
        
        if (/*[UserDefault userDefault].loginStatus != STASTUS_LOGIN_EMAIL_ID*/TRUE) {
            lbName.text = [NSString stringWithFormat:@"%@", userObj.name];
            
        }else
        {
            lbName.text = userObj.email;
            
        }
        
        if (userObj.avatar != nil) {
            debug(@"FriendCell -> avatar # nil");
            ivAvatar.image = userObj.avatar;
        }
        else if(userObj.avatarUrl != nil)
        {
            debug(@"FriendCell -> avatar == nil");
            
            if(userObj.status_avatar == UserAvatarStatusNotLoad)
            {
                debug(@"FriendCell -> avatar not load  urlAvatar-> %@",userObj.avatarUrl);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    userObj.status_avatar = UserAvatarStatusLoading;
                    if (userObj.avatar == nil) {
                        [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
                    }
                    else
                        ivAvatar.image = userObj.avatar;
                    debug(@"load image finish -> user name -> %@", userObj.firstname);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ivAvatar.image = userObj.avatar;
                        userObj.status_avatar = UserAvatarStatusLoaded;
                    });
                    
                });
                
            }
        }
        else
        {
            debug(@"FriendCell -> no avatar");
            
        }
        
    }
}

- (IBAction)actionAvatar:(id)sender
{
    debug(@"FriendFilterCell - > actionAvatar");
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];
}

-(void)loadAvatar
{
    userObj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userObj.avatarUrl]]];
    ivAvatar.image = userObj.avatar;
}

@end
