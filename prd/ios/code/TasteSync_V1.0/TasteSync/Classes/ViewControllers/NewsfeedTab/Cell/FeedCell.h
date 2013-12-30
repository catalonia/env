//
//  FeedCell.h
//  TasteSync
//
//  Created by Victor on 12/21/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedObj.h"

@protocol FeedCellDelegate <NSObject>

- (void) feedCellDidActionComment :(FeedObj *)feedObj  ;

- (void) feedCellDidActionShowUsersLike:(FeedObj *)feedObj ;

- (void) feedCellDidActionProfile:(UserObj *)userObj;

@optional

- (void) feedCellDidActionShowMore:(int) pos;


@end

@interface FeedCell : UITableViewCell

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) FeedObj *feedObj;

@property (nonatomic, strong) id<FeedCellDelegate> delegate;

- (void) initForView:(FeedObj *) feeObj;


@end
