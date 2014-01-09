//
//  CPickerView.m
//  Pizza
//
//  Created by Victor NGO on 12/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CPickerView.h"
#import "CommonHelpers.h"

@interface CPickerView()

- (IBAction)actionCancel:(id)sender;

- (IBAction)actionDone:(id)sender;
@end

@implementation CPickerView

@synthesize hide_frame,show_frame,arrData,
delegate,
tag,
selectedIndex;


- (id)initWithFrame:(CGRect)frame
{
   
    frame = CGRectMake(0, 600, 320, 480);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       self = [[[NSBundle mainBundle] loadNibNamed:@"CPickerView" owner:self options:nil] objectAtIndex:0];
        self.frame = frame;
        [navBar setTintColor:[UIColor colorWithPatternImage:[CommonHelpers getImageFromName:@"topbar.png"]]];
        if (!self.arrData) {
            self.arrData = [[NSMutableArray alloc] initWithObjects:@"", nil];
        }
        
    }
    
    
   
    return self;
}

#pragma mark - Others

- (void) show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         if (IS_IPHONE_5) {
                             self.frame = CGRectMake(0,0, 320,568);
                         }
                         else
                         {
                             self.frame = CGRectMake(0,0, 320, 480);
                             
                         }

                     } 
                     completion:^(BOOL finished){
                         
                         [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
                         obj = [self.arrData objectAtIndex:selectedIndex];
#if DEBUG
                         NSLog(@"Show Done!");
#endif
                     }];
}

- (void) showInFrame:(CGRect) frame
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.frame = frame;
                     } 
                     completion:^(BOOL finished){
                         
                         [pickerView selectRow:selectedIndex inComponent:0 animated:NO];
                         obj = [self.arrData objectAtIndex:selectedIndex];
#if DEBUG
                         NSLog(@"Show Done!");
#endif
                     }];
  
}


- (void)hide
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                     
                         [self removeFromSuperview];
                     
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Hide Done!");
                         
                     }];
    
}



- (id) initWithTitle:(NSString *)i_title arrData:(NSMutableArray *)i_arrData delegate:(id<CPickerViewDelegate>) i_delegate 
{
    if (IS_IPHONE_5) {
        self = [self initWithFrame:HIDE_FRAME_5];
    }
    else {
        self = [self initWithFrame:HIDE_FRAME];
        NSLog(@"initWithTitle");
    }
    if (self) {

        navBarItem.title = i_title;
        if (i_arrData) {
            self.arrData = i_arrData;

        }
        self.delegate = i_delegate;
    }
    return self;
}
#pragma mark - IBAction define

- (IBAction)actionCancel:(id)sender
{
    [self hide];
    [self.delegate cPickerViewDidCancelWithTag:tag];
    
}

- (IBAction)actionDone:(id)sender
{
    [self hide];
    if (obj) {
        [self.delegate cPickerViewDidDoneWithObject:obj andTag:tag];

    }
}



#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.arrData) {
        return self.arrData.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"didSelect -> %@",[self.arrData objectAtIndex:row]);
    obj = [self.arrData objectAtIndex:row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
