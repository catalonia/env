//
//  AskCell.h
//  TasteSync
//
//  Created by Phu Phan on 11/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UIImageView* image;
@property (nonatomic, weak) IBOutlet UIImageView* selectImage;
@end
