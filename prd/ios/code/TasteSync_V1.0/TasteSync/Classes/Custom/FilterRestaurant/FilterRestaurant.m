//
//  FilterRestaurant.m
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "FilterRestaurant.h"
#import "CommonHelpers.h"
#import "TSGlobalObj.h"

@interface FilterRestaurant()
{
    NSMutableArray *arrDataStickFilter;
}

@end

@implementation FilterRestaurant



- (id)initWithFrame:(CGRect)frame
{
    if (IS_IPHONE_5) {
        frame = CGRectMake(0,0, -320,568);
    }
    else
    {
        frame = CGRectMake(0,0, -320, 480);
        
    }

    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle ] loadNibNamed:@"FilterRestaurant" owner:self options:nil] objectAtIndex:0];
        [self setFrame:frame];
          debug(@"Init in frame %f , %f, %f, %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height); 
       
    }
    
    [self initUI];
    [self initData];
    self.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];

    return self;
}

- (void) show
{
    self.hidden = NO;
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
                         
                       
#if DEBUG
                         NSLog(@"Show Done!");
#endif
                     }];
}

- (void) showViewInFrame:(CGRect) frame
{
    self.hidden = NO;

    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         

                         debug(@"Show Done! in frame %f , %f, %f, %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
                         

                     }];

    
}

