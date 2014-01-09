//
//  TextView.h
//  TestTextfield
//
//  Created by HP on 9/16/13.
//  Copyright (c) 2013 Mobioneer HV 02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighlightText.h"
#import "RestaurantObj.h"

@protocol TextviewDelegate<NSObject>
- (void)beginEditting;
- (void)enterCharacter:(NSString*)text;
- (void)enterSearchObject:(NSString*)text;
- (void)addNewObject:(HighlightText*)object;
- (void)removeObject:(HighlightText*)object;
@end

@interface TextView : UIView<UITextViewDelegate>

@property(nonatomic,assign) id<TextviewDelegate> delegate;
@property(nonatomic,strong) NSString* specialCharacter;
@property(nonatomic,strong) UITextView* textView;

-(void)addSpecialCharacter:(NSString*)character;
-(void)addRestaurant:(RestaurantObj*)obj;
@end
