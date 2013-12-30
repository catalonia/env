//
//  TagObj.h
//  TagViewCustom
//
//  Created by Victor NGO on 3/14/13.
//  Copyright (c) 2013 Mobioneer Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSGlobalObj.h"

typedef enum {
    
    TagObjEnumAdd   =   1,
    TagObjEnumDefault   =   2,
    TagObjEnumOptionDelete  =   10,
    TagObjEnumOptionAdd     =   11,
    TagObjEnumOptionCancel  =   12
} TagObjEnum;

#define TagObjFrameDefault CGRectMake(3,0,100,31)

@class TagObj;

@protocol TagObjDelegate <NSObject>

@optional

- (void) tagObj:(TagObj *)tagObj option:(int) anOption;
- (void) tagObj:(TagObj *)tagObj shouldBeginEditingTextField:(UITextField *)aTextField option:(int) anOption;
- (void) tagObj:(TagObj *)tagObj didChangeTextFieldWithString:(NSString *) aString;
- (void) tagObj:(TagObj *)tagObj didDeleteGlobalObj:(TSGlobalObj *)aString;

@end

@interface TagObj : UIView<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *tfDelete, *tfAdd;
    __weak IBOutlet UILabel *lbTxt;
}

@property(nonatomic, strong) id<TagObjDelegate> delegate;
@property (nonatomic, strong) TSGlobalObj *txt;

- (id) initWithString:(TSGlobalObj *) aTxt option:(int) anOption delegate:(id<TagObjDelegate>) aDelegate;

- (void) becomeFirstResponder;
@end
