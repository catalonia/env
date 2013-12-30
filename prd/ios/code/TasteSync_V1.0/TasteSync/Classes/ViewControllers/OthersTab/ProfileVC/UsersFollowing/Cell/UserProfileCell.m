//
//  UserProfileCell.m
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "UserProfileCell.h"
#import "CommonHelpers.h"

@interface UserProfileCell ()
{
    UserObj *userObj;
    CGPoint touchPoint;
    BOOL unfollowButtonShown;
    UITapGestureRecognizer *tapRecognizer;
    UISwipeGestureRecognizer *swipeRecognizer;
}
@end

@implementation UserProfileCell

- (void) initCell:(UserObj *) anUserObj
{
    userObj = anUserObj;
    if (anUserObj) {
        
        if (userObj.avatar == nil) {
            [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
        }
        else
            ivAvatar.image = userObj.avatar;
        
        lbName.text = [NSString stringWithFormat:@"%@", anUserObj.name];
    }
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAvatar:)];
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe)];
    
    [self addGestureRecognizer:tapRecognizer];
    [self addGestureRecognizer:swipeRecognizer];
    
    btUnfollow.hidden = YES;
}

- (IBAction)actionAvatar:(id)sender
{
    debug(@"actionAvatar");
    if (unfollowButtonShown) {
        btUnfollow.hidden = YES;
        unfollowButtonShown = NO;
        return;
    }
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];

}

- (IBAction)actionUnfollow:(id)sender
{
    unfollowButtonShown = NO;
    btUnfollow.hidden = YES;
    [self.delegate userProfileCell:self action:nil];
}

- (void)actionSwipe
{
    debug(@"actionSwipe");
    if (!unfollowButtonShown) {
        btUnfollow.hidden = NO;
        unfollowButtonShown = YES;
    }
}

-(void)loadAvatar
{
    userObj.avatar = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userObj.avatarUrl]]];
    ivAvatar.image = userObj.avatar;
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch began");
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
    if (unfollowButtonShown) {
        btUnfollow.hidden = YES;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch move");
       
    UITouch *touch = [touches anyObject];
    CGPoint newTouchPoint = [touch locationInView:self];
    if (fabsf(touchPoint.x  - newTouchPoint.x) > 25.0 ) {
        NSLog(@"Swiping horizontally across");
        if (_allowUnfollow) {
            unfollowButtonShown = YES;
            btUnfollow.hidden = NO;

        }
    }
    else
    {
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch end");
    if (unfollowButtonShown) {
        unfollowButtonShown = NO;
        return;
    }
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userObj];

}
 
 */

@end
