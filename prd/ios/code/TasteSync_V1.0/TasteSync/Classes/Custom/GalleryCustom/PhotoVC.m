//
//  PhotoVC.m
//  BikiniOfWorld
//
//  Created by Vidic Phan on 3/8/13.
//  Copyright (c) 2013 Vidic Phan. All rights reserved.
//

#import "PhotoVC.h"
//#import "GlobalVariables.h"
//#import "Messages.h"
#import "CommonHelpers.h"
#import "CTScrollView.h"
#import "CTZoomView.h"
#import "CTImageViewDetail.h"
#import "TSPhotoRestaurantObj.h"
#import <Twitter/Twitter.h>
#import "AppDelegate.h"
#import "RestaurantObj.h"


#define INSETS_DEFAULT UIEdgeInsetsMake(0, boundsSize.width, 0, boundsSize.width)
#define INSETS_LEFT UIEdgeInsetsMake(0, boundsSize.width, 0, 0)
#define INSETS_RIGHT UIEdgeInsetsMake(0, 0, 0, boundsSize.width)
#define OFFSET_DEFAULT CGPointMake(0, 0)

@interface PhotoVC ()
{
    BOOL PORTRAIT_ORIENTATION;
    //Main
    int size;
    CGFloat anchorLeft, anchorRight;
    BOOL SCROLL_BY_HAND, SCROll_TO_LEFT, SCROLL_TO_RIGHT, AAA, BBB;
    UIEdgeInsets oldInsets;
    BOOL oldBounces, DRAGGING, DOUBLE_TAPPED;
    int tapCount;
    IBOutlet UILabel *lblImg;
    IBOutlet UIView *viewShare;
    BOOL isShowShare;
}

@property (weak, nonatomic) IBOutlet UIView *topView;


//Main
- (IBAction)actionBack:(id)sender;

- (IBAction)actionButtonTapped:(id)sender;
- (void) handleSelectedIndex:(NSUInteger) index;
@end

