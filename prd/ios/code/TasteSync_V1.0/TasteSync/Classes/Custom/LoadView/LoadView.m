//
//  LoadView.m
//  TasteSync
//
//  Created by Victor on 1/18/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "LoadView.h"
#import "CommonHelpers.h"
@implementation LoadView

- (id)initWithFrame:(CGRect)frame
{
    CGRect fix_frame = [[[UIApplication sharedApplication] keyWindow]bounds];
    self = [super initWithFrame:fix_frame];
    debug(@"initWithFrame");
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"LoadView" owner:self options:nil] objectAtIndex:0];
        [indicator startAnimating];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    return self;
}




@end
