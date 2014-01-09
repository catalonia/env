//
//  TagObj.m
//  TagViewCustom
//
//  Created by Victor NGO on 3/14/13.
//  Copyright (c) 2013 Mobioneer Co.Ltd. All rights reserved.
//

#import "TagObj.h"

@interface TagObj ()

@end

@implementation TagObj

@synthesize delegate=_delegate,
txt=_txt;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"TagObj" owner:self options:nil] objectAtIndex:0];
        
    }
    return self;
}

- (id) initWithString:(TSGlobalObj *) aTxt option:(int) anOption delegate:(id<TagObjDelegate>) aDelegate
{
    
       self = [self initWithFrame:CGRectZero];
    self.delegate = aDelegate;
    
    self.txt = aTxt ;
    
    switch (anOption) {
        case TagObjEnumAdd:
        {
            NSLog(@"TagObj - > Add");
            lbTxt.hidden = YES;
            tfAdd.hidden = NO;
            tfAdd.text= @" ";
            tfDelete.hidden = YES;
            [self setFrame:TagObjFrameDefault];            
            
            
        }
            break;
        case TagObjEnumDefault:
        {
            lbTxt.text = [aTxt.name stringByAppendingString:@";"];
            tfAdd.hidden = YES;
            lbTxt.hidden = NO;
            tfDelete.hidden = NO;
            tfDelete.text = @" ";
            CGRect frame = lbTxt.frame;            
            
            CGSize textSize = [lbTxt.text sizeWithFont:lbTxt.font];
            NSLog(@"textLabel width = %f heigh = %f", textSize.width,textSize.height);

            frame.size.width = textSize.width;
            frame.size.width += 20;
            frame.size.height = 31;
            [self setFrame:frame];
            
        }
            break;
            
        default:
            break;
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void) becomeFirstResponder
{
    [tfAdd becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate


- (BOOL)tagObjAdd:(UITextField *)textField
{
    if (textField == tfAdd) {
        NSLog(@"TagObj -tagObjAdd - tfAdd ");
    }
    else {
        NSLog(@"TagObj -tagObjAdd - tfDelete ");

    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == tfAdd) {
        NSLog(@"TagObj -textFieldShouldBeginEditing - tfAdd ");
        [self.delegate tagObj:self shouldBeginEditingTextField:textField option:TagObjEnumOptionAdd];
    }
    else {
        NSLog(@"TagObj -textFieldShouldBeginEditing - tfDelete ");
        [self.delegate tagObj:self shouldBeginEditingTextField:textField option:TagObjEnumOptionDelete];

        
    }
     
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"TagObj -> textFieldDidEndEditing textField.text = %@", textField.text);

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString
                 :(NSString *)string
{
    NSLog(@"TagObj -> shouldChangeCharactersInRange textField.text = %@  - range.length = %d", textField.text,range.length);
    if (textField == tfDelete) {
        if (range.length == 1) {
            NSLog(@"TagObj -> Delete");
            [self.delegate tagObj:self didDeleteGlobalObj:self.txt];
            return YES;
        }
        else {
            
            NSLog(@"range.length = %d", range.length);
            return NO;

        }
    }
    else if (textField == tfAdd) {
        if (range.length == 1) {
            NSLog(@"TagObj -> Delete last Tag");
           
            NSString *txt = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if (txt.length ==0) {
                [self.delegate tagObj:self didDeleteGlobalObj:nil];

            }
            
            return YES;
        }
        else {
            
            [self.delegate tagObj:self didChangeTextFieldWithString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
            
        }
    }
    
    
    return YES;
}



- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyPad];
    
    if (textField == tfAdd) {
        NSLog(@"TagObj -textFieldShouldReturn - tfAdd ");
        [self.delegate tagObj:self option:TagObjEnumOptionCancel];
    
    }
    else {
        NSLog(@"TagObj -textFieldShouldReturn - tfDelete ");
        [self.delegate tagObj:self option:TagObjEnumOptionCancel];
        
        
    }

    
    return YES;
}

- (void) hideKeyPad
{
    [tfAdd resignFirstResponder];
    [tfDelete resignFirstResponder];
}
@end
