//
//  FeedDetailCell.h
//  TasteSync
//
//  Created by Victor NGO on 12/23/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedObj.h"

@protocol FeedDetailCellDelegate <NSObject>

- (void) feedDetailCellDidShowLikes:(FeedObj *) feedobj;

- (void) feedDetailCellDidActionProfile:(UserObj *) userObj;
@end

@interface FeedDetailCell : UITableViewCell

@property (nonatomic, strong) id<FeedDetailCellDelegate> delegate;

- (void) initForView:(FeedObj *) feeObj;

@end
