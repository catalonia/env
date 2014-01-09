//
//  RestaurantQuestionCell.m
//  TasteSync
//
//  Created by HP on 8/28/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RestaurantQuestionCell.h"
#import "CommonHelpers.h"

@interface RestaurantQuestionCell()
{
    BOOL check;
    NSString* _imageLink;
}
@end

@implementation RestaurantQuestionCell

@synthesize imageLink = _imageLink;

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
    check = NO;
    [self.indicator startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionCheck:(id)sender
{
    if (check) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check.png"] forButton:self.ticker];
        check = NO;
        [self.delegate checkStatus:self.userObj checked:NO];
    }
    else {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forButton:self.ticker];
        check = YES;
        [self.delegate checkStatus:self.userObj checked:YES];
    }
}

-(void)setImageLink:(NSString *)imageLink
{
    _imageLink = imageLink;
    [NSThread detachNewThreadSelector:@selector(setImage) toTarget:self withObject:nil];
}

-(void)setImage
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageLink]]];
    self.image.image = image;
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
}

@end
