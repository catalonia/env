//
//  AskContactCell.h
//  TasteSync
//
//  Created by Phu Phan on 11/9/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AskContactCellDelegate
-(void)pressButtonAtIndex:(int)index forcell:(UITableViewCell*)cell;
@end
@interface AskContactCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel* name;
@property(nonatomic,weak) IBOutlet UIImageView* imageleft;
@property(nonatomic,weak) IBOutlet UIImageView* imageright;
@property(nonatomic,weak) IBOutlet UIButton* buttonleft;
@property(nonatomic,weak) IBOutlet UIButton* buttonright;
@property(nonatomic,assign) id<AskContactCellDelegate> delegate;
@end
