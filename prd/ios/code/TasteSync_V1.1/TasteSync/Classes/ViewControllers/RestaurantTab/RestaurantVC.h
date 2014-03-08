//
//  RestaurantVC.h
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateCustom.h"
#import "CRequest.h"
#import "JSONKit.h"
#import "AskObject.h"


@interface RestaurantVC : UIViewController<UITableViewDataSource, UITableViewDelegate,RateCustomDelegate, UIScrollViewDelegate, RequestDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *tbvResult, *tbvFilter;
    __weak IBOutlet UITextField *tfRestaurant, *tfRegion;
    __weak IBOutlet UIView *viewFilter1, *viewFilter2, *viewFilterExtends, *viewFilterSmall, *viewMain;
    __weak IBOutlet UILabel *lbTypingRestaurant, *lbTypeRegions;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIView *viewOpen, *viewChain;
    
    __weak IBOutlet UIScrollView *scrollViewCuisine, *scrollViewPrice;
    __weak IBOutlet UIButton *btSaved, *btFavs, *btDeals, *btShow, *btHide;
    __weak IBOutlet UILabel *lbSaved, *lbFaved;
    __weak IBOutlet UILabel *detailLabel;
    __weak IBOutlet UIView* titleView;
    __weak IBOutlet UIView* titleImageView;
    
    __weak IBOutlet UIImageView* openNowImage, *chainImage;
    
    __weak IBOutlet UIView *textRoundView;
    
    int _rating;
    BOOL saved, favs , deals, restaurantChains, isOpenNow;
    
    NSMutableDictionary *filterDict;
    
    __weak IBOutlet UILabel *lbCusine, *lbPrice, *lbRating, *lbShowOnlyThese;
    
    
    NSMutableArray *arrDataFilterSelect;
    NSMutableArray *arrayCuisine;
    NSMutableArray *arrayAmbience;
    NSMutableArray *arrayWhoWithYou;
    NSMutableArray *arrayPrice;
    NSMutableArray *arrayCity;
    NSMutableArray *arrayRate;
    
    NSMutableArray *arrayFilterBoxData;
    
    IBOutlet UIView* _elementView;
    IBOutlet UIView* _cuisineView;
    IBOutlet UITableView* _tableViewPrice;
    IBOutlet UITableView* _tableViewCuisine;
    __weak IBOutlet UIImageView* _cuisineImage;
    IBOutlet UITextField* _textFieldSearch;
    __weak IBOutlet UIScrollView* _scrollPriceView;
    IBOutlet UIImageView* cuisineDataImage, *neighberhoodImage, *ambienceImage, *priceImage, *whoareyouImage, *rateImage;
    BOOL isCuisine, isRate;
    AskObject* ratesObject;
}

@property (nonatomic, strong) NSMutableArray *arrData, *arrDataFilter , *arrDataRestaurant , *arrDataRegion;
@property (nonatomic,strong) NSString* recorequestID;

@property (nonatomic, assign) BOOL notHomeScreen;
@property (nonatomic, assign) int rating;

- (IBAction)actionOthersTab:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
- (IBAction)actionHideKeypad:(id)sender;

- (IBAction)actionFilter:(id)sender;
- (IBAction)actionDoneFilter:(id)sender;
- (IBAction)actionSaved:(id)sender;
- (IBAction)actionFavs:(id)sender;
- (IBAction)actionDeals:(id)sender;
- (IBAction)actionShow:(id)sender;

@end
