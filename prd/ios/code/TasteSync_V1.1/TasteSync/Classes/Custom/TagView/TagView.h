//
//  TagView.h
//  TagViewCustom
//
//  Created by Victor NGO on 3/14/13.
//  Copyright (c) 2013 Mobioneer Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagObj.h"
#import "TagDefault.h"
#import "TSGlobalObj.h"

@class TagView;

@protocol TagViewDelegate <NSObject>

- (void) tagView:(TagView *) tagView shouldBeginEditingTagObj:(TagObj *) aTagObj;

@end

@interface TagView : UITableViewCell<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *tfRight;

    
}

typedef enum{
    
    TagViewEnumDefault = 1,
    TagViewEnumData =   2
    
} TagViewEnum;

@property (nonatomic, assign) float width, heigh, owidth, oheigh;

@property (nonatomic, strong) id<TagObjDelegate> delegate;

@property (nonatomic, strong) id<TagViewDelegate> tagViewDelegate;

- (id) initWithArray:(NSMutableArray *) anArray option :(int) anOption delegate:(id<TagObjDelegate>) aDelegate;

- (void) addTagDefault;

- (void) addTagObj:(TSGlobalObj *) aTxt delegate:(id<TagObjDelegate>) aDelegate;

- (void) addTagObj:(TSGlobalObj *)aTxt delegate:(id<TagObjDelegate>)aDelegate andTagDefault:(BOOL) aBoolValue;
@end