- (void) initUI
{
    [scrollViewCuisine setContentSize:CGSizeMake(2100, 30)];
    [scrollViewPrice setContentSize:CGSizeMake(500, 30)];
    rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(20, 300, 150, 30)];
    [self addSubview:rateCustom];
    rateCustom.delegate = self;
    rateCustom.allowedRate = YES;
    
    
    for (int i= 0; i< [[[CommonHelpers appDelegate] arrCuisine] count]; i++) {
        TSGlobalObj* globalObj = [[[CommonHelpers appDelegate ] arrCuisine ] objectAtIndex:i];
        if (i < 5)
            [segCtrCuisine setTitle:globalObj.name forSegmentAtIndex:i];
        else
            [segCtrCuisine insertSegmentWithTitle:globalObj.name atIndex:i animated:NO];
        
        
    }
    
    for (int i= 0; i< [[[CommonHelpers appDelegate] arrPrice] count]; i++) {
        TSGlobalObj* globalObj = [[[CommonHelpers appDelegate ] arrPrice ] objectAtIndex:i];
        if (i < 5)
            [segCtrPrice setTitle:globalObj.name forSegmentAtIndex:i];
        else
            [segCtrPrice insertSegmentWithTitle:globalObj.name atIndex:i animated:NO];
        
        
    }
     
     
    [segCtrCuisine addTarget:self action:@selector(actionSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [segCtrPrice addTarget:self action:@selector(actionSegmentControl:) forControlEvents:UIControlEventValueChanged];
    
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [segCtrCuisine setTintColor:SEGNMENT_COLOR];
    [segCtrCuisine setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [segCtrPrice setTintColor:SEGNMENT_COLOR];
    [segCtrPrice setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    segCtrCuisine.selectedSegmentIndex = -1;
    segCtrPrice.selectedSegmentIndex = -1;
    [self resizeSegmentsToFitTitles:segCtrCuisine];
    [self resizeSegmentsToFitTitles:segCtrPrice];



}

- (void) initData
{
    arrCuisine = [[NSMutableArray alloc] init ];
    arrPrice = [[NSMutableArray alloc] init];
    filterDict = [[NSMutableDictionary alloc] init];
    arrDataStickFilter = [[NSMutableArray alloc] init];
}

-(void)resizeSegmentsToFitTitles:(UISegmentedControl*)segCtrl {
    CGFloat totalWidths = 0;    // total of all label text widths
    NSUInteger nSegments = segCtrl.subviews.count;
    UIView* aSegment = [segCtrl.subviews objectAtIndex:0];
    UIFont* theFont = nil;
    
    for (UILabel* aLabel in aSegment.subviews) {
        if ([aLabel isKindOfClass:[UILabel class]]) {
            theFont = aLabel.font;
            break;
        }
    }
    
    // calculate width that all the title text takes up
    for (NSUInteger i=0; i < nSegments; i++) {
        CGFloat textWidth = [[segCtrl titleForSegmentAtIndex:i] sizeWithFont:theFont].width;
        totalWidths += textWidth;
    }
    
    // width not used up by text, its the space between labels
    CGFloat spaceWidth = segCtrl.bounds.size.width - totalWidths;
    
    // now resize the segments to accomodate text size plus
    // give them each an equal part of the leftover space
    for (NSUInteger i=0; i < nSegments; i++) {
        // size for label width plus an equal share of the space
        CGFloat textWidth = [[segCtrl titleForSegmentAtIndex:i] sizeWithFont:theFont].width;
        // roundf??  the control leaves 1 pixel gap between segments if width
        // is not an integer value, the roundf fixes this
        CGFloat segWidth = roundf(textWidth + (spaceWidth / nSegments));
        [segCtrl setWidth:segWidth forSegmentAtIndex:i];
    }
}

#pragma mark - IBAction Define
- (IBAction)actionDone:(id)sender
{
    [self hide];
    [filterDict setValue:arrCuisine forKey:Cuisine];
    [filterDict setValue:arrPrice forKey:Price];
    [filterDict setValue:[NSNumber numberWithInt:rating] forKey:Rating];
    [filterDict setValue:[NSNumber numberWithBool:saved] forKey:Saved];
    [filterDict setValue:[NSNumber numberWithBool:favs] forKey:Favs];
    [filterDict setValue:[NSNumber numberWithBool:deals] forKey:Deals];
    [filterDict setValue:[NSNumber numberWithBool:restaurantChains] forKey:Restaurant_Chains];
     
    [self.delegate filterRestaurant:self didFinish:filterDict tag:1];

    
}

- (IBAction)actionSaved:(id)sender
{
    if (saved) {
        saved = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saved73_off.png"] forButton:btSaved];
    }
    else
    {
        saved = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saved73_on.png"] forButton:btSaved];
        
    }
}
- (IBAction)actionFavs:(id)sender
{
    if (favs) {
        favs = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_favs_small.png"] forButton:btFavs];
        
    }
    else
    {
        favs = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_favs_small_on.png"] forButton:btFavs];
        
    }
}
- (IBAction)actionDeals:(id)sender
{
    if (deals) {
        deals = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_deals_grey.png"] forButton:btDeals];
        
    }
    else
    {
        deals = YES;
        //        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_deals73_on.png"] forButton:btDeals];
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_deals_red.png"] forButton:btDeals];
        
        
    }
}
- (IBAction)actionShow:(id)sender
{
    restaurantChains = YES;
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_show_red.png"] forButton:btShow];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_hide.png"] forButton:btHide];
    
}
- (IBAction)actionHide:(id)sender
{
    restaurantChains = NO;
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_show.png"] forButton:btShow];
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_hide_red.png"] forButton:btHide];
    
}

- (IBAction)actionSegmentControl:(id)sender
{
    UISegmentedControl *segCtr = (UISegmentedControl *)sender;
    debug(@"segCtr selectedIndex -> %d", segCtr.selectedSegmentIndex);
    
    
    NSString *strObj;
    
    if (segCtr == segCtrCuisine) {
        strObj = [[[CommonHelpers appDelegate] arrCuisine] objectAtIndex:segCtr.selectedSegmentIndex];
    }
    else      if (segCtr == segCtrPrice) {
            strObj =[[[CommonHelpers appDelegate] arrOccasion] objectAtIndex:segCtr.selectedSegmentIndex];
        }
    else
        {
                            
        }
    
    //strObj = [strObj stringByAppendingString:@";"];
    
    if ([arrDataStickFilter containsObject:strObj]) {
        [arrDataStickFilter removeObject:strObj];
        for (int i= 0; i< [[sender subviews] count]; i++) {
            if ([[[sender subviews] objectAtIndex:i] isSelected]) {
                [[[sender subviews] objectAtIndex:i] setTintColor:SEGNMENT_COLOR];
                
                break;
            }
        }
    }
    else
    {
        [arrDataStickFilter addObject:strObj];
        for (int i= 0; i< [[sender subviews] count]; i++) {
            if ([[[sender subviews] objectAtIndex:i] isSelected]) {
                [[[sender subviews] objectAtIndex:i] setTintColor:SEGNMENT_COLOR_ON];
                
                break;
            }
        }
    }
    
    segCtr.selectedSegmentIndex = -1;

    
}


- (void) hide
{
        [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.frame=CGRectMake(-320, 0, 320, 480);
                     }
                     completion:^(BOOL finished){
                         debug(@"hide done");
                         
                         self.hidden = YES;
                         
                     }];
    

}


#pragma mark - RateCustomDelegate

- (void) didRateWithValue:(int)count
{
    rating = count;
}



@end
