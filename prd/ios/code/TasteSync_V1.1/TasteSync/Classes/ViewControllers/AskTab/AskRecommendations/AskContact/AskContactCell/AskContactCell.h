//
//  AskContactCell.h
//  TasteSync
//
//  Created by Phu Phan on 11/9/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskObject.h"
@protocol AskContactCellDelegate
-(void)pressButtonAtIndex:(int)index forcell:(UITableViewCell*)cell;
@end
@interface AskContactCell : UITableViewCell
{
    __weak IBOutlet UIView* _view;
}
@property(nonatomic,weak) IBOutlet UILabel* name;
@property(nonatomic,weak) IBOutlet UIImageView* imageleft;
@property(nonatomic,weak) IBOutlet UIImageView* imageright;
@property(nonatomic,weak) IBOutlet UIButton* buttonleft;
@property(nonatomic,weak) IBOutlet UIButton* buttonright;
@property(nonatomic,strong) AskObject* askObject;
@property(nonatomic,assign) id<AskContactCellDelegate> delegate;

-(void)refreshView;

@end
