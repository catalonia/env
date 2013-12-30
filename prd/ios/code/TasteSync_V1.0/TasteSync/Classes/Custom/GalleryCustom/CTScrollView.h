//
//  CTScrollView.h
//  PhotoDetails
//
//  Created by Pro4Pro, LLC on 3/10/12.
//  Copyright 2012 Pro4Pro, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTImageViewDetail;

@interface CTScrollView : UIScrollView {
    
}

@property (nonatomic, retain) IBOutlet CTImageViewDetail *imvLeft, *imvRight;

- (void) handleRotateOrientation;

- (void) fixedImageSize:(UIImageView *)imageView;

- (void) fixedSwipeSize;

@end
