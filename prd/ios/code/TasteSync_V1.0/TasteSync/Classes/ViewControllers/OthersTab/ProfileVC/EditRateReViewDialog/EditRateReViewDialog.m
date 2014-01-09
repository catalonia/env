//
//  EditFavoriteDialog.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/25/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "EditRateReViewDialog.h"
#import "CommonHelpers.h"
// global

static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
//static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
//static CGFloat kBorderWhite[4] = {1.0, 1.0, 1.0, 0.8};
static CGFloat kTransitionDuration = 0.3;

static CGFloat kPadding = 0;
//static CGFloat kBorderWidth = 10;

@interface EditRateReViewDialog ()
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

@implementation EditRateReViewDialog

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
        _closeButton.frame = CGRectMake(288, 7, 25, 25);
        
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
        
//        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
//                    UIActivityIndicatorViewStyleWhiteLarge];
//        _spinner.autoresizingMask =
//        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
//        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [self addSubview:_spinner];
        
        _titleLB = [[UILabel alloc]init];
        _titleLB.textColor = color;
        _titleLB.font = [UIFont boldSystemFontOfSize:18];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = @"Rate / Review";
        [_titleLB setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_titleLB];
        
        
        // design
        UIImageView *imageBackgroundText = [[UIImageView alloc]initWithImage:[CommonHelpers getImageFromName:@"Writeareview.png"]];
        
        [imageBackgroundText setFrame:CGRectMake(8, 60, 161, 31)];
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 67, 160, 20)];
        textfield.textAlignment = NSTextAlignmentLeft;
        [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
        textfield.backgroundColor = [UIColor clearColor];
        textfield.textColor = [UIColor darkGrayColor];
        textfield.placeholder = @"Restaurant Name";
        textfield.font = [UIFont boldSystemFontOfSize:12];
        [textfield setBorderStyle:UITextBorderStyleNone];
        self.textfield = textfield;
        textfield.delegate = self;
        
        [self addSubview:imageBackgroundText];
        [self addSubview:textfield];
        
        //table for results text search
        _arryResultSearch = [NSArray array];
        UITableView *tableSearch = [[UITableView alloc]initWithFrame:CGRectMake(10, 94, 157, 67) style:UITableViewStylePlain];
        [tableSearch setBackgroundColor:[UIColor whiteColor]];
        self.tableResultSearch = tableSearch;
        [self.tableResultSearch setBackgroundColor:[UIColor lightGrayColor]];
        [self.tableResultSearch setRowHeight:22];
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(EditRateReViewDialogDidCancel:)])
    {
        [self.delegate EditRateReViewDialogDidCancel:self];
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


- (void)setHiddenDialog:(BOOL)hidden
{
    if (hidden == YES) {
        self.alpha = 0;
        _modalBackgroundView.alpha = 0;
    }
    else{
        self.alpha = 1;
        _modalBackgroundView.alpha = 1;
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
 //   [_closeButton sizeToFit];
    
    //_closeButton.frame = CGRectMake(288,7,25,25);
    
    NSLog(@"%f %f %f %f",_closeButton.frame.origin.x, _closeButton.frame.origin.y, _closeButton.frame.size.width, _closeButton.frame.size.height); 
    //    _webView.frame = CGRectMake(
    //                                kBorderWidth+1,
    //                                kBorderWidth+1,
    //                                innerWidth,
    //                                self.frame.size.height - (1 + kBorderWidth*2));
    
    _titleLB.frame = CGRectMake(60, 8, 200, 40);
    
//    [_spinner sizeToFit];
//    [_spinner startAnimating];
//    //    _spinner.center = _webView.center;
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
    
}

- (void)showFromFarent:(UIView *)parent {
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
    //////////////////////////////////////////////////////
    
    
    
    //  CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
    [_closeButton sizeToFit];
    
    _closeButton.frame = CGRectMake(
                                    290,
                                    2,
                                    29,
                                    29);
    
    //    _webView.frame = CGRectMake(
    //                                kBorderWidth+1,
    //                                kBorderWidth+1,
    //                                innerWidth,
    //                                self.frame.size.height - (1 + kBorderWidth*2));
    
    _titleLB.frame = CGRectMake(60, 8, 200, 40);
    
    //    [_spinner sizeToFit];
    //    [_spinner startAnimating];
    //    //    _spinner.center = _webView.center;
    //    _spinner.center = self.center;
    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (!window) {
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    }
//    
//    _modalBackgroundView.frame = window.frame;
//    [_modalBackgroundView addSubview:self];
//    [window addSubview:_modalBackgroundView];
//
//    [window addSubview:self];
    [parent addSubview:self];
    //[self dialogWillAppear];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    //[UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSLog(@"textField should begin");
    
    if (!textField.text || [textField.text isEqualToString:@""]){
        _arryResultSearch = [NSArray arrayWithArray:self.arryContent];
        
    }
    else{
        _arryResultSearch = [self.arryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", textField.text]];
    }
    [self.tableResultSearch reloadData];
    self.tableResultSearch.hidden = NO;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textTrimed = nil;
    textTrimed = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"text search: %@", textTrimed);
    
    if ([textTrimed isEqualToString:@""]) {
        _arryResultSearch = [NSArray arrayWithArray:self.arryContent] ;
    }
    else{
            _arryResultSearch = [self.arryContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", textTrimed]];  
    }

    
    if (_arryResultSearch.count == 0) {
        self.tableResultSearch.hidden = YES;
    }
    else{
        self.tableResultSearch.hidden = NO;
        [self.tableResultSearch reloadData];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tableResultSearch.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.tableResultSearch.hidden = YES;
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _arryResultSearch = self.arryContent;
    self.tableResultSearch.hidden = NO;
    [self.tableResultSearch reloadData];
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return _arryResultSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
           cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }

    cell.textLabel.text = _arryResultSearch[indexPath.row];
    
    // cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
   // [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return  cell;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textfield resignFirstResponder];
    
    self.textfield.text = _arryResultSearch[indexPath.row];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(EditRateReViewDialogItemTableSearchIsClick:restaurantName:)])
    {
        NSLog(@"goi delegate cell click");
        [self.delegate EditRateReViewDialogItemTableSearchIsClick:self restaurantName:_arryResultSearch[indexPath.row]];
    }


}
@end