@implementation PhotoVC
@synthesize scrollView, zoomView, indexSelected, arrayObjects, topView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithArrayPhotos:(NSMutableArray*)arrayPhotos AtIndex:(NSUInteger)index
{
    self = [super initWithNibName:@"PhotoVC" bundle:nil];
    if (self) {
        self.arrayObjects = arrayPhotos;
        self.indexSelected = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(/*IS_IPAD*/ FALSE)
    {
        size = 6;
    }
    else
    {
        size = 4;
    }
    scrollView.delegate = nil;
    NSLog(@"%d", indexSelected);
    [self handleSelectedIndex:indexSelected];
    lblImg.text = [NSString stringWithFormat:@"%d | %d", indexSelected+1, [arrayObjects count]];
    topView.alpha = 0;
    [scrollView handleRotateOrientation];
    [zoomView handleRotateOrientation];
   
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    PORTRAIT_ORIENTATION = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    [scrollView handleRotateOrientation];
    [zoomView handleRotateOrientation];
    [[[CommonHelpers appDelegate] tabbarBaseVC] hideTabBar];
    if (IS_IPHONE_5) {
        [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, 568)];

    }else
    {
        [[self.tabBarController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, 480)];
        
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    PORTRAIT_ORIENTATION = UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    [scrollView handleRotateOrientation];
    [zoomView handleRotateOrientation];
}


#pragma mark - Touch Event Handle

- (void) handleSingleTapped
{
    if(zoomView.dragging == NO)
    {
        if(DOUBLE_TAPPED == NO)
        {
            CGFloat alpha = topView.alpha;
            
            alpha = (alpha == 0) ? 1 : 0;
            
            [UIView beginAnimations:nil context:nil];
            
            topView.alpha = alpha;
            
            [UIView commitAnimations];
        }
        
        DOUBLE_TAPPED = NO;
    }
    viewShare.hidden = YES;
    isShowShare = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    tapCount = touch.tapCount;
    
    if(tapCount == 2)
    {
        DOUBLE_TAPPED = YES;
        [zoomView zoomViewDoubleTapped];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(tapCount == 1)
    {
        [self performSelector:@selector(handleSingleTapped) withObject:nil afterDelay:0.5];
    }
}
- (void)actionButtonTapped:(id)sender
{
#if DEBUG
    NSLog(@"actionButtonTapped");
#endif
    
}

#pragma mark -

- (void)handleSelectedIndex:(NSUInteger)index
{
    if (arrayObjects != nil && arrayObjects.count != 0) {
        TSPhotoRestaurantObj *photoObj = [arrayObjects objectAtIndex:index];
        
        //    int actualSize = size < photoObj.allowSize ? size : photoObj.allowSize;
        lblImg.text = [NSString stringWithFormat:@"%d | %d", index+1, [arrayObjects count]];
#ifdef DEBUG
        //    NSLog(@"actualSize %i", actualSize);
#endif
        UIImage *image = photoObj.image;
        
        if(image)
        {
            zoomView.imvZoom.image = image;
            [zoomView.imvZoom stopIndicatorAnimating];
            [zoomView fixedImageSize:zoomView.imvZoom];
        }else
        {
            zoomView.imvZoom.image = nil;
            [zoomView.imvZoom startIndicatorAnimating];
            [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:index]];
        }
        zoomView.contentOffset = scrollView.contentOffset = OFFSET_DEFAULT;
        zoomView.imvZoom.hidden = NO;
        
        BOOL isBouncesRight = NO;
        
        CGSize boundsSize = zoomView.bounds.size;
        
        if(index == [arrayObjects count] - 1)
        {
            zoomView.contentInset = INSETS_LEFT;
            
#ifdef DEBUG
            NSLog(@"right");
#endif
            
            scrollView.imvRight.image = nil;
            scrollView.imvRight.btnPlay.hidden = YES;
            [scrollView.imvRight stopIndicatorAnimating];
            zoomView.bounces = YES;
            isBouncesRight = YES;
        }
        else
        {
            zoomView.contentInset = INSETS_DEFAULT;
            zoomView.bounces = NO;
            
#ifdef DEBUG
            NSLog(@"right");
#endif
            
            TSPhotoRestaurantObj *photoObj = [arrayObjects objectAtIndex:index + 1];
            UIImage *image = photoObj.image;
            //image = [CommonHelpers getImageFromName:BG_IMAGE];
            if(image)
            {
                scrollView.imvRight.image = image;
                [scrollView.imvRight stopIndicatorAnimating];
                [scrollView fixedImageSize:scrollView.imvRight];
            }else{
                scrollView.imvRight.image = nil;
                [scrollView.imvRight startIndicatorAnimating];
            }
            
            
        }
        //top
        if(index == 0)
        {
            UIEdgeInsets inset = zoomView.contentInset;
            inset.left = 0;
            zoomView.contentInset = inset;
            scrollView.imvLeft.image = nil;
            scrollView.imvLeft.btnPlay.hidden = YES;
            [scrollView.imvLeft stopIndicatorAnimating];
#ifdef DEBUG
            NSLog(@"left");
#endif
            
            zoomView.bounces = YES;
        }
        else
        {
            UIEdgeInsets inset = zoomView.contentInset;
            inset.left = boundsSize.width;
            zoomView.contentInset = inset;
#ifdef DEBUG
            NSLog(@"not left");
#endif
            if(isBouncesRight == NO)
            {
                zoomView.bounces = NO;
            }
            
            TSPhotoRestaurantObj *photoObj = [arrayObjects objectAtIndex:index - 1];
            //        int actualSize = size < photoObj.allowSize ? size : photoObj.allowSize;
            lblImg.text = [NSString stringWithFormat:@"%d | %d", index+1, [arrayObjects count]];
#ifdef DEBUG
            //        NSLog(@"actualSize %i", actualSize);
#endif
            UIImage *image = nil;
            image = photoObj.image;
            if(image)
            {
                scrollView.imvLeft.image = image;
                [scrollView.imvLeft stopIndicatorAnimating];
                [scrollView fixedImageSize:scrollView.imvLeft];
            }else
            {
                scrollView.imvLeft.image = nil;
                [scrollView.imvLeft startIndicatorAnimating];
            }
        }

    }
}

//    insetsLog(zoomView);



#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if(_scrollView == zoomView)
    {
        CGPoint contentOffset = zoomView.contentOffset;
        CGSize contentSize = zoomView.contentSize;
        CGSize boundsSize = zoomView.bounds.size;
        
        contentOffset.y = 0;
        
        if(contentOffset.x < 0)
        {
            scrollView.contentOffset = contentOffset;
            
            if(DRAGGING)
            {
                UIEdgeInsets contentInset = zoomView.contentInset;
                contentInset.left = -contentOffset.x;
                zoomView.contentInset = contentInset;
            }
            
            //            zoomView.minimumZoomScale = zoomView.maximumZoomScale;
        }
        else
        {
            CGFloat offsetPlugs = contentOffset.x + boundsSize.width - contentSize.width;
            
            BOOL DK = contentSize.width >= boundsSize.width;
            
            if(offsetPlugs > 0 && DK)
            {
                contentOffset.x = offsetPlugs;
                
                scrollView.contentOffset = contentOffset;
                
                if(DRAGGING)
                {
                    UIEdgeInsets contentInset = zoomView.contentInset;
                    contentInset.right = offsetPlugs;
                    zoomView.contentInset = contentInset;
                }
                
                //                zoomView.minimumZoomScale = zoomView.maximumZoomScale;
            }
            else
            {
                if(!SCROLL_BY_HAND)
                {
                    contentOffset.x = 0;
                    scrollView.contentOffset = contentOffset;
                    
                }
                
                //                zoomView.minimumZoomScale = 1.0;
            }
        }
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)_scrollView
{
    if(AAA)
    {
        CGPoint contentOffset = zoomView.contentOffset;
        CGSize boundsSize = zoomView.bounds.size;
        
        contentOffset.x = - boundsSize.width;
        
        
        [zoomView setContentOffset:contentOffset animated:YES];
    }
    else if(BBB)
    {
        CGPoint contentOffset = zoomView.contentOffset;
        
        contentOffset.x = zoomView.contentSize.width;
        
        [zoomView setContentOffset:contentOffset animated:YES];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)_scrollView
{
    if(_scrollView == zoomView)
    {
        [zoomView fixedZoomSize];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(zoomView.zoomScale > 1.0)
    {
        DRAGGING = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)_scrollView willDecelerate:(BOOL)decelerate
{
    DRAGGING = NO;
    
    if(_scrollView == zoomView)
    {
        if(zoomView.zoomScale > 1.0)
        {
            SCROLL_BY_HAND = SCROll_TO_LEFT = SCROLL_TO_RIGHT = NO;
            CGPoint contentOffset = zoomView.contentOffset;
            CGSize contentSize = zoomView.contentSize;
            CGSize boundsSize = zoomView.bounds.size;
            
            if(contentOffset.x < -boundsSize.width * 0.3 && indexSelected > 0)
            {
                contentOffset.x = -boundsSize.width;
                
                
                //                zoomView.delegate = nil;
                
                AAA = NO;
                
                SCROLL_BY_HAND = YES;
                SCROll_TO_LEFT = YES;
                
                if(!decelerate)
                {
                    [zoomView setContentOffset:contentOffset animated:YES];
                }
                else
                {
                    zoomView.bounces = NO;
                    UIEdgeInsets contentInset = zoomView.contentInset;
                    contentInset.left = boundsSize.width;
                    zoomView.contentInset = contentInset;
                    AAA = YES;
                }
            }
            else
            {
                CGFloat offsetPlugs = contentOffset.x + boundsSize.width - contentSize.width;
                
                if(offsetPlugs > boundsSize.width * 0.3 && indexSelected < [arrayObjects count] - 1)
                {
                    BBB = NO;
                    SCROLL_BY_HAND = YES;
                    SCROLL_TO_RIGHT = YES;
                    
                    zoomView.bounces = NO;
                    
                    contentOffset.x = contentSize.width;
                    
                    if(!decelerate)
                    {
                        [zoomView setContentOffset:contentOffset animated:YES];
                    }
                    else
                    {
                        zoomView.bounces = NO;
                        UIEdgeInsets contentInset = zoomView.contentInset;
                        contentInset.right = boundsSize.width;
                        zoomView.contentInset = contentInset;
                        BBB = YES;
                    }
                }
                else
                {
                    //                    if(!decelerate)
                    {
                        [UIView beginAnimations:nil context:nil];
                        zoomView.contentInset = UIEdgeInsetsZero;
                        [UIView commitAnimations];
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)_scrollView
{
    if(_scrollView == zoomView)
    {
        AAA = NO;
        BBB = NO;
        CGSize boundsSize = zoomView.bounds.size;
        zoomView.imvZoom.hidden = YES;
        [zoomView fixedSwipeSize];
        zoomView.contentInset = INSETS_DEFAULT;
        scrollView.contentOffset = OFFSET_DEFAULT;
        
        if(SCROLL_TO_RIGHT)
        {
            ++indexSelected;
            [self handleSelectedIndex:indexSelected];
        }
        else if(SCROll_TO_LEFT)
        {
            --indexSelected;
            [self handleSelectedIndex:indexSelected];
        }
        
        SCROLL_BY_HAND = SCROll_TO_LEFT =  SCROLL_TO_RIGHT = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if(_scrollView == zoomView)
    {
        if(zoomView.zoomScale == 1.0)
        {
            int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
            
            if(index > 0)
            {
                ++indexSelected;
                [self handleSelectedIndex:indexSelected];
            }
            else if(index < 0)
            {
                --indexSelected;
                [self handleSelectedIndex:indexSelected];
            }
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)_scrollView
{
    if(_scrollView == zoomView && zoomView.imvZoom.image)
    {
        return zoomView.imvZoom;
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)_scrollView withView:(UIView *)view
{
    if(zoomView.zoomScale == 1.0)
    {
        oldInsets = zoomView.contentInset;
        zoomView.contentInset = UIEdgeInsetsZero;
        zoomView.pagingEnabled = NO;
        oldBounces = zoomView.bounces;
        zoomView.bounces = YES;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)_scrollView withView:(UIView *)view atScale:(float)scale
{
    if(_scrollView == zoomView)
    {
        if(zoomView.zoomScale == 1.0)
        {
            zoomView.contentInset = oldInsets;
            zoomView.pagingEnabled = YES;
            zoomView.bounces = oldBounces;
            [zoomView fixedSwipeSize];
            
            UIEdgeInsets contentInset = zoomView.contentInset;
            CGSize boundsSize = zoomView.bounds.size;
            
            if(indexSelected > 0)
            {
                contentInset.left = boundsSize.width;
            }
            
            if(indexSelected < [arrayObjects count] - 1)
            {
                contentInset.right = boundsSize.width;
            }
            
            zoomView.contentInset = contentInset;
        }
    }
}


- (void)viewDidUnload {
    lblImg = nil;
    viewShare = nil;
    [super viewDidUnload];
}


- (IBAction)actionBack:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] showTabBar];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadImage:(NSNumber*)_index
{
    @autoreleasepool {
        TSPhotoRestaurantObj *photoObj = [arrayObjects objectAtIndex:[_index integerValue]];
        UIImage *image;
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoObj.photoURL]]];
        photoObj.image = image;
        [self handleSelectedIndex:indexSelected];
        //[_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
