//
//  CPickerView.h
//  Pizza
//
//  Created by Victor NGO on 12/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIDE_FRAME      CGRectMake(0,480,320,480)
#define SHOW_FRAME      CGRectMake(0,44,320,480) // (0,0,320,480) if navigationBarItem.hidden = YES;
#define HIDE_FRAME_5    CGRectMake(0,568,320,568)
#define SHOW_FRAME_5    CGRectMake(0,44,320,568)
#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@protocol CPickerViewDelegate <NSObject>

@required

- (void) cPickerViewDidCancelWithTag:(int) tag;
- (void) cPickerViewDidDoneWithObject:(id) obj andTag:(int) tag;

@end

@interface CPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    __weak IBOutlet UIPickerView *pickerView;
    __weak IBOutlet UINavigationItem *navBarItem;
    __weak IBOutlet UINavigationBar *navBar;
    id obj;
}

@property (nonatomic, assign) CGRect hide_frame,show_frame;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) id<CPickerViewDelegate> delegate;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int tag;

- (void) show;

- (void) showInFrame:(CGRect) frame;

- (id) initWithTitle:(NSString *)i_title arrData:(NSMutableArray *)i_arrData delegate:(id<CPickerViewDelegate>) i_delegate ;



@end
