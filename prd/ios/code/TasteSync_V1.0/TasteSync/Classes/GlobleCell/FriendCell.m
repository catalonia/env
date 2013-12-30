//
//  FriendCell.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "FriendCell.h"
#import "CommonHelpers.h"

@interface FriendCell ()
{
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UIButton *btn;
    UserObj *userObj;
}

- (IBAction)actionButton:(id)sender;
- (IBAction)actionAdd:(id)sender;
- (IBAction)actionMinus:(id)sender;
- (IBAction)actionAvatar:(id)sender;

@end

@implementation FriendCell
@synthesize btAdd=_btAdd,
tfName=_tfName;

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

- (IBAction)actionButton:(id)sender
{
    if (!userObj.isSelected) {
        userObj.isSelected = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forButton:btn];
    }
    else
    {
        userObj.isSelected = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check.png"] forButton:btn];
    }
}
- (IBAction)actionAdd:(id)sender
{
    [self.delegate friendCell:self didAction:nil tag:FriendCellActionTagAdd];
}

- (IBAction)actionMinus:(id)sender
{
    [self.delegate friendCell:self didAction:userObj tag:FriendCellActionTabMinus];

}

- (IBAction)actionAvatar:(id)sender
{
    if (userObj.uid != 0) {
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];

    }
}

- (void) initForCell:(UserObj *) user
{
    userObj = user;
    
//    ivAvatar.image = [CommonHelpers getImageFromName:@"avatar.png"];
    ivAvatar.image = nil;
    
    if (user) {
        if ((user.firstname != nil) && (user.lastname != nil)) {
            _tfName.text = [NSString stringWithFormat:@"%@ %@",user.firstname,user.lastname];
        }
        
        if (user.avatar !=nil) {
            debug(@"FriendCell -> avatar # nil");
            ivAvatar.image = user.avatar;
        }
        else if(user.avatarUrl != nil)
        {
            debug(@"FriendCell -> avatar == nil");
            
            if(user.status_avatar == UserAvatarStatusNotLoad)
            {
                debug(@"FriendCell -> avatar not load  urlAvatar-> %@",user.avatarUrl);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    user.status_avatar = UserAvatarStatusLoading;
                    user.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
                    debug(@"load image finish -> user name -> %@", user.firstname);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        ivAvatar.image = user.avatar;
                        user.status_avatar = UserAvatarStatusLoaded;
                    
                        
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




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self.delegate friendCell:self shouldBeginEditingTextField:textField option:0];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"friendCell -> textFieldDidEndEditing textField.text = %@", textField.text);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString
                 :(NSString *)string
{
    
    [self.delegate friendCell:self didChangeTextFieldWithString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    
    return YES;
}



- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
       
    return YES;
}



@end
