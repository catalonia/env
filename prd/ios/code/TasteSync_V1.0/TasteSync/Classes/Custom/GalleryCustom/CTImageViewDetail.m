//
//  CTImageViewDetail.m
//  PhotoDetails
//
//  Created by Pro4Pro, LLC on 3/10/12.
//  Copyright 2012 Pro4Pro, LLC. All rights reserved.
//

#import "CTImageViewDetail.h"


@implementation CTImageViewDetail

@synthesize indicatorView;
@synthesize btnPlay;

- (void)dealloc
{
    self.indicatorView = nil;
    self.btnPlay = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    indicatorView.center = btnPlay.center = self.center;
}

- (void) startIndicatorAnimating
{
    [indicatorView startAnimating];
}

- (void) stopIndicatorAnimating
{   
    [indicatorView stopAnimating];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    indicatorView.center = btnPlay.center = center;
}

@end
