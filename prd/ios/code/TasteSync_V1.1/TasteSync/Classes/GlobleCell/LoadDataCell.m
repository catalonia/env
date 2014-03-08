//
//  LoadDataCell.m
//  TasteSync
//
//  Created by Phu Phan on 11/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "LoadDataCell.h"
@interface LoadDataCell()
{
    
}
@end
@implementation LoadDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [indicate startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
