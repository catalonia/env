//
//  FeedDetailCell.m
//  TasteSync
//
//  Created by Victor NGO on 12/23/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "FeedDetailCell.h"
#import "CommonHelpers.h"

@interface FeedDetailCell ()<UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName,*lbTimestamp,*lbTotalLikes;
    __weak IBOutlet UITextView *tvMsg;
    __weak IBOutlet UIView *viewBottom;
    __weak IBOutlet UIButton *btLike;
    FeedObj *feedObj;
}
- (IBAction)actionShowTotalLikes:(id)sender;

- (IBAction)actionLike:(id)sender ;

- (IBAction)actionProfile:(id)sender;

@end

@implementation FeedDetailCell

@synthesize delegate=_delegate;

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
    feedObj= obj;
    ivAvatar.image = obj.user.avatar;
    NSString *firstCh = [obj.user.lastname substringToIndex:1];
    lbName.text = [NSString stringWithFormat:@"%@ %@",obj.user.firstname,firstCh];
    tvMsg.text = obj.message;
    lbTimestamp.text = obj.timestamp;
    if (feedObj.numberOfLikes == 0) {
        
        lbTotalLikes.hidden = YES;
        
    }else if(feedObj.numberOfLikes == 1)
    {
        lbTotalLikes.hidden = NO;
        lbTotalLikes.text = [NSString stringWithFormat:@"%d Like",feedObj.numberOfLikes];
        
    }
    else
    {
        lbTotalLikes.hidden = NO;
        lbTotalLikes.text = [NSString stringWithFormat:@"%d Likes",feedObj.numberOfLikes];
        
    }

    
  
}

#pragma mark - IBAction Define

- (IBAction)actionShowTotalLikes:(id)sender
{
    [self.delegate feedDetailCellDidShowLikes:feedObj];
}

- (IBAction)actionLike:(id)sender 
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"We will never post to your wall without your permission" delegate:self tag:0];
    }
    else
    {
        if (feedObj.isLike) {
            feedObj.isLike = NO;
            feedObj.numberOfLikes --;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
        }
        else
        {
            feedObj.isLike = YES;
            feedObj.numberOfLikes ++;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
            
        }
        
        if (feedObj.numberOfLikes == 0) {
            lbTotalLikes.hidden = YES;
        }else if(feedObj.numberOfLikes == 1)
        {
            lbTotalLikes.hidden = NO;
            lbTotalLikes.text = [NSString stringWithFormat:@"%d Like",feedObj.numberOfLikes];
            
        }
        else
        {
            lbTotalLikes.hidden = NO;            
            lbTotalLikes.text = [NSString stringWithFormat:@"%d Likes",feedObj.numberOfLikes];
            
        }

    }

}
- (IBAction)actionProfile:(id)sender
{
    debug(@"actionProfile");
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:feedObj.user];
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
