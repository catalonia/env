//
//  EditFavoriteDialog.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/25/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "EditFavoriteDialog.h"
#import "CommonHelpers.h"
// global

//static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
//static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
//static CGFloat kBorderWhite[4] = {1.0, 1.0, 1.0, 0.8};
static CGFloat kTransitionDuration = 0.3;

static CGFloat kPadding = 0;
//static CGFloat kBorderWidth = 10;

@interface EditFavoriteDialog ()
{
    UIImageView *_imageBackground;
     UIButton* _closeButton;
    UILabel *_titleLB;
    
    // UIActivityIndicatorView* _spinner;
    // Ensures that UI elements behind the dialog are disabled.
    UIView* _modalBackgroundView;
    UIDeviceOrientation _orientation;
    
    NSArray *_arryResultSearch;
    
}
@end

@implementation EditFavoriteDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
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

// NSObject

- (id)init {
    if (self = [super initWithFrame:CGRectZero]) {
       // _delegate = nil;
       // _loadingURL = nil;
        _orientation = UIDeviceOrientationUnknown;
      //  _showingKeyboard = NO;
        
        self.backgroundColor = [UIColor clearColor];
      //  self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        _imageBackground = [[UIImageView alloc]initWithImage:[CommonHelpers getImageFromName:@"bgbox_rec.png"]];
        [self addSubview:_imageBackground];
        
        UIImage* closeImage = [CommonHelpers getImageFromName:@"ic_close.png"];
        
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [_closeButton setTitleColor:color forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(cancel)
               forControlEvents:UIControlEventTouchUpInside];
        
        // To be compatible with OS 2.x
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_2_2
        _closeButton.font = [UIFont boldSystemFontOfSize:12];
#else
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
#endif
        
        _closeButton.showsTouchWhenHighlighted = YES;
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_closeButton];
        
        //_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //_spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
      //  [self addSubview:_spinner];
        
        _titleLB = [[UILabel alloc]init];
        _titleLB.textColor = color;
        _titleLB.font = [UIFont boldSystemFontOfSize:18];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"Favorite Spots";
        [_titleLB setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLB];
        
        

        //table for results text search
        _arryResultSearch = [NSArray array];
        UITableView *tableSearch = [[UITableView alloc]initWithFrame:CGRectMake(22, 84, 161, 67) style:UITableViewStylePlain];
        [tableSearch setBackgroundColor:[UIColor lightGrayColor]];
        [tableSearch setRowHeight:22];
        self.tableResultSearch = tableSearch;
        self.tableResultSearch.dataSource = self;
        self.tableResultSearch.delegate = self;
        [self addSubview:self.tableResultSearch];
        
    _modalBackgroundView = [[UIView alloc] init];
        
    }
    return self;
}

- (void)cancel {
   // [self dialogDidCancel:nil];
    [self dismiss:YES];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(EditFavoriteDialogDidCancel:)])
    {
        [self.delegate EditFavoriteDialogDidCancel:self];
    }

}

- (void)postDismissCleanup {
    [self removeFromSuperview];
    [_modalBackgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0) {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
    } else {
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors) {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius) {
            [self addRoundedRectToPath:context rect:rect radius:radius];
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGColorSpaceRelease(space);
}


- (void)drawRect:(CGRect)rect
{
    //[self drawRect:rect fill:kBorderGray radius:0];
    [self drawRect:rect fill:kBorderGray radius:20];

}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
//    if (FBIsDeviceIPad()) {
//        // On the iPad the dialog's dimensions should only be 60% of the screen's
//        scale_factor = 0.6f;
//    }
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
   // [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation]; //CGAffineTransformIdentity
    [UIView commitAnimations];
}

- (void)show {
    //[self load];
    
    /////////////////////////////////////////////////////
    [self sizeToFitOrientation:NO];
    
    // set lai frame 
    CGRect frame = self.frame;
    frame.origin.y = frame.origin.y + 70;
    frame.size.height = frame.size.height - 70;
    
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    [self setFrame:frame];
     self.center = center;
    [_imageBackground setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    //////////////////////////////////////////////////////
    
    
    
  //  CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
    [_closeButton sizeToFit];
    
    _closeButton.frame = CGRectMake(
                                    288,
                                    7,
                                    25,
                                    25);
    
//    _webView.frame = CGRectMake(
//                                kBorderWidth+1,
//                                kBorderWidth+1,
//                                innerWidth,
//                                self.frame.size.height - (1 + kBorderWidth*2));
    
    _titleLB.frame = CGRectMake(60, 8, 200, 40);
    
   // [self.table setFrame:CGRectMake(0, 50, 320, 300)];
    
//    [_spinner sizeToFit];
//    [_spinner startAnimating];
////    _spinner.center = _webView.center;
//    _spinner.center = self.center;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    _modalBackgroundView.frame = window.frame;
    [_modalBackgroundView addSubview:self];
    [window addSubview:_modalBackgroundView];
    
    [window addSubview:self];
    [self bringSubviewToFront:self.tableResultSearch];
    self.tableResultSearch.hidden = YES;
    //[self dialogWillAppear];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
     //[UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    //[self showPicker];
    
}

- (void)hiddenTableSearch
{
    self.tableResultSearch.hidden = YES;
}

- (void)showTableForSearchString: (NSString *)string
{
    if ([string isEqualToString:@""]) {
        _arryResultSearch = self.arryContent ;
    }
    else{
         _arryResultSearch = [self.arryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", string]];
    }
   
    if (_arryResultSearch.count == 0) {
        self.tableResultSearch.hidden = YES;
    }
    else{
        self.tableResultSearch.hidden = NO;
        [self.tableResultSearch reloadData];
    }

}

- (void) moveDialogUpWithLevel:(NSInteger)level
{
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arryResultSearch.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    
    cell.detailTextLabel.text = _arryResultSearch[indexPath.row];
    //[cell.detailTextLabel setFont:[UIFont fontWithName:@"System" size:10]];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"Times New Roman" size:12];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(EditFavoriteDialogItemTableSearchIsclick:)])
    {
        [self.delegate EditFavoriteDialogItemTableSearchIsclick:_arryResultSearch[indexPath.row]];
    }
    
    self.tableResultSearch.hidden = YES;
}


@end
