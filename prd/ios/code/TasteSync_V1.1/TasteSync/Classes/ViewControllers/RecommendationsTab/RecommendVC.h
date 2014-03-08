//
//  RecommendVC.h
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "GlobalNotification.h"
#import "RecommendDetail1.h"
#import "RecommendDetail2.h"
#import "RecommendDetail3.h"
#import "RecommendDetail4.h"
#import "RecommendDetail7.h"
#import "RestaurantDetailVC.h"
#import "CustomDelegate.h"

@interface RecommendVC : UIViewController<RequestDelegate,NotificationDelegate, RecommentDetail2Protocol,RecomendationDelegate>
{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    
}

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) UIView *refreshHeaderView,*refreshFooterView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;


- (IBAction)actionOthersTab:(id)sender;
- (IBAction)actionNewsfeedTab:(id)sender;
- (id)initWithNotification;
- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

@end
