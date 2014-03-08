//
//  TextStickView.h
//  TasteSync
//
//  Created by Victor on 2/22/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextStickView;

@protocol TextStickViewDelegate <NSObject>

@optional

- (void) textStickView:(TextStickView *) textStickView didAction:(id) anObj tag:(int) aTag;

@end
@interface TextStickView : UIView<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet UIButton *btDelete;
@property (nonatomic, strong) IBOutlet UITextField *tfStick;
@property (nonatomic, strong) IBOutlet UILabel *lbText;
@property (nonatomic, assign) BOOL nullBox;
@property (nonatomic, strong) NSString *txt;
@property (nonatomic, strong) id<TextStickViewDelegate> delegate;

- (IBAction)actionDelete:(id)sender;

@end
