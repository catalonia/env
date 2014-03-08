//
//  TagDefault.m
//  TagViewCustom
//
//  Created by Victor NGO on 3/14/13.
//  Copyright (c) 2013 Mobioneer Co.Ltd. All rights reserved.
//

#import "TagDefault.h"

@interface TagDefault ()

@end

@implementation TagDefault

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle ] loadNibNamed:@"TagDefault" owner:self options:nil] objectAtIndex:0];
    }
    return self;
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
