//
//  RestaurantCell2.h
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateCustom.h"
#import "RestaurantObj.h"

@class RestaurantCell;

@protocol RestaurantCellDelegate <NSObject>

@optional

- (void) restaurantCell:(RestaurantCell *)restaurantCell didFinish:(RestaurantObj *) aRestaurantObj ;

@end

@interface RestaurantCell : UITableViewCell

@property(nonatomic, strong) id<RestaurantCellDelegate> delegate;
@property(nonatomic, assign) BOOL isJustName;

- (void) initForView :(RestaurantObj *) obj;

-(CGFloat)getHeight:(RestaurantObj *) obj;
@end
