//
//  ResMenuCell.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResMenuCell.h"

@interface ResMenuCell ()
{
    __weak IBOutlet UILabel *lbFoodName, *lbPrice;
}

@end

@implementation ResMenuCell

- (void) initForCell:(FoodObj *) obj
{
    if (obj) {
        lbFoodName.text = obj.name;
        lbPrice.text = [NSString stringWithFormat:@"$%.2f",obj.price];
    }
}


@end
