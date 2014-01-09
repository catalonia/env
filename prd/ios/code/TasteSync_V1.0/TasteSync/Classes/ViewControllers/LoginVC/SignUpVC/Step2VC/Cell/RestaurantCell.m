//
//  RestaurantCell.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "RestaurantCell.h"

@interface RestaurantCell ()
{
    
}

- (IBAction)actionChoose:(id)sender;

- (IBAction)actionAddNewBox:(id)sender;

- (IBAction)actionRemoveBox:(id)sender;


@end

@implementation RestaurantCell
@synthesize lbRestaurant,btAdd;

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

#pragma mark - IBAction Define

- (IBAction)actionChoose:(id)sender
{
    NSLog(@"actionChoose");
    if (self.isNative) {
        [self.delegate didActionWithTag:RestaurantCellActionTagChooseNative atIndex:self.tag];
        
    }
    else
    {
        [self.delegate didActionWithTag:RestaurantCellActionTagChooseOther atIndex:self.tag];
        
    }}
- (IBAction)actionAddNewBox:(id)sender
{
    if (self.isNative) {
        [self.delegate didActionWithTag:RestaurantCellActionTagAddNative atIndex:self.tag];

    }
    else
    {
        [self.delegate didActionWithTag:RestaurantCellActionTagAddOther atIndex:self.tag];

    }

}

- (IBAction)actionRemoveBox:(id)sender
{
    if (self.isNative) {
        [self.delegate didActionWithTag:RestaurantCellActionTagRemoveNative atIndex:self.tag];
        
    }
    else
    {
        [self.delegate didActionWithTag:RestaurantCellActionTagRemoveOther atIndex:self.tag];
        
    }
}



@end
