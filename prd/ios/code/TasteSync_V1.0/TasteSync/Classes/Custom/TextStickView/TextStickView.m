//
//  TextStickView.m
//  TasteSync
//
//  Created by Victor on 2/22/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "TextStickView.h"
#import "CommonHelpers.h"
@implementation TextStickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"TextStickView" owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
    }
    self.tfStick.enabled = YES;
    _lbText.hidden = NO;
    return self;
}

- (IBAction)actionDelete:(id)sender
{
    [self.delegate textStickView:self didAction:nil tag:1];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    _lbText.hidden = YES;
    if (_nullBox) {
        [self.delegate textStickView:self didAction:nil tag:2];

    }

    return YES;
}

@end
