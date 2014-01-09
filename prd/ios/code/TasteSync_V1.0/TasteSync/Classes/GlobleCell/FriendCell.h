//
//  FriendCell.h
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@class FriendCell;

@protocol FriendCellDelegate <NSObject>

@optional

- (void) friendCell:(FriendCell *) friendCell didAction:(id) anObj tag:(int) aTag;

- (void) friendCell:(FriendCell *)friendCell shouldBeginEditingTextField:(UITextField *)aTextField option:(int) anOption;
- (void) friendCell:(FriendCell *)friendCell didChangeTextFieldWithString:(NSString *) aString;

@end

@interface FriendCell : UITableViewCell<UITextFieldDelegate>

typedef enum _FriendCellTag
{
    FriendCellActionTagAdd  = 1,
    FriendCellActionTabMinus    = 2
    
} FriendCellTab;

@property (nonatomic, strong) IBOutlet UIButton *btAdd, *btnMinus;

@property (nonatomic, strong) IBOutlet UITextField *tfName;

@property (nonatomic, strong) id<FriendCellDelegate> delegate;

- (void) initForCell:(UserObj *) user;


@end
