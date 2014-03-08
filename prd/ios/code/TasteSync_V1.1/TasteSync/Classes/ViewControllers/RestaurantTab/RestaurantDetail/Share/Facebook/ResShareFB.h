//
//  ResShareFB.h
//  TasteSync
//
//  Created by Victor on 1/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"

@interface ResShareFB : UIView<UITextViewDelegate>
{
    __weak IBOutlet UITextView *tvMsg;
    __weak IBOutlet UILabel *lbNameRes, *lbDetailRes,*lbTextHolder;


}

@property (nonatomic, strong) RestaurantObj* restaurantObj;

- (IBAction)actionClose:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionTouchs:(id)sender;


@end
