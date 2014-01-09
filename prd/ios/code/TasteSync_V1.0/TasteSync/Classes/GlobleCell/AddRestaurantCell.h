//
//  AddRestaurantCell.h
//  TasteSync
//
//  Created by Victor on 1/30/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"

@class AddRestaurantCell;

@protocol AddRestaurantCellDelegate <NSObject>

@optional

- (void) addRestaurantCell:(AddRestaurantCell *) addRestaurantCell didAction:(id) anObject tagAction:(int) aTag;

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell shouldBeginEditing:(UITextField *) aTextField;

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell didChangeTextFieldWithString:(NSString *) aString;


@end

@interface AddRestaurantCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbTypingRestaurant;
}

typedef enum _TagAction{
    
    TagAdd      =   1,
    TagSearch   =   2,
    TagRemove   =   3
    
} TagAction;

@property (nonatomic , strong) IBOutlet UIButton *btAdd,*btSearch,*btMinus;
@property (nonatomic, strong) IBOutlet UITextField *tfName;

@property (nonatomic, strong) id<AddRestaurantCellDelegate> delegate;

- (void) initForCell:(RestaurantObj *)obj;
@end
