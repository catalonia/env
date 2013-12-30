//
//  Detail4Cell.m
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "Detail4Cell.h"
#import "CommonHelpers.h"

@interface Detail4Cell ()
{
    __weak IBOutlet UILabel *lbName;
    RestaurantObj *restaurantObj;
    __weak IBOutlet UIButton *btLike;
}

@end

@implementation Detail4Cell

- (void) initForView:(RestaurantObj *)obj
{    
    restaurantObj = obj;
    lbName.text = obj.name;
}

- (IBAction)actionLike:(id)sender
{
    if (restaurantObj.isLike) {
        restaurantObj.isLike = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
        [self.delegate pressLikeButton:self Liked:NO];
    }
    else
    {
        restaurantObj.isLike = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
        [self.delegate pressLikeButton:self Liked:YES];

    }
}

-(void)setLikeStatus:(BOOL)value
{
    if (value == NO) {
        restaurantObj.isLike = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
    }
    else
    {
        restaurantObj.isLike = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
    }
}


@end
