//
//  SpotCell.h
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpotCellDelegate <NSObject>

- (void) didActionChooseWithTag:(int) tag;

@end
@interface SpotCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lbDefaultMeal;
@property (nonatomic, strong) IBOutlet UITextField *tfRestaurant;
@property (nonatomic, strong) id<SpotCellDelegate> delegate;


@end
