//
//  ResShareFB.m
//  TasteSync
//
//  Created by Victor on 1/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResShareFB.h"
#import "CommonHelpers.h"

@implementation ResShareFB
@synthesize restaurantObj=_restaurantObj;

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 600, 320, 480);
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"ResShareFB" owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         if (IS_IPHONE_5) {
                             self.frame = CGRectMake(0, 0, 320,568);

                         }else
                         {
                             self.frame = CGRectMake(0, 0, 320,480);

                         }
                     }
                     completion:^(BOOL finished){
                         
                         debug(@"Show Done! ");
                         
                         
                     }];
    
    
    return self;
}


- (IBAction)actionClose:(id)sender
{
   
    [tvMsg resignFirstResponder];

    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.frame = CGRectMake(0, 600, 320, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         debug(@"Hide Done! in frame ");
                         
                         
                     }];
    

}
- (IBAction)actionCancel:(id)sender
{
    [tvMsg resignFirstResponder];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.frame = CGRectMake(0, 600, 320, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         debug(@"Hide Done! in frame ");
                         
                         
                     }];

}
- (IBAction)actionShare:(id)sender
{
    [tvMsg resignFirstResponder];

}
- (IBAction)actionTouchs:(id)sender
{
    [tvMsg resignFirstResponder];
    if (tvMsg.text.length==0) {
        lbTextHolder.hidden = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    lbTextHolder.hidden = YES;
    return  YES;
}


@end
