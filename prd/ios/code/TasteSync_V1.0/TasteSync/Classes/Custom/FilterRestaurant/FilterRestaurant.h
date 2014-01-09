//
//  FilterRestaurant.h
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateCustom.h"


#define Cuisine @"Cuisine" // array
#define Price   @"Price"    // array
#define Rating  @"Rating"   // number
#define Saved   @"Saved"    // BOOL
#define Favs    @"Favs"     //  BOOL
#define Deals   @"Deals"    // BOOL
#define Restaurant_Chains   @"Restaurant chains"    // BOOL

@class FilterRestaurant;

@protocol FilterRestaurantDelegate <NSObject>

@optional

- (void) filterRestaurant:(FilterRestaurant *) filterRestaurant didFinish :(id) anObj tag:(int) aTag;

@end

@interface FilterRestaurant : UIView <RateCustomDelegate>
{
    __weak IBOutlet UIScrollView *scrollViewCuisine, *scrollViewPrice;
    __weak IBOutlet UIButton *btSaved, *btFavs, *btDeals, *btShow, *btHide;
    __weak IBOutlet UISegmentedControl *segCtrCuisine, *segCtrPrice;
    
    NSMutableArray *arrCuisine, *arrPrice;
    int rating;
    BOOL saved, favs , deals, restaurantChains;
    
    RateCustom *rateCustom;
    NSMutableDictionary *filterDict;
}

@property (nonatomic,strong) id<FilterRestaurantDelegate> delegate;

- (void) showViewInFrame:(CGRect) frame;

- (void) show;

- (void) hide;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionSaved:(id)sender;
- (IBAction)actionFavs:(id)sender;
- (IBAction)actionDeals:(id)sender;
- (IBAction)actionShow:(id)sender;
- (IBAction)actionHide:(id)sender;


@end
