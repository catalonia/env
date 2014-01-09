//
//  FriendProfileCell.m
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "FriendProfileCell.h"
#import "CommonHelpers.h"

@interface FriendProfileCell ()
{
    UserObj *userObj;
}
@end

@implementation FriendProfileCell

- (void) initCell:(UserObj *)anUserObj
{
    userObj = anUserObj;
    if (anUserObj) {
        ivAvatar.hidden = NO;
        lbName.hidden = NO;
        lbName.text = [NSString stringWithFormat:@"%@", anUserObj.name];
        if (userObj.avatar == nil) {
            [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
        }
        else
            ivAvatar.image = userObj.avatar;
    }
    else
    {
        ivAvatar.hidden = YES;
        lbName.hidden = YES;
    }
       
}
- (IBAction)actionSelectUser:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    switch (bt.tag) {
        case 1:
        {
            if (userObj) {
                [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];
            }
        }
            break;
                    
        default:
            break;
    }
    
}

-(void)loadAvatar
{
    @autoreleasepool {
        userObj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userObj.avatarUrl]]];
        ivAvatar.image = userObj.avatar;
    }
    
}

@end
