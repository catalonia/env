//
//  AlertCustom.m
//  TasteSync
//
//  Created by Victor on 1/30/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "AlertCustom.h"
#import "CommonHelpers.h"

@implementation AlertCustom

- (id)initWithFrame:(CGRect)frame
{
    CGRect _frame = CGRectMake(30, 80, 220, 60);
    self = [super initWithFrame:_frame];
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"AlertCustom" owner:self options:nil] objectAtIndex:0];
        rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(0, 5, 100, 25)];
        [_viewCustom addSubview:rateCustom];
    }
    return self;
}

- (IBAction)actionNo:(id)sender
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)actionRate:(id)sender
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    

}

- (id) initForView:(RestaurantObj *)obj
{
    self = [self initWithFrame:CGRectZero];
    
    [rateCustom setRateMedium:3];
    
    restaurantObj = [[RestaurantObj alloc] init];
    restaurantObj.name = @"Nanking";
    restaurantObj.nation = @"American";
    
    
    NSString *msg = [NSString stringWithFormat:@"Did you end up going to Nanking \n\n\n"];
    
    alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alertView addSubview:self];    
          
    return self;

}

- (void) show
{
    [alertView show];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
