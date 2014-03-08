//
//  Detail4Cell.h
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import "RateCustom.h"


@protocol Detail4CellDelegate <NSObject>

-(void)pressLikeButton:(UITableViewCell*)cell Liked:(BOOL)liked;

@end
@interface Detail4Cell : UITableViewCell

@property(nonatomic,assign) id<Detail4CellDelegate> delegate;
- (void) initForView:(RestaurantObj *)obj;
-(void)setLikeStatus:(BOOL)value;

@end
