//
//  FeedCell.m
//  TasteSync
//
//  Created by Victor on 12/21/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "FeedCell.h"
#import "CommonHelpers.h"

@interface FeedCell ()<UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *avatar;
    __weak IBOutlet UILabel *lbName,*lbTimeStamp;
    __weak IBOutlet UITextView *tvMsg;
    __weak IBOutlet UILabel *lbUsersLike,*lbUnknow;
    __weak IBOutlet UIView *viewBottom;
    __weak IBOutlet UIButton *btMore,*btLike;
}
- (IBAction)actionShowUsersLike:(id)sender;

- (IBAction)actionUnknow:(id)sender;

- (IBAction)actionLike:(id)sender;

- (IBAction)actionComment:(id)sender;

- (IBAction)actionMore:(id)sender;

- (IBAction)actionProfile:(id)sender;

@end

@implementation FeedCell

@synthesize feedObj=_feedObj,
delegate=_delegate,
flag;

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

- (void) initForView:(FeedObj *) obj
{
    self.feedObj = obj;

    if (flag) {
        btMore.hidden = YES;
        tvMsg.text = obj.message;

    }
    else
    {
        NSString *msg = obj.message;
        if (msg.length<100) {
            tvMsg.text = msg;
        }else
        {
            NSString *subMsg = [msg substringToIndex:99];
            tvMsg.text = [NSString stringWithFormat:@"%@...more",subMsg];
        }
       
    }
    
    avatar.image = obj.user.avatar;
    NSString *firstCh = [obj.user.lastname substringToIndex:1];
    lbName.text = [NSString stringWithFormat:@"%@ %@",obj.user.firstname,firstCh];
    lbTimeStamp.text = obj.timestamp;
    if (obj.numberOfLikes == 0) {
        lbUsersLike.hidden = YES;
    }else if(obj.numberOfLikes == 1)
    {
        lbUsersLike.hidden = NO;

        lbUsersLike.text = [NSString stringWithFormat:@"%d Like",obj.numberOfLikes];

    }
    else
    {
        lbUsersLike.hidden = NO;

        lbUsersLike.text = [NSString stringWithFormat:@"%d Likes",obj.numberOfLikes];

    }
    
    if (obj.numberOfComments == 0) {
        lbUnknow.hidden = YES;
    }else if(obj.numberOfComments == 1)
    {
        lbUnknow.hidden = NO;

        lbUnknow.text = [NSString stringWithFormat:@"%d Comment",obj.numberOfComments];
        
    }
    else
    {
        lbUnknow.hidden = NO;

        lbUnknow.text = [NSString stringWithFormat:@"%d Comments",obj.numberOfComments];
        
    }
    
}



#pragma mark - IBAction Define

- (IBAction)actionShowUsersLike:(id)sender
{
    [self.delegate feedCellDidActionShowUsersLike:self.feedObj];
}

- (IBAction)actionUnknow:(id)sender
{
    
}

- (IBAction)actionLike:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"We will never post to your wall without your permission" delegate:self tag:0];
    }
    else
    {
        if (self.feedObj.isLike) {
            self.feedObj.isLike = NO;
            self.feedObj.numberOfLikes --;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
        }
        else
        {
            self.feedObj.isLike = YES;
            self.feedObj.numberOfLikes ++;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];

        }
        
        if (self.feedObj.numberOfLikes == 0) {
            lbUsersLike.hidden = YES;
        }else if(self.feedObj.numberOfLikes == 1)
        {
            lbUsersLike.hidden = NO;
            lbUsersLike.text = [NSString stringWithFormat:@"%d Like",self.feedObj.numberOfLikes];
            
        }
        else
        {
            lbUsersLike.hidden = NO;

            lbUsersLike.text = [NSString stringWithFormat:@"%d Likes",self.feedObj.numberOfLikes];
            
        }

    }
   
}

- (IBAction)actionComment:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"We will never post to your wall without your permission" delegate:self tag:0];
    }
    else
    {
        [self.delegate feedCellDidActionComment:self.feedObj];

    }
}

- (IBAction)actionMore:(id)sender
{
    [self.delegate feedCellDidActionShowMore:self.tag];
}

- (IBAction)actionProfile:(id)sender
{
    debug(@"actionProfile");
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:_feedObj.user];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [[CommonHelpers appDelegate] showLoginDialog];

        }
            break;
            
        default:
            break;
    }
    
}


@end
