//
//  AlertCustom.h
//  TasteSync
//
//  Created by Victor on 1/30/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import "RateCustom.h"


@interface AlertCustom : UIView
{
    RateCustom *rateCustom;
    UIAlertView *alertView;
    RestaurantObj *restaurantObj;
    
}

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;
@property (nonatomic, weak) IBOutlet UIView *viewCustom;

- (IBAction)actionNo:(id)sender;

- (IBAction)actionRate:(id)sender;

- (id) initForView:(RestaurantObj *)obj;

- (void) show;



@end
