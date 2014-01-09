//
//  CTZoomView.h
//  MyProofs
//
//  Created by Linh NGUYEN on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTImageViewDetail;

@interface CTZoomView : UIScrollView
{
    int tapCount;
    BOOL IS_TAP;
}

@property (nonatomic, retain) IBOutlet CTImageViewDetail *imvZoom;

- (void) fixedZoomSize;

- (void) fixedSwipeSize;

- (void)fixedImageSize:(UIImageView *)imageView;

- (void)handleRotateOrientation;

- (void) zoomViewDoubleTapped;


@end
