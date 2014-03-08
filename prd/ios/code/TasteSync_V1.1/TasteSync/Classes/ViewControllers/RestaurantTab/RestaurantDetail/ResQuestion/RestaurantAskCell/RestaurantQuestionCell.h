//
//  RestaurantQuestionCell.h
//  TasteSync
//
//  Created by HP on 8/28/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@protocol RestaurantQuestionDelegate <NSObject>

- (void)checkStatus:(UserObj*)obj checked:(BOOL)isChecked;

@end

@interface RestaurantQuestionCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel* name;
@property(nonatomic,weak) IBOutlet UIButton* ticker;
@property(nonatomic,weak) IBOutlet UIImageView* image;
@property(nonatomic,weak) IBOutlet UIButton* imageButton;
@property(nonatomic,weak) IBOutlet UIActivityIndicatorView* indicator;
@property(nonatomic,strong) NSString* imageLink;
@property(nonatomic,strong) UserObj* userObj;

@property(nonatomic,assign) id<RestaurantQuestionDelegate> delegate;

- (IBAction)actionCheck:(id)sender;
@end
