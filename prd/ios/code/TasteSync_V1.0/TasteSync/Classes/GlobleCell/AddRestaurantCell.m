//
//  AddRestaurantCell.m
//  TasteSync
//
//  Created by Victor on 1/30/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "AddRestaurantCell.h"

@interface AddRestaurantCell ()<UITextFieldDelegate>
{

}

- (IBAction)actionAdd:(id)sender;
- (IBAction)actionSearch:(id)sender;
- (IBAction)actionRemove:(id)sender;


@end

@implementation AddRestaurantCell

- (void) initForCell:(RestaurantObj *)obj
{
    if (obj.name == nil) {
        _btAdd.hidden = YES;
        _btSearch.hidden = YES;
        _tfName.enabled = YES;
        _tfName.text = @"";
        lbTypingRestaurant.hidden = NO;
    }
    else
    {
        lbTypingRestaurant.hidden = YES;
        _tfName.text = obj.name;
        _btAdd.hidden = YES;
        _btSearch.hidden = YES;
        _tfName.enabled = NO;

        
    }
    
    UITapGestureRecognizer *gestureAdd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAdd:)];
    [_btAdd addGestureRecognizer:gestureAdd];
    UITapGestureRecognizer *gestureSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSearch:)];
    [_btSearch addGestureRecognizer:gestureSearch];
}


- (IBAction)actionAdd:(id)sender
{
    [self.delegate addRestaurantCell:self didAction:nil tagAction:TagAdd];
}

- (IBAction)actionSearch:(id)sender
{
    [self.delegate addRestaurantCell:self didAction:nil tagAction:TagSearch];

}

- (IBAction)actionRemove:(id)sender
{
    [self.delegate addRestaurantCell:self didAction:nil tagAction:TagRemove];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    lbTypingRestaurant.hidden = YES;
    [self.delegate addRestaurantCell:self shouldBeginEditing:textField];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"AddRestaurantCell -> textFieldDidEndEditing textField.text = %@", textField.text);
//    
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString
:(NSString *)string
{
    
    [self.delegate addRestaurantCell:self didChangeTextFieldWithString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    
    return YES;
}



- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}



@end
