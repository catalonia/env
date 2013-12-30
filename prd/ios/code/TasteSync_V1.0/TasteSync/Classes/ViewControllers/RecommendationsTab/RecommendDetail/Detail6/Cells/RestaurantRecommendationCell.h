//
//  RestaurantRecommendationCell.h
//  TasteSync
//
//  Created by Victor on 3/14/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import "ReplyRecomendationObj.h"

@protocol RestaurantRecommendationDelegate <NSObject>
    -(void)pressAtIndex:(int)index Reco:(ReplyRecomendationObj* )replyObject;

@end
@interface RestaurantRecommendationCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbRestaurantName, *lbDetail;
    __weak IBOutlet UILabel *lbRecommend1, *lbRecommend2, *lbRecommend3;
    __weak IBOutlet UIImageView *iv1, *iv2, *iv3;
    __weak IBOutlet UIView *view1, *view2, *view3;
    __weak IBOutlet UIButton *btMore;
    
    
    
}

//- (void) initCell:(Recommend2Obj *) aRecommend2Obj;
- (IBAction)actionMore:(id)sender;
- (IBAction)actionAvatar:(id)sender;
- (IBAction)actionSelect:(id)sender;
- (void) initCellTest1:(RestaurantObj*)restaurantObj;
- (void) initCellTest2:(RestaurantObj*)restaurantObj;
- (void) initCellTest3:(RestaurantObj*)restaurantObj;
@property (nonatomic, assign) BOOL haveRestaurant;
@property (nonatomic, assign) id<RestaurantRecommendationDelegate> delegate;

@end
