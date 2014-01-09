//
//  CTImageViewDetail.h
//  PhotoDetails
//
//  Created by Pro4Pro, LLC on 3/10/12.
//  Copyright 2012 Pro4Pro, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CTImageViewDetail : UIImageView {
    
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIButton *btnPlay;

- (void) startIndicatorAnimating;
- (void) stopIndicatorAnimating;

@end
