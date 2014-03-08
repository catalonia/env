//
//  SpotCell.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "SpotCell.h"

@interface SpotCell ()

- (IBAction)actionChoose:(id)sender;

@end


@implementation SpotCell

@synthesize delegate,lbDefaultMeal,
tfRestaurant;

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
    NSLog(@"actionChoose ");
    [self.delegate didActionChooseWithTag:self.tag];
}


@end
