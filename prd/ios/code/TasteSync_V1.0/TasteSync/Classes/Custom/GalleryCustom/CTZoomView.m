//
//  CTZoomView.m
//  MyProofs
//
//  Created by Linh NGUYEN on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTZoomView.h"
#import "CTImageViewDetail.h"
#import "GlobalVariables.h"

//#define offsetLog(scrollView) NSLog(@"offset x -> %f , y: %f", scrollView.contentOffset.x, scrollView.contentOffset.y)
//
//#define contentSizeLog(scrollView) NSLog(@"contentSize w -> %f , h: %f", scrollView.contentSize.width, scrollView.contentSize.height)
//
//#define insetsLog(scrollView) NSLog(@"top: %f, left : %f, botom: %f, right: %f", scrollView.contentInset.top, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right)
//
//#define centerLog(view) NSLog(@"center x:%f, y: %f", view.center.x, view.center.y)
//
//#define frameLog(view) NSLog(@"frame x:%f, y: %f, w: %f, h:%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)

@implementation CTZoomView

@synthesize imvZoom;

- (void)dealloc
{
    self.imvZoom = nil;
}

- (void)awakeFromNib
{
    
}

- (void) zoomViewDoubleTapped
{
    if(self.maximumZoomScale > 1.0)
    {
        if(self.zoomScale < 2.0) 
        {
            [self setZoomScale:2.0 animated:YES];
        }
        else
        {
            [self setZoomScale:1.0 animated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.superview touchesEnded:touches withEvent:event];
}

- (void) fixedZoomSize
{
    CGSize imageViewSize = imvZoom.bounds.size;
    
    CGFloat zoomScale = self.zoomScale;
    
    CGFloat sizeWidth, sizeHeight;
    
    sizeWidth = imageViewSize.width * zoomScale;
    sizeHeight = imageViewSize.height * zoomScale;
    
    CGSize boundsSize = self.bounds.size;
    
    sizeWidth = sizeWidth > boundsSize.width ? sizeWidth : boundsSize.width;
    sizeHeight = sizeHeight > boundsSize.height ? sizeHeight : boundsSize.height;
    
    CGSize contentSize = CGSizeMake(sizeWidth, sizeHeight);
    
    self.contentSize = contentSize;
    imvZoom.center = CGPointMake(contentSize.width * 0.5, contentSize.height * 0.5);
}

- (void) fixedSwipeSize
{
    self.zoomScale = 1.0;
    CGSize boundsSize = self.bounds.size;
    self.contentSize = boundsSize;
    self.pagingEnabled = YES;
    UIEdgeInsets contentInsets = self.contentInset;
    
    if(contentInsets.left > 0)
    {
        contentInsets.left = boundsSize.width;
    }
    
    if(contentInsets.right > 0)
    {
        contentInsets.right = boundsSize.width;
    }
    
    self.contentInset = contentInsets;
    imvZoom.center = self.center;
    self.contentOffset = OFFSET_DEFAULT;
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

- (void)handleRotateOrientation
{
    if(self.zoomScale == 1)
    {
        [self fixedSwipeSize];
        [self fixedImageSize:imvZoom];
    }
    else
    {
        [self fixedImageSize:imvZoom];
        [self fixedZoomSize];
    }
}

@end
