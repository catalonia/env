//
//  ResPhotoCell.h
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSPhotoRestaurantObj.h"

@class ResPhotoCell;

@protocol ResPhotoCellDelegate <NSObject>

- (void) resPhotoCell:(ResPhotoCell *) resPhotoCell tag:(int) anTag;

@end
@interface ResPhotoCell : UITableViewCell

@property (nonatomic, strong) id<ResPhotoCellDelegate> delegate;

- (void) initForCell:(TSPhotoRestaurantObj *) image1 Index1:(int)index1 image2:(TSPhotoRestaurantObj *)image2 Index2:(int)index2 image3:(TSPhotoRestaurantObj *) image3 Index3:(int)index3;

@end
