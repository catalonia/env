//
//  RateCustom.h
//  PIZZA
//
//  Created by Victor  NGO on 10/20/12.
//  Copyright (c) 2012 Mobioneer Co.,Ltd. All rights reserved.
//

@protocol RateCustomDelegate <NSObject>

- (void) didRateWithValue :(int) count  ;

@end

@interface RateCustom : UIView {
    UIButton *btnPos_1;
    UIButton *btnPos_2;
    UIButton *btnPos_3;
    UIButton *btnPos_4;
    UIButton *btnPos_5;
    NSInteger value;
    CGSize itemSize;
    NSInteger distanceIn;
    NSInteger distanceOut;
    
    id target;
    SEL action;
}

@property (nonatomic, retain) UIButton *btnPos_1;
@property (nonatomic, retain) UIButton *btnPos_2;
@property (nonatomic, retain) UIButton *btnPos_3;
@property (nonatomic, retain) UIButton *btnPos_4;
@property (nonatomic, retain) UIButton *btnPos_5;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger distanceIn;
@property (nonatomic, assign) NSInteger distanceOut;
@property (nonatomic, assign) BOOL allowedRate ;
@property (nonatomic, strong) id<RateCustomDelegate> delegate;

- (IBAction) buttonClicked:(id)sender;
- (void) resetValue;
- (void) updateLayout;
- (void) fitSize;
- (void) setRateMedium:(double) rate;
- (void) setDefault;
- (void) updateValue;
- (void) setTarget:(id)target action:(SEL)action;
@end