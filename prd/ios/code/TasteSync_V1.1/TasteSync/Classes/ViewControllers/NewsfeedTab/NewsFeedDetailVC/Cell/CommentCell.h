//
//  CommentCell.h
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentCellDelegate <NSObject>

- (void) commentCellDidSendMessage:(NSString *)msg;

- (void) commenCellDidStartComment;

@end

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) id<CommentCellDelegate> delegate;

- (void) initForView;

- (void) startComment;

@end
