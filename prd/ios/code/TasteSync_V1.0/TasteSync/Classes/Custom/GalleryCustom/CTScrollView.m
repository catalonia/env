//
//  CTScrollView.m
//  PhotoDetails
//
//  Created by Pro4Pro, LLC on 3/10/12.
//  Copyright 2012 Pro4Pro, LLC. All rights reserved.
//

#import "CTScrollView.h"

#import "CTImageViewDetail.h"
#import "GlobalVariables.h"

//#define offsetLog(scrollView) NSLog(@"offset x -> %f , y: %f", scrollView.contentOffset.x, scrollView.contentOffset.y)
//
//#define contentSizeLog(scrollView) NSLog(@"contentSize w -> %f , h: %f", scrollView.contentSize.width, scrollView.contentSize.height)
//
//#define insetsLog(scrollView) NSLog(@"top: %f, left : %f, botom: %f, right: %f", scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)
//
//#define centerLog(scrollView) NSLog(@"center x:%f, y: %f", scrollView.imvCenter.center.x, scrollView.imvCenter.center.y)
//
//#define frameLog(view) NSLog(@"frame x:%f, y: %f, w: %f, h:%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)

@implementation CTScrollView

@synthesize imvLeft, imvRight;

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.superview touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.superview touchesEnded:touches withEvent:event];
//}

- (void)dealloc
{
    self.imvRight = self.imvLeft = nil;
}

- (void)handleRotateOrientation
{
    [self fixedSwipeSize];
    [self fixedImageSize:imvRight];
    [self fixedImageSize:imvLeft];
}

- (void)fixedImageSize:(UIImageView *)imageView
{
    if(imageView.image)
    {
        CGSize imageSize = imageView.image.size;
        
        CGSize scrollViewSize = self.bounds.size;
        CGFloat ratioWidth, ratioHeight, scale;
        
        ratioWidth = scrollViewSize.width / imageSize.width;
        ratioHeight = scrollViewSize.height / imageSize.height;
        
        scale = ratioWidth < ratioHeight ? ratioWidth : ratioHeight;
        scale = scale < 1.0 ? scale : 1.0;
        
        if(scale < 1.0)
        {
            imageSize.width *= scale;
            imageSize.height*= scale;
        }
        
        if(imageSize.width >= scrollViewSize.width || imageSize.height >= scrollViewSize.height)
        {
            imageSize.width -= 2;
            imageSize.height -= 2;
        }
        
        imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
}

- (void) fixedSwipeSize
{
    CGSize boundsSize = self.bounds.size;
    
    self.contentSize = boundsSize;
    
    CGFloat centerY = self.center.y;
    
    imvRight.center = CGPointMake(boundsSize.width * 1.5, centerY);
    imvLeft.center = CGPointMake(-boundsSize.width * 0.5, centerY);
    
    self.contentInset = INSETS_DEFAULT;
}

@end
