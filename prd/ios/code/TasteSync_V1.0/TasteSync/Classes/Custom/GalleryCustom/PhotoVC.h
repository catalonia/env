//
//  PhotoVC.h
//  BikiniOfWorld
//
//  Created by Vidic Phan on 3/8/13.
//  Copyright (c) 2013 Vidic Phan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTScrollView;
@class CTImageViewDetail;
@class CTZoomView;
#import "MessageUI/MFMailComposeViewController.h"

@interface PhotoVC : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrayObjects;
@property (nonatomic, assign) NSUInteger indexSelected;

//Main
@property (nonatomic, strong) IBOutlet CTScrollView *scrollView;
@property (nonatomic, strong) IBOutlet CTZoomView *zoomView;


-(id)initWithArrayPhotos:(NSMutableArray*)arrayPhotos AtIndex:(NSUInteger)index;
@end
