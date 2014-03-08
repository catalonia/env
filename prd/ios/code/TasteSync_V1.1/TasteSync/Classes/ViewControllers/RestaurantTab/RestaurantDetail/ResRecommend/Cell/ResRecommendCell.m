//
//  ResRecommendCell.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResRecommendCell.h"
#import "CommonHelpers.h"

@interface ResRecommendCell()
{
    ResRecommendObj *resRecommendObj;
}

- (IBAction)actionAvatar:(id)sender;

@end

@implementation ResRecommendCell

- (void) initForCell:(ResRecommendObj *) obj
{
    resRecommendObj = obj;
    lbtitle.text = obj.title;
    lbDetail.text = obj.detail;
    if (obj.tipID == TipNone) {
        detail.text = [NSString stringWithFormat:@"in response to your question - %@", obj.recotext];
    }
    if (obj.tipID == TipFromTS) {
        detail.text = @"via TasteSync";
        detailImage.image = [CommonHelpers getImageFromName:@"icon_57.png"];
    }
    if (obj.tipID == TipFrom4SQ) {
        detail.text = @"via foursquare";//
        detailImage.image = [CommonHelpers getImageFromName:@"social-networks-foursquare.20131010231035.png"];
    }
    if (obj.user.avatar != nil) {
        ivAvatar.image = obj.user.avatar;
        [activity removeFromSuperview];
    }
    else
    {
        [activity startAnimating];
        [NSThread detachNewThreadSelector:@selector(loadAvatar) toTarget:self withObject:nil];
    }
    
    
    if (obj.numberOfLikes == 0) {
        lbNumberLike.hidden = YES;
    }
    else if (obj.numberOfLikes ==1)
    {
        lbNumberLike.hidden = NO;
        lbNumberLike.text = [NSString stringWithFormat:@"%d Like",obj.numberOfLikes];

    }
    else
    {
        lbNumberLike.hidden = NO;
        lbNumberLike.text = [NSString stringWithFormat:@"%d Likes",obj.numberOfLikes];
    }
}

- (IBAction)actionLike:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        if (resRecommendObj.isLike) {
            resRecommendObj.isLike = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
            resRecommendObj.numberOfLikes --;
        }
        else
        {
            resRecommendObj.isLike = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
            resRecommendObj.numberOfLikes ++;
        }
        
        if (resRecommendObj.numberOfLikes == 0) {
            lbNumberLike.hidden = YES;
        }
        else if (resRecommendObj.numberOfLikes ==1)
        {
            lbNumberLike.hidden = NO;
            lbNumberLike.text = [NSString stringWithFormat:@"%d Like",resRecommendObj.numberOfLikes];
            
        }
        else
        {
            lbNumberLike.hidden = NO;
            lbNumberLike.text = [NSString stringWithFormat:@"%d Likes",resRecommendObj.numberOfLikes];
        }
    }
}

- (IBAction)actionAvatar:(id)sender
{
    if (resRecommendObj.tipID != TipFrom4SQ)
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:resRecommendObj.user];
}

-(void)loadAvatar
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:resRecommendObj.user.avatarUrl]]];
    resRecommendObj.user.avatar = image;
    ivAvatar.image = image;
    [activity stopAnimating];
    [activity removeFromSuperview];
}
@end