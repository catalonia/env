//
//  RateCustom.m
//  PIZZA
//
//  Created by Victor  NGO on 10/20/12.
//  Copyright (c) 2012 Mobioneer Co.,Ltd. All rights reserved.
//

#import "RateCustom.h"
#import "CommonHelpers.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"

#define IC_ON       @"ic_star_on.png"
#define IC_OFF      @"ic_star.png"
#define IC_HALF     @"star1.png"


@implementation RateCustom
{
    BOOL flag;
    AppDelegate *appDelegate ;
}

@synthesize btnPos_1;
@synthesize btnPos_2;
@synthesize btnPos_3;
@synthesize btnPos_4;
@synthesize btnPos_5;
@synthesize value;
@synthesize itemSize;
@synthesize distanceIn;
@synthesize distanceOut;
@synthesize allowedRate;
@synthesize delegate;

- (void) setRateMedium:(double)rate
{
   
    [self resetValue];
    
    if (0 < rate && rate < 1.3) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];

    }
    else if ((rate >=1.3 )&&(rate <1.9))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_HALF] forButton:btnPos_2];

    }
    else if ((rate >=1.9)&&(rate <2.3))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];

    }
    
    else if ((rate >=2.3)&&(rate <2.9))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_HALF] forButton:btnPos_3];

    }

    else if ((rate >= 2.9)&&(rate < 3.4))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];

    }

    else if ((rate >=3.4)&&(rate <3.9))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_HALF] forButton:btnPos_4];

    }

    else if ((rate >=3.9)&&(rate <4.3))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_4];
    }
    else if ((rate >=4.3)&&(rate <4.9))
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_4];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_HALF] forButton:btnPos_5];

    }
    else if(rate != 0)
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_4];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_5];
    }



}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        itemSize=CGSizeMake(20, 20);
        if (frame.size.height < 5) {
            itemSize=CGSizeMake(15, 15);
        }
        distanceIn=2;
        distanceOut=0;
        
        value=0;
        CGRect frame;
        btnPos_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        frame=CGRectMake(distanceOut, distanceOut, itemSize.width, itemSize.height);
        btnPos_1.frame=frame;
        btnPos_1.tag=1;
        
        btnPos_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        frame=CGRectMake( distanceOut+itemSize.width+distanceIn,distanceOut, itemSize.width, itemSize.height);
        btnPos_2.frame=frame;
        btnPos_2.tag=2;
        
        btnPos_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        frame=CGRectMake( distanceOut+2*itemSize.width+2*distanceIn,distanceOut, itemSize.width, itemSize.height);
        btnPos_3.frame=frame;
        btnPos_3.tag=3;
        
        btnPos_4 = [UIButton buttonWithType:UIButtonTypeCustom];
        frame=CGRectMake( distanceOut+3*itemSize.width+3*distanceIn,distanceOut, itemSize.width, itemSize.height);
        btnPos_4.frame=frame;
        btnPos_4.tag=4;
        
        btnPos_5 = [UIButton buttonWithType:UIButtonTypeCustom];
        frame=CGRectMake( distanceOut+4*itemSize.width+4*distanceIn, distanceOut,itemSize.width, itemSize.height);
        btnPos_5.frame=frame;
        btnPos_5.tag=5;
        
        
        [btnPos_1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnPos_2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnPos_3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnPos_4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnPos_5 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnPos_1];
        [self addSubview:btnPos_2];
        [self addSubview:btnPos_3];
        [self addSubview:btnPos_4];
        [self addSubview:btnPos_5];
        [self fitSize];
        [self setDefault];
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



- (IBAction) buttonClicked:(id)sender
{
//    if (target != nil && action != nil) {
//        [target performSelector:action withObject:nil];
//    }
    if (allowedRate) {

        if (((UIButton *)sender).tag == value) {
            [self resetValue];
            value = 0;
            [self updateValue];
            return;
        }
        [self resetValue];
        value = ((UIButton *)sender).tag;
        [self updateValue];
        
    }
    
    
}

- (void) resetValue
{
    value=0;
    [self setDefault];
}
- (void) updateLayout
{
    CGRect frame;
    frame=CGRectMake(distanceOut, distanceOut, itemSize.width, itemSize.height);
    btnPos_5.frame=frame;
    
    frame=CGRectMake( distanceOut,distanceOut+itemSize.width+distanceIn, itemSize.width, itemSize.height);
    btnPos_4.frame=frame;
    
    frame=CGRectMake( distanceOut,distanceOut+2*itemSize.width+2*distanceIn, itemSize.width, itemSize.height);
    btnPos_3.frame=frame;
    
    frame=CGRectMake( distanceOut,distanceOut+3*itemSize.width+3*distanceIn, itemSize.width, itemSize.height);
    btnPos_2.frame=frame;
    
    frame=CGRectMake( distanceOut,distanceOut+4*itemSize.width+4*distanceIn, itemSize.width, itemSize.height);
    btnPos_1.frame=frame;
    
}

- (void) fitSize
{
    CGRect frame=self.frame;
    frame.size=CGSizeMake(2*distanceOut+5*itemSize.width+4*distanceIn, 2*distanceOut+2*itemSize.height+distanceIn);
    self.frame=frame;
}

-(void)setDefault
{
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_OFF] forButton:btnPos_1];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_OFF] forButton:btnPos_2];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_OFF] forButton:btnPos_3];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_OFF] forButton:btnPos_4];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_OFF] forButton:btnPos_5];
}

-(void)updateValue
{
      
    if (!flag) {
        
        [self.delegate didRateWithValue:value];

    }
        [self setDefault];
        switch (value) {
                
                
            case 1:
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
                break;
                
            case 2:
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
                break;
                
            case 3:
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
                break;
            case 4:
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_4];
                break;
                
            case 5:
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_1];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_2];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_3];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_4];
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:IC_ON] forButton:btnPos_5];
                break;
                
            default:
                break;
        }

    
    
    
}

- (void) setTarget:(id)aTarget action:(SEL)anAction
{
    target = aTarget;
    action = anAction;
}



@end
