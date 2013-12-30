//
//  NewsFeedDetailVC.h
//  TasteSync
//
//  Created by Victor NGO on 12/23/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedDetailVC : UIViewController

@property (nonatomic, strong) NSMutableArray *arrData;

- (void) scrollToCommentCell;

@end
