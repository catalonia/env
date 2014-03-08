//
//  RestaurantVC.m
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RestaurantVC.h"
#import "CommonHelpers.h"
#import "RestaurantCell.h"
#import "RestaurantDetailVC.h"
#import "TSGlobalObj.h"
#import "TSCuisineObj.h"
#import "LoadDataCell.h"
#import "Flurry.h"
#import "AskObject.h"
#import "AskCell.h"
#import "AskContactCell.h"
#import "AskContactVC.h"

#define DELTAHEIGHT 170

@interface RestaurantVC ()
{
    int TFSelected;
    BOOL filterExtendsShown;
    TSGlobalObj *restaurant;
    NSMutableArray *arrDataStickFilter;
    NSMutableArray *arrRestaurantSave;
    NSMutableArray *arrRestaurantFav;
    
    NSMutableArray* arrayDictionary;
    NSMutableArray* arrayLocation;
    NSMutableArray* arrayResID;
    NSString *ResName,*ResPosition;
    
    NSString* _restaurantGerenal;
    NSString* _regionGerenal;
    NSString* _storeOldValue;
    NSString* Filter, *RecorequestId, *RestaurantName, *LocationId, *RestaurantId, *Position;
    TSCityObj* _cityObj;
    BOOL _isHaveCityObj;
    BOOL _restaurantSearch;
    BOOL isRestaurantRequest;
    int numberPage;
    int currentPage;
}

typedef enum _TFSelect
{
    TFRestaurant = 1,
    TFRegion    =   2
} TFSelect;

@end

@implementation RestaurantVC

@synthesize rating = _rating;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initUI
{
    
    //TasteSync Recommendations for your search:
    
    scrollViewMain.delegate = self;
    
    viewFilterExtends.hidden = YES;
    [self refreshView];
    
    arrDataFilterSelect = [[NSMutableArray alloc]init];
    arrayFilterBoxData = [[NSMutableArray alloc]init];
    arrayCuisine = [[NSMutableArray alloc]init];
    arrayAmbience = [[NSMutableArray alloc]init];
    arrayWhoWithYou = [[NSMutableArray alloc]init];
    arrayPrice = [[NSMutableArray alloc]init];
    arrayCity = [[NSMutableArray alloc]init];
    arrayCity = [[NSMutableArray alloc]initWithArray:[CommonHelpers appDelegate].arrayNeighberhood];
    arrayRate = [[NSMutableArray alloc]init];
    arrayRate = [[NSMutableArray alloc]initWithArray:[CommonHelpers appDelegate].arrRate];
    
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrCuisine) {
        AskObject* obj = [[AskObject alloc]init];
        obj.object = global;
        obj.selected = NO;
        [arrayCuisine addObject:obj];
    }
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrDropdown) {
        int i = 0;
        for (TSGlobalObj* globalCuisine1 in [CommonHelpers appDelegate].arrCuisine) {
            NSString* str1 = [NSString stringWithFormat:@"%@", global.name];
            NSString* str2 = [NSString stringWithFormat:@"%@", globalCuisine1.name];
            i++;
            if ([str1 isEqualToString:str2]) {
                break;
            }
        }
        if (i == [CommonHelpers appDelegate].arrCuisine.count) {
            AskObject* obj = [[AskObject alloc]init];
            obj.object = global;
            obj.selected = NO;
            [arrayCuisine addObject:obj];
        }
    }
    [arrayAmbience removeAllObjects];
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrayAmbience) {
        AskObject* obj = [[AskObject alloc]init];
        obj.selected = NO;
        obj.object = global;
        [arrayAmbience addObject:obj];
    }
    
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrWhoAreUWith) {
        AskObject* obj = [[AskObject alloc]init];
        obj.selected = NO;
        obj.object = global;
        [arrayWhoWithYou addObject:obj];
    }
    
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrPrice) {
        AskObject* obj = [[AskObject alloc]init];
        obj.selected = NO;
        obj.object = global;
        [arrayPrice addObject:obj];
    }
    
    _elementView.frame = CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    [self.view addSubview:_elementView];
    _elementView.hidden = YES;
    
    _cuisineView.frame = CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    [self.view addSubview:_cuisineView];
    _cuisineView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textRoundView.layer.cornerRadius = 5;
    textRoundView.layer.masksToBounds = YES;
    
    [CommonHelpers setBackgroudImageForView:self.view];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    _regionGerenal = @"";
    _restaurantGerenal = @"";
    _cityObj = [CommonHelpers setDefaultCityObj];
    currentPage = 1;
    _isHaveCityObj = NO;
    _restaurantSearch = NO;
    viewFilter1.hidden = NO;
    viewFilter2.hidden = YES;
    [self initData];
    [self initUI];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSString* RecoreId = @"";
    if (_notHomeScreen) {
        RecoreId = _recorequestID;
    }
    
    
    NSString* jsonString = [arrayDictionary JSONString];
    NSString* jsonLocation = [arrayLocation JSONString];
    NSString* jsonRestaurant = [arrayResID JSONString];
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%@",jsonString]           , @"Cuisine",
     [NSString stringWithFormat:@"%@",jsonLocation]         , @"Neighberhood",
     [NSString stringWithFormat:@"%@",RecoreId]             , @"RecorequestId",
     [NSString stringWithFormat:@"%@",jsonRestaurant]       , @"RestaurantID",
     [NSString stringWithFormat:@"%@",ResName]              , @"RestaurantName",
     [NSString stringWithFormat:@"%@",ResPosition]          , @"RestaurantPosition",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"RestaurantMain" isBegin:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    arrayDictionary = [[NSMutableArray alloc]init];
    arrayLocation = [[NSMutableArray alloc]init];
    arrayResID = [[NSMutableArray alloc]init];
    ResName = @"";
    ResPosition = @"";
     NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""           , @"Cuisine",
     @""         , @"Neighberhood",
     @""             , @"RecorequestId",
     @""       , @"RestaurantID",
     @""              , @"RestaurantName",
     @""          , @"RestaurantPosition",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"RestaurantMain" isBegin:YES];
    
    if (isRestaurantRequest == NO) {
        if(_notHomeScreen)
        {
            _restaurantSearch = NO;
            lbTypingRestaurant.hidden = NO;
            tfRestaurant.text = @"";
            
            currentPage = 1;
            NSString* link = [NSString stringWithFormat:@"recosidrestaurantsearchresults?userid=%@&recorequestid=%@&paginationid=%@",[UserDefault userDefault].userID,self.recorequestID,@"1"];
            CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
            request.delegate = self;
            [request startFormRequest];
            
        }
        else
        {
            _restaurantSearch = NO;
            lbTypingRestaurant.hidden = NO;
            tfRestaurant.text = @"";
            detailLabel.text = @"NYC";
            _storeOldValue = [self getLinkRequest];
            _arrData = [[NSMutableArray alloc] initWithArray:[CommonHelpers appDelegate].arrayRestaurant];
            numberPage = [CommonHelpers appDelegate].numberPage;
            [tbvResult reloadData];
            tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, 0, tbvResult.frame.size.width, tbvResult.contentSize.height);
            scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
            viewMain.frame = CGRectMake(viewMain.frame.origin.x, 83, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
            
        }
        isRestaurantRequest = YES;
    }
}

- (void)fixSegmentedControlForiOS7:(UISegmentedControl*)segmentedControl
{
    NSInteger deviceVersion = [[UIDevice currentDevice] systemVersion].integerValue;
    if(deviceVersion < 7) // If this is not an iOS 7 device, we do not need to perform these customizations.
        return;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                [UIColor whiteColor], UITextAttributeTextColor,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
}
- (void) initData
{
    if(_arrData == nil)
    {
        self.arrData = [[NSMutableArray alloc] init];
    }

    if (_arrDataRestaurant == nil) {
        self.arrDataRestaurant= [[NSMutableArray alloc] init];
    }
    
    if (_arrDataRegion == nil) {
        self.arrDataRegion = [[NSMutableArray alloc] init];
        
    }
    
        
    if(_arrDataFilter == nil)
    {
        self.arrDataFilter = [[NSMutableArray alloc] init];
    }
    
    
    arrRestaurantSave = [[NSMutableArray alloc]init];
    arrRestaurantFav  = [[NSMutableArray alloc]init];
    filterDict = [[NSMutableDictionary alloc] init];
    arrDataStickFilter = [[NSMutableArray alloc] init];
}
#pragma mark - IBAction's Define

- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (IBAction)actionOthersTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}

- (IBAction)actionHideKeypad:(id)sender
{
   
    tbvFilter.hidden = YES;
    [self hideKeyBoard];
}

- (IBAction)actionFilter:(id)sender
{
    titleView.hidden = YES;
    [self hideKeyBoard];
    filterExtendsShown = TRUE;
    [self refreshView];
}

- (IBAction)actionDoneFilter:(id)sender
{
    titleView.hidden = NO;
    filterExtendsShown = FALSE;
    _restaurantSearch = NO;
    
    
    [self refreshView];
    [self performSelector:@selector(doneFilter) withObject:nil afterDelay:0.5];
    
}

-(void)doneFilter
{
    NSString* linkRequest = [self getLinkRequest];
    if (![linkRequest isEqualToString:_storeOldValue]) {
        _storeOldValue = linkRequest;
        currentPage = 1;
        [_arrData removeAllObjects];
        [tbvResult reloadData];
        tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.contentSize.height);
        scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
        viewMain.frame = CGRectMake(viewMain.frame.origin.x, -53, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
        [self requestRestaurant:@"restsearchresults" Key:4];
    }
    
    [arrayDictionary addObject:[self getDictionary]];
}

-(NSString*)getListType:(GlobalDataType)type
{
    NSString* ret = @"";
    
    for (TSGlobalObj* global in arrDataFilterSelect) {
        if (global.type == type ) {
            if (ret.length == 0) {
                ret = global.uid;
            }
            else
                ret = [ret stringByAppendingFormat:@",%@", global.uid];
        }
    }
    return ret;
}

-(void)addType:(NSMutableArray*)array ListID:(NSString*)list Type:(GlobalDataType)type
{
    NSArray* arrayList = [list componentsSeparatedByString:@","];
    
   
        for (NSString* string in arrayList) {
             for (AskObject* global in array) {
                 NSString* id1 = [NSString stringWithFormat:@"%@",global.object.uid];
                 NSString* id2 = [NSString stringWithFormat:@"%@",string];
                 if ([id1 isEqualToString:id2] && global.object.type == type) {
                     global.selected = YES;
                     
                 }
             }
        }
}

-(NSString*)getLinkRequest
{
    
    NSLog(@"%@",[[self getDictionary] JSONString]);
    return [[self getDictionary] JSONString];
}

-(NSMutableDictionary*)getDictionary
{
    
    NSString* openFlag  = @"0";
    NSString* savedFlag = @"0";
    NSString* favFlag   = @"0";
    NSString* chainFlag = @"0";
    
    if (isOpenNow) {
        openFlag = @"1";
    }
    
    if (saved) {
        savedFlag = @"1";
    }
    
    if (favs) {
        favFlag = @"1";
    }
    
    if (restaurantChains) {
        chainFlag = @"1";
    }
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
    TSGlobalObj* region;
    for (TSGlobalObj* global in arrDataFilterSelect) {
        if (global.type == GlobalDataCity) {
            region = global;
        }
    }
    
    [dictionary setValue:[self getListType:GlobalDataCuisine_1]        forKey:@"cuisinetier1idlist"];
    [dictionary setValue:[self getListType:GlobalDataCuisine_2]        forKey:@"cuisinetier2idlist"];
    [dictionary setValue:[self getListType:GlobalDataPrice]            forKey:@"priceidlist"];
    [dictionary setValue:[self getListType:GlobalDataTheme]            forKey:@"themeidlist"];
    [dictionary setValue:[self getListType:GlobalDataWhoAreUWith]      forKey:@"whoareyouwithidlist"];
    [dictionary setValue:[self getListType:GlobalDataTypeOfRestaurant] forKey:@"typeofrestaurantidList"];
    [dictionary setValue:[self getListType:GlobalDataOccasion]         forKey:@"occasionidlist"];
    [dictionary setValue:[self getListType:GlobalDataRate]         forKey:@"rating"];
    [dictionary setValue:openFlag                  forKey:@"openNowFlag"];
    [dictionary setValue:savedFlag                 forKey:@"savedFlag"];
    [dictionary setValue:favFlag                   forKey:@"favFlag"];
    [dictionary setValue:chainFlag                 forKey:@"chainFlag"];
    
    if (region.cityObj != nil) {
        [dictionary setValue:region.cityObj.neighbourhoodID forKey:@"neighborhoodid"];
        [dictionary setValue:region.cityObj.uid forKey:@"cityid"];
        [dictionary setValue:region.cityObj.stateName forKey:@"statename"];
    }
    else
    {
        [dictionary setValue:@"" forKey:@"neighborhoodid"];
        [dictionary setValue:[CommonHelpers getDefaultCityObj].cityObj.uid forKey:@"cityid"];
        [dictionary setValue:[CommonHelpers getDefaultCityObj].cityObj.stateName forKey:@"statename"];
    }
    
    
    return dictionary;
}

-(void)requestRestaurant:(NSString*)link Key:(int)key
{
    
    tfRegion.text = @"";
    tfRestaurant.text = @"";
    lbTypeRegions.hidden = NO;
    lbTypingRestaurant.hidden = NO;
    
    
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:key WithView:self.view];
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
    NSString* openFlag  = @"0";
    NSString* savedFlag = @"0";
    NSString* favFlag   = @"0";
    NSString* chainFlag = @"0";
    
    if (isOpenNow) {
        openFlag = @"1";
    }
    
    if (saved) {
        savedFlag = @"1";
    }
    
    if (favs) {
        favFlag = @"1";
    }
    
    if (restaurantChains) {
        chainFlag = @"1";
    }
    
    TSGlobalObj* region;
    for (TSGlobalObj* global in arrDataFilterSelect) {
        if (global.type == GlobalDataCity) {
            region = global;
        }
    }
    
    [request setFormPostValue:[self getListType:GlobalDataCuisine_1]        forKey:@"cuisinetier1idlist"];
    [request setFormPostValue:[self getListType:GlobalDataCuisine_2]        forKey:@"cuisinetier2idlist"];
    [request setFormPostValue:[self getListType:GlobalDataPrice]            forKey:@"priceidlist"];
    [request setFormPostValue:[self getListType:GlobalDataTheme]            forKey:@"themeidlist"];
    [request setFormPostValue:[self getListType:GlobalDataWhoAreUWith]      forKey:@"whoareyouwithidlist"];
    [request setFormPostValue:[self getListType:GlobalDataTypeOfRestaurant] forKey:@"typeofrestaurantidList"];
    [request setFormPostValue:[self getListType:GlobalDataOccasion]         forKey:@"occasionidlist"];
    [request setFormPostValue:[self getListType:GlobalDataRate]             forKey:@"rating"];
    [request setFormPostValue:openFlag                                      forKey:@"opennownlag"];
    [request setFormPostValue:savedFlag                                     forKey:@"savedFlag"];
    [request setFormPostValue:favFlag                                       forKey:@"favFlag"];
    [request setFormPostValue:chainFlag                                     forKey:@"chainFlag"];
    [request setFormPostValue:[NSString stringWithFormat:@"%d",currentPage]             forKey:@"paginationid"];
    [request setFormPostValue:[self getListType:GlobalDataCity] forKey:@"neighborhoodid"];
    [request setFormPostValue:[CommonHelpers getDefaultCityObj].cityObj.uid forKey:@"cityid"];
    [request setFormPostValue:[CommonHelpers getDefaultCityObj].cityObj.stateName forKey:@"statename"];
    
    
    [request setFormPostValue:openFlag forKey:@"opennowflag"];
    [request setFormPostValue:savedFlag forKey:@"savedflag"];
    [request setFormPostValue:favFlag forKey:@"favflag"];
    [request setFormPostValue:@"0" forKey:@"dealflag"];
    [request setFormPostValue:chainFlag forKey:@"chainflag"];
    
    request.delegate = self;
    [request startFormRequest];
    
    
    NSLog(@"cuisinetier1idlist: %@", [self getListType:GlobalDataCuisine_1]);
    NSLog(@"cuisinetier2idlist: %@", [self getListType:GlobalDataCuisine_2]);
    NSLog(@"whoareyouwithidlist: %@", [self getListType:GlobalDataWhoAreUWith]);
    NSLog(@"typeofrestaurantidList: %@", [self getListType:GlobalDataTypeOfRestaurant]);
    NSLog(@"occasionidlist: %@", [self getListType:GlobalDataOccasion]);
    NSLog(@"priceidlist: %@", [self getListType:GlobalDataPrice]);
    NSLog(@"themeidlist: %@", [self getListType:GlobalDataTheme]);
    NSLog(@"neighborhoodid: %@", [self getListType:GlobalDataCity]);
    
    NSLog(@"openflag: %@", openFlag);
    NSLog(@"savedflag: %@", savedFlag);
    NSLog(@"favflag: %@", favFlag);
    NSLog(@"chainflag: %@", chainFlag);
    
}

-(void)requestWithRecorequestID
{
    NSString* page = [NSString stringWithFormat:@"%d",currentPage];
    NSString* link = [NSString stringWithFormat:@"recosidrestaurantsearchresults?userid=%@&recorequestid=%@&paginationid=%@",[UserDefault userDefault].userID,self.recorequestID,page];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

- (void) refreshView
{
    if (filterExtendsShown) {
        viewFilterExtends.hidden = NO;
        [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, 450, tbvResult.frame.size.width, tbvResult.contentSize.height)];
        scrollViewMain.contentSize = CGSizeMake(320, tbvResult.contentSize.height + DELTAHEIGHT);
        viewMain.frame = CGRectMake(viewMain.frame.origin.x, -53, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
        
    }
    else
    {
        viewFilterExtends.hidden = YES;
        [self resizeDetailText];
        scrollViewMain.contentSize = CGSizeMake(320, tbvResult.contentSize.height + DELTAHEIGHT);
        //viewMain.frame = CGRectMake(viewMain.frame.origin.x, 83, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
    }
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
    CGFloat total = 0;
    for (NSUInteger i = 0; i < nSegments; i++) {
        // size for label width plus an equal share of the space
        CGFloat textWidth = [[segCtrl titleForSegmentAtIndex:i] sizeWithFont:theFont].width;
        // roundf??  the control leaves 1 pixel gap between segments if width
        // is not an integer value, the roundf fixes this
        CGFloat segWidth = roundf(textWidth + (spaceWidth / nSegments));
        total += segWidth;
        [segCtrl setWidth:segWidth forSegmentAtIndex:i];
    }
}

#pragma mark - IBAction Define

- (IBAction)actionSaved:(id)sender
{
    if (saved) {
        saved = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"save-2.png"] forButton:btSaved];
        lbSaved.text = @"Try Later";
    }
    else
    {
        saved = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved.png"] forButton:btSaved];
        lbSaved.text = @"Try Later";
        
    }
}
- (IBAction)actionFavs:(id)sender
{
    if (favs) {
        favs = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"fav-2.png"] forButton:btFavs];
        lbFaved.text = @"Favs";
        
    }
    else
    {
        favs = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addtomyfaves.png"] forButton:btFavs];
        lbFaved.text = @"Favs";
        
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
    if (restaurantChains == NO) {
        restaurantChains = YES;
        chainImage.image = [UIImage imageNamed:@"resturant_chain_orange.png"];
    }
    else
    {
        restaurantChains = NO;
        chainImage.image = [UIImage imageNamed:@"restaurant_chain_black.png"];
    }
}
- (IBAction)actionOpenNow:(id)sender
{
    if (isOpenNow == NO) {
        isOpenNow = YES;
        openNowImage.image = [UIImage imageNamed:@"open_now_orange.png"];
    }
    else
    {
        isOpenNow = NO;
        openNowImage.image = [UIImage imageNamed:@"open_now_black.png"];
    }
}
- (IBAction)actionSegmentControl:(id)sender
{
    UISegmentedControl *segCtr = (UISegmentedControl *)sender;
    debug(@"segCtr selectedIndex -> %d", segCtr.selectedSegmentIndex);
    
    
    TSGlobalObj *strObj;

    if ([arrDataStickFilter containsObject:strObj]) {
        [arrDataStickFilter removeObject:strObj];
        for (int i = 0; i< [[sender subviews] count]; i++) {
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

-(IBAction)actionShare:(id)sender
{
    [self requestRestaurant:@"recotxt" Key:5];
}


#pragma mark - RateCustomDelegate

- (void) didRateWithValue:(int)count
{
    self.rating = count;
    NSLog(@"count");
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tbvResult) {
        if (_arrData) {
            
            if (currentPage >= numberPage || _restaurantSearch)
                return _arrData.count;
            else
                return _arrData.count + 1;
        }
    }else
    {
        if (_arrDataFilter && tableView == tbvFilter) {
            return _arrDataFilter.count;
        }
        if ((tableView == _tableViewCuisine || tableView == _tableViewPrice) && arrayFilterBoxData) {
            return arrayFilterBoxData.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvResult) {
        
        if (indexPath.row == _arrData.count) {
            static NSString *CellIndentifier = @"LoadDataCell";
            
            LoadDataCell *cell = (LoadDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            
            if (cell==nil) {
                cell =(LoadDataCell *) [[[NSBundle mainBundle ] loadNibNamed:@"LoadDataCell" owner:self options:nil] objectAtIndex:0];
            }
            return cell;
        }
        static NSString *CellIndentifier = @"RestaurantCell";
        
        RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(RestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantCell" owner:self options:nil] objectAtIndex:0];
        }
        
        TSGlobalObj* obj = [_arrData objectAtIndex:indexPath.row];
        cell.isJustName = _restaurantSearch;
        [cell initForView:obj.restaurantObj];
//        cell.delegate =self;
        return cell;
    }
    if (tableView==tbvFilter)
    {
        static NSString *CellIndentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        //fix here
        TSGlobalObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        cell.textLabel.text = obj.name;
       
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        
        return cell;
    }
    if (tableView == _tableViewPrice) {
        static NSString *CellIndentifier = @"AskCell";
        
        AskCell *cell = (AskCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(AskCell *) [[[NSBundle mainBundle ] loadNibNamed:CellIndentifier owner:self options:nil] objectAtIndex:0];
        }
        AskObject* obj = [arrayFilterBoxData objectAtIndex:indexPath.row];
        cell.name.text = obj.object.name;
        //this is code resize image
        NSString *fileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",obj.object.imageURL]];
        cell.image.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName] withSize:CGSizeMake(290, 94)];
        //not resize
        //cell.image.image = [CommonHelpers getImageFromName:@"images.jpeg"];
        if (obj.selected) {
            cell.selectImage.hidden = NO;
        }
        else
        {
            cell.selectImage.hidden = YES;
        }
        
        return cell;
    }
    else
    {
        static NSString* CellIndentifier = @"AskContactCell";
        AskContactCell *cell = (AskContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(AskContactCell *) [[[NSBundle mainBundle ] loadNibNamed:CellIndentifier owner:self options:nil] objectAtIndex:0];
        }
        AskObject* obj = [arrayFilterBoxData objectAtIndex:indexPath.row];
        if (obj.selected) {
            [cell.buttonright setImage:[CommonHelpers getImageFromName:@"Tick mark icon.png"] forState:UIControlStateHighlighted];
            [cell.buttonright setImage:[CommonHelpers getImageFromName:@"Tick mark icon.png"] forState:UIControlStateNormal];
        }
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        cell.name.text = obj.object.name;
        cell.name.textColor = [UIColor whiteColor];
        cell.askObject = obj;
        //cell.name.font = [UIFont systemFontOfSize:14];
        cell.name.frame = CGRectMake(cell.name.frame.origin.x, cell.name.frame.origin.y, cell.name.frame.size.width + 20, cell.name.frame.size.height);
        [cell refreshView];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableViewCuisine || tableView == tbvFilter) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvResult) {
        if (indexPath.row == _arrData.count) {
            static NSString *CellIndentifier = @"LoadDataCell";
            
            LoadDataCell *cell = (LoadDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            
            if (cell==nil) {
                cell =(LoadDataCell *) [[[NSBundle mainBundle ] loadNibNamed:@"LoadDataCell" owner:self options:nil] objectAtIndex:0];
            }
            return cell.frame.size.height;
        }
        static NSString *CellIndentifier = @"RestaurantCell";
        
        RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell = (RestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantCell" owner:self options:nil] objectAtIndex:0];
        }
        TSGlobalObj *obj = [_arrData objectAtIndex:indexPath.row];
        cell.isJustName = _restaurantSearch;
        return [cell getHeight:obj.restaurantObj];
    }
    if (tableView==tbvFilter)
    {
        static NSString *CellIndentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        
        return cell.frame.size.height;
    }
    if (tableView == _tableViewPrice) {
        static NSString *CellIndentifier = @"AskCell";
        AskCell *cell = (AskCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell =(AskCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AskCell" owner:self options:nil] objectAtIndex:0];
        }
        return cell.frame.size.height;
    }
    else
    {
        static NSString* CellIndentifier = @"AskContactCell";
        AskContactCell *cell = (AskContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(AskContactCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AskContactCell" owner:self options:nil] objectAtIndex:0];
        }
        return cell.frame.size.height;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyBoard];
    if (tableView==tbvFilter) {
        if (TFSelected == TFRestaurant) {
            TSGlobalObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
            [self.arrData removeAllObjects];
            [self.arrData addObject:obj];
            tfRestaurant.text = @"";
            lbTypingRestaurant.hidden = NO;
            restaurant = obj;
            [tbvResult reloadData];
            scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
            
            titleView.hidden = YES;
            viewMain.frame = CGRectMake(viewMain.frame.origin.x, -53, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
            [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, 56 , tbvResult.frame.size.width, tbvResult.contentSize.height)];
            
            [arrayResID addObject:obj.uid];
            
            for (AskObject* obj in arrayAmbience) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayPrice) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayWhoWithYou) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayCity) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayCuisine) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayWhoWithYou) {
                obj.selected = NO;
            }
            for (AskObject* obj in arrayRate) {
                obj.selected = NO;
            }
            
            cuisineDataImage.hidden = YES;
            neighberhoodImage.hidden = YES;
            ambienceImage.hidden = YES;
            priceImage.hidden = YES;
            whoareyouImage.hidden = YES;
            rateImage.hidden = YES;
            
            [arrDataFilterSelect removeAllObjects];
            
            detailLabel.text = @"NYC";
            _storeOldValue = [self getLinkRequest];
            
            //[self resizeDetailText];
            
        }
        else if (TFSelected == TFRegion)
        {
            TSGlobalObj* gloabal =  [_arrDataFilter objectAtIndex:indexPath.row];
            tfRegion.text = gloabal.name;
            lbTypeRegions.hidden = YES;
            _isHaveCityObj = YES;
            _cityObj = gloabal.cityObj;
            _restaurantGerenal = @"";
            [arrayLocation addObject:gloabal.cityObj.uid];
        }
        else
        {
            
        }
      
        tbvFilter.hidden= YES;
       
        [self.arrDataFilter removeAllObjects];
    }
    if (tableView == tbvResult)
    {
        if (indexPath.row < _arrData.count) {
            TSGlobalObj* obj = [_arrData objectAtIndex:indexPath.row];
            
            RestaurantObj* restaurantObj = obj.restaurantObj;
            restaurantObj.uid = restaurantObj.uid;
            ResPosition = [NSString stringWithFormat:@"%d",indexPath.row + 1];
            restaurantObj.name = restaurantObj.name;
            ResName = restaurantObj.name;
            RestaurantDetailVC *vc = [[RestaurantDetailVC alloc] initWithRestaurantObj:restaurantObj];
            vc.selectedIndex = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    if (tableView == _tableViewCuisine) {
        if (isCuisine) {
            AskObject* obj = [arrayFilterBoxData objectAtIndex:indexPath.row];
            obj.selected = !obj.selected;
            [_tableViewCuisine reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            AskObject* obj = [arrayFilterBoxData objectAtIndex:indexPath.row];
            if (obj.selected == YES) {
                obj.selected = NO;
                if (isRate) {
                    ratesObject = nil;
                }
            }
            else
            {
                obj.selected = YES;
                if (isRate) {
                    if (ratesObject != nil) {
                        ratesObject.selected = NO;
                    }
                    ratesObject = obj;
                }
            }
            
            [_tableViewCuisine reloadData];
        }
    }
    if (tableView == _tableViewPrice) {
        AskObject* obj = [arrayFilterBoxData objectAtIndex:indexPath.row];
        obj.selected = !obj.selected;
        [_tableViewPrice reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    textField.text = @"";

    if (textField == tfRestaurant) {
        TFSelected = TFRestaurant;
        lbTypingRestaurant.hidden= YES;
        restaurant = nil;
    }
    else
    {
        TFSelected = TFRegion;
        lbTypeRegions.hidden = YES;
        _isHaveCityObj = NO;
        _cityObj = [CommonHelpers setDefaultCityObj];
    }
    
    
    
    return YES;
}




-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [self hideKeyBoard];
    tbvFilter.hidden= YES;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    tbvFilter.hidden= YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (TFSelected == TFRestaurant) {
        _restaurantSearch =YES;
    }
    NSString* searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    double delayInSeconds = TIMER_DELAY;
    dispatch_time_t popTimer = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC);
    dispatch_after(popTimer, dispatch_get_main_queue(), ^(void){
        if ([searchText isEqualToString:tfRestaurant.text]) {
            [self searchLocal:searchText];
        }
        //[NSThread detachNewThreadSelector:@selector(thread:) toTarget:self withObject:searchText];
    });
    return YES;
    
}

-(void)thread:(id)obj
{
    NSString* text = (NSString*)obj;
    if ([text isEqualToString:tfRestaurant.text]) {
        [self searchLocal:tfRestaurant.text];
    }
    
}

#pragma mark - Others

- (void) searchLocal:(NSString *)txt
{
    
    
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    if (txt.length == 0) {
        return;
        
    }
    
    if (TFSelected == TFRestaurant) {
        //![txt isEqualToString:_restaurantGerenal] && 
        if (txt.length >= 1) {
            NSLog(@"Start request restaurant");
            _restaurantGerenal = txt;
            _restaurantSearch = YES;
            currentPage = 0;
            numberPage = 0;
            TSGlobalObj* region1 = [CommonHelpers getDefaultCityObj];
            
            CRequest* request = [[CRequest alloc]initWithURL:@"suggestrestaurantnames" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:1 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:txt forKey:@"key"];
            if (_isHaveCityObj) 
                [request setFormPostValue:_cityObj.uid forKey:@"cityid"];
            else
                [request setFormPostValue:region1.cityObj.uid forKey:@"cityid"];
            [request startFormRequest];
        }
        
    }
    else if(TFSelected == TFRegion)
    {
        if (txt.length >= 1) {
            NSLog(@"Start request region");
            _regionGerenal = txt;
            CRequest* request = [[CRequest alloc]initWithURL:@"getCity" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:txt forKey:@"key"];
            [request startFormRequest];
        }
        
        
    }
    else
    {
        
    }
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    tbvFilter.hidden = YES;
    [self hideKeyBoard];
}

- (void) hideKeyBoard
{
    [tfRegion resignFirstResponder];
    [tfRestaurant resignFirstResponder];
//    tfRegion.text = region.name;
    if (restaurant ==nil) {
        lbTypingRestaurant.hidden = NO;
        tfRestaurant.text = nil;
    }
}

#pragma mark - UISCrollViewDelegate


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != _tableViewPrice && scrollView != _tableViewCuisine) {
        if(scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
        {
            currentPage++;
            
            if (currentPage <= numberPage) {
                if (_notHomeScreen == NO) {
                    [self requestRestaurant:@"restsearchresults" Key:4];
                }
                else
                    [self requestWithRecorequestID];
            }
            
        }
    }
    
    
}

#pragma mark response Data
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@",response);
    
    if (key == 1) {
        [_arrDataRestaurant removeAllObjects];
        numberPage = -1;
        currentPage = 1;
        //[_arrData removeAllObjects];
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.type = GlobalDataRestaurant;
            global.uid = [dic objectForKey:@"restaurantId"];
            global.name = [dic objectForKey:@"restaurantName"];
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid =  [dic objectForKey:@"restaurantId"];
            restaurantObj.name = [dic objectForKey:@"restaurantName"];            
            global.restaurantObj = restaurantObj;
            [_arrDataRestaurant addObject:global];
            
        }
        _arrDataFilter = [[NSMutableArray alloc]initWithArray:_arrDataRestaurant];
        //_arrData = [[NSMutableArray alloc]initWithArray:_arrDataRestaurant];
        if (self.arrDataFilter.count>0) {
            tbvFilter.hidden = NO;
            [tbvFilter reloadData];
            //[tbvResult reloadData];
            //tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.contentSize.height);
            //scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
        }
    }
    if (key == 2) {
        [_arrDataRegion removeAllObjects];
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.type = GlobalDataCity;
            global.uid = [dic objectForKey:@"id"];
            global.name = [dic objectForKey:@"name"];
            
            
            NSDictionary* dic2 = [dic objectForKey:@"city"];
            TSCityObj* cityObj = [[TSCityObj alloc]init];
            
            cityObj.uid              = [dic2 objectForKey:@"cityId"];
            cityObj.cityName         = [dic2 objectForKey:@"country"];
            cityObj.stateName        = [dic2 objectForKey:@"state"];
            cityObj.country          = [dic2 objectForKey:@"city"];
            global.cityObj = cityObj;
            [_arrDataRegion addObject:global];
        }
        _arrDataFilter = [[NSMutableArray alloc]initWithArray:_arrDataRegion];
        if (self.arrDataFilter.count>0) {
            tbvFilter.hidden = NO;
            [tbvFilter reloadData];
            [tbvResult reloadData];
            tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.contentSize.height);
            scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
            viewMain.frame = CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
        }
    }
    if (key == 3) {
        NSLog(@"responseRestaurant: %@",response);
        NSDictionary* dicAll = [response objectFromJSONString];
        numberPage = [[dicAll objectForKey:@"maxPaginationId"] integerValue];
        
        if (currentPage == 1) {
            [CommonHelpers appDelegate].arrayRestaurant = [[NSMutableArray alloc]init];
        }
        
        NSArray* array = [dicAll objectForKey:@"restaurantsSearchListTileObj"];
        for (NSDictionary* dic in array) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.type = GlobalDataRestaurant;
            
            
            
            global.uid = [dic objectForKey:@"restaurantId"];
            global.name = [dic objectForKey:@"restaurantName"];
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid =  [dic objectForKey:@"restaurantId"];
            restaurantObj.name = [dic objectForKey:@"restaurantName"];
            restaurantObj.cuisineTier2 = [dic objectForKey:@"cuisineTier2Name"];
            restaurantObj.price     = [dic objectForKey:@"price"];
            restaurantObj.deal      =  [dic objectForKey:@"restaurantDealFlag"];
            restaurantObj.rates     = [[dic objectForKey:@"restaurantRating"] floatValue];
            
            restaurantObj.lattitude     = [[dic objectForKey:@"restaurantLat"] floatValue];
            restaurantObj.longtitude    = [[dic objectForKey:@"restaurantLong"] floatValue];
            restaurantObj.cityObj = [[TSCityObj alloc]init];
            restaurantObj.cityObj.cityName = [dic objectForKey:@"restaurantCity"];
            
            global.restaurantObj = restaurantObj;
            [_arrData addObject:global];
            [[CommonHelpers appDelegate].arrayRestaurant addObject:global];
        }
        
        
        NSDictionary* dicDetail = [dicAll objectForKey:@"inputParams"];
        NSString* cuisineTier2 = @"";
        
        if (![[dicDetail objectForKey:@"cuisineTier2idlist"] isKindOfClass:([NSNull class])]) {
            cuisineTier2 = [dicDetail objectForKey:@"cuisineTier2idlist"];
        }

        detailLabel.text = [CommonHelpers getFilterString:[dicDetail objectForKey:@"cityid"] cuisinetier1ID:[dicDetail objectForKey:@"cuisinetier1idlist"]  cuisinetier2ID:cuisineTier2  neighborhoodid:[dicDetail objectForKey:@"neighborhoodid"]  occasionidlist:[dicDetail objectForKey:@"occasionidlist"]  priceidlist:[dicDetail objectForKey:@"priceidlist"]  themeidlist:[dicDetail objectForKey:@"themeidlist"]  typeofrestaurantidList:[dicDetail objectForKey:@"typeofrestaurantidList"]  whoareyouwithidlist:[dicDetail objectForKey:@"whoareyouwithidlist"] openNow:[dicDetail objectForKey:@"opennowflag"] FavedFlag:[dicDetail objectForKey:@"favflag"] SavedFlag:[dicDetail objectForKey:@"savedflag"] ChainFlag:[dicDetail objectForKey:@"chainflag"] Rate:[dicDetail objectForKey:@"rating"]];
        
        
        //[self addType:self.arrDataRegion ListID:[dicDetail objectForKey:@"cityid"]];
        [self addType:arrayCuisine ListID:[dicDetail objectForKey:@"cuisinetier1idlist"] Type:GlobalDataCuisine_1];
        [self addType:arrayCuisine ListID:[dicDetail objectForKey:@"cuisinetier2idlist"] Type:GlobalDataCuisine_2];
        [self addType:arrayAmbience ListID:[dicDetail objectForKey:@"occasionidlist"] Type:GlobalDataOccasion];
        [self addType:arrayPrice ListID:[dicDetail objectForKey:@"priceidlist"] Type:GlobalDataPrice];
        [self addType:arrayAmbience ListID:[dicDetail objectForKey:@"themeidlist"] Type:GlobalDataTheme];
        [self addType:arrayAmbience ListID:[dicDetail objectForKey:@"typeofrestaurantidList"] Type:GlobalDataTypeOfRestaurant];
        [self addType:arrayWhoWithYou ListID:[dicDetail objectForKey:@"whoareyouwithidlist"] Type:GlobalDataWhoAreUWith];
        [self addType:arrayCity ListID:[dicDetail objectForKey:@"neighborhoodid"] Type:GlobalDataCity];
        UIButton* button = [[UIButton alloc]init];
        button.tag = 1;
        [self doneAction:button];
        UIButton* button2 = [[UIButton alloc]init];
        button2.tag = 0;
        [self doneAction:button2];
        
        _storeOldValue = [self getLinkRequest];
        
        [self resizeDetailText];
        
        
        [tbvResult reloadData];
        
        
        
        tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.contentSize.height);
        scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
        viewMain.frame = CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
        
    }
    if (key == 4) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseRestaurant: %@",response);
        NSDictionary* dicAll = [response objectFromJSONString];
        [CommonHelpers appDelegate].numberPage = [[dicAll objectForKey:@"maxPaginationId"] integerValue];
        if (currentPage == 1) {
            [CommonHelpers appDelegate].arrayRestaurant = [[NSMutableArray alloc]init];
        }
        
        NSArray* array = [dicAll objectForKey:@"restaurantsSearchListTileObj"];
        for (NSDictionary* dic in array) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.type = GlobalDataRestaurant;
            global.uid = [dic objectForKey:@"restaurantId"];
            global.name = [dic objectForKey:@"restaurantName"];
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid =  [dic objectForKey:@"restaurantId"];
            restaurantObj.name = [dic objectForKey:@"restaurantName"];
            restaurantObj.cuisineTier2 = [dic objectForKey:@"cuisineTier2Name"];
            restaurantObj.price     = [dic objectForKey:@"price"];
            restaurantObj.deal      =  [dic objectForKey:@"restaurantDealFlag"];
            restaurantObj.rates     = [[dic objectForKey:@"restaurantRating"] floatValue];
            
            restaurantObj.lattitude     = [[dic objectForKey:@"restaurantLat"] floatValue];
            restaurantObj.longtitude    = [[dic objectForKey:@"restaurantLong"] floatValue];
            restaurantObj.cityObj = [[TSCityObj alloc]init];
            restaurantObj.cityObj.cityName = [dic objectForKey:@"restaurantCity"];
            
            global.restaurantObj = restaurantObj;
            [_arrData addObject:global];
            [[CommonHelpers appDelegate].arrayRestaurant addObject:global];
        }
        viewFilter1.hidden = NO;
        viewFilter2.hidden = YES;
        
        currentPage = 1;
        
        NSDictionary* dicDetail = [dicAll objectForKey:@"inputParams"];
        NSString* cuisineTier2 = @"";
        
        if (![[dicDetail objectForKey:@"cuisineTier2idlist"] isKindOfClass:([NSNull class])]) {
            cuisineTier2 = [dicDetail objectForKey:@"cuisineTier2idlist"];
        }
        
        detailLabel.text = [CommonHelpers getFilterString:[dicDetail objectForKey:@"cityid"] cuisinetier1ID:[dicDetail objectForKey:@"cuisinetier1idlist"]  cuisinetier2ID:cuisineTier2  neighborhoodid:[dicDetail objectForKey:@"neighborhoodid"]  occasionidlist:[dicDetail objectForKey:@"occasionidlist"]  priceidlist:[dicDetail objectForKey:@"priceidlist"]  themeidlist:[dicDetail objectForKey:@"themeidlist"]  typeofrestaurantidList:[dicDetail objectForKey:@"typeofrestaurantidList"]  whoareyouwithidlist:[dicDetail objectForKey:@"whoareyouwithidlist"] openNow:[dicDetail objectForKey:@"opennowflag"] FavedFlag:[dicDetail objectForKey:@"favflag"] SavedFlag:[dicDetail objectForKey:@"savedflag"] ChainFlag:[dicDetail objectForKey:@"chainflag"] Rate:[dicDetail objectForKey:@"rating"]];
        
        [self resizeDetailText];
        
        numberPage = [CommonHelpers appDelegate].numberPage;
        _arrData = [[NSMutableArray alloc]initWithArray:[CommonHelpers appDelegate].arrayRestaurant];
        [tbvResult reloadData];
        tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.contentSize.height);
        scrollViewMain.contentSize = CGSizeMake(scrollViewMain.contentSize.width, tbvResult.contentSize.height + DELTAHEIGHT);
        viewMain.frame = CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
    }
    if (key == 5) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        NSDictionary* dicAll = [response objectFromJSONString];
        AskContactVC* askContact = [[AskContactVC alloc]initWithRestaurant:[dicAll objectForKey:@"valueNameValue"]];
        [self.navigationController pushViewController:askContact animated:NO];
        
    }
}

-(void)resizeDetailText
{
    
    CGSize labelHeight;
    
    
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = detailLabel.text;
    
    //Label font
    UIFont *aLabelFont = detailLabel.font;
    
    //Width of the Label
    CGFloat aLabelSizeWidth = detailLabel.frame.size.width;
    
    
    if (SYSTEM_VERSION_LESS_THAN(iOS7_0)) {
        //version < 7.0
        
        labelHeight = [aLabelTextString sizeWithFont:aLabelFont
                            constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOS7_0)) {
        //version >= 7.0
        
        //Return the calculated size of the Label
        labelHeight = [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;
        
    }
    
    titleView.frame = CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y, titleView.frame.size.width, labelHeight.height + 48);
    detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, labelHeight.height + 10);
    
    [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, labelHeight.height + 110 - 136, tbvResult.frame.size.width, tbvResult.contentSize.height)];
    viewMain.frame = CGRectMake(viewMain.frame.origin.x, 83, viewMain.frame.size.width, tbvResult.contentSize.height + 440);
}

-(IBAction)doneAction:(id)sender
{
    [self showTabBar:self.tabBarController];
    [_textFieldSearch resignFirstResponder];
    _elementView.hidden = YES;
    _cuisineView.hidden = YES;
    UIButton* button = (UIButton*)sender;
    if (button.tag == 0) {
        
        ambienceImage.hidden = YES;
        for (AskObject* obj in arrayAmbience) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
                ambienceImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                ambienceImage.hidden = NO;
            }
        }
        
        priceImage.hidden = YES;
        for (AskObject* obj in arrayPrice) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
                priceImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                priceImage.hidden = NO;
            }
        }
        
        whoareyouImage.hidden = YES;
        for (AskObject* obj in arrayWhoWithYou) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
                whoareyouImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                whoareyouImage.hidden = NO;
            }
        }
    }
    else
    {
        neighberhoodImage.hidden = YES;
        for (AskObject* obj in arrayCity) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                neighberhoodImage.hidden = NO;
            }
            
        }
        
        rateImage.hidden = YES;
        for (AskObject* obj in arrayRate) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                rateImage.hidden = NO;
            }
            
        }
        
        cuisineDataImage.hidden = YES;
        for (AskObject* obj in arrayCuisine) {
            if (obj.selected == YES && ![arrDataFilterSelect containsObject:obj.object]) {
                [arrDataFilterSelect addObject:obj.object];
                cuisineDataImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataFilterSelect removeObject:obj.object];
            }
            else
            {
                cuisineDataImage.hidden = NO;
            }
        }
        
    }
    
    NSLog(@"%d", arrDataFilterSelect.count);
    
    
    [arrayFilterBoxData removeAllObjects];
    [_tableViewPrice reloadData];
    [_tableViewCuisine reloadData];
    
}

-(BOOL)isExist:(NSMutableArray*)array RestaurantID:(NSString*)uid
{
    for (RestaurantObj* obj in array) {
        if ([obj.uid isEqualToString:uid]) {
            return YES;
        }
    }
    return NO;
}


-(IBAction)cuisinePress:(id)sender
{
    [self hideTabBar:self.tabBarController];
    _cuisineView.hidden = NO;
    [arrayFilterBoxData removeAllObjects];
    _textFieldSearch.placeholder = @"Search Cuisines";
    NSString *fileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/cuisine_popup_back.png"]];
    _cuisineImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName] withSize:CGSizeMake(_cuisineImage.frame.size.width, _cuisineImage.frame.size.height)];
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 0:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayCuisine];
            isCuisine = YES;
            break;
        case 1:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayCity];
            isCuisine = YES;
            //isRate = NO;
            break;
        case 2:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayRate];
            isCuisine = NO;
            isRate = YES;
            break;
        default:
            break;
    }
    
    [_tableViewCuisine reloadData];
    
}
-(IBAction)ambiencePress:(id)sender
{
    [self hideTabBar:self.tabBarController];
    _elementView.hidden = NO;
    [arrayFilterBoxData removeAllObjects];
    _textFieldSearch.placeholder = @"Search Cuisines";
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 0:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayAmbience];
            isCuisine = YES;
            break;
        case 1:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayWhoWithYou];
            isCuisine = NO;
            isRate = NO;
            break;
        case 2:
            arrayFilterBoxData = [[NSMutableArray alloc]initWithArray:arrayPrice];
            isCuisine = NO;
            isRate = YES;
            break;
        default:
            break;
    }
    [_tableViewPrice reloadData];
    
}
- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49.0f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                NSLog(@"view.frame.size.height-49.f: %f", view.frame.size.height);
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height-49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
    }];
}
- (void)hideTabBar:(UITabBarController *)tabbarcontroller
{
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width, view.frame.size.height)];
            }
            else {
                NSLog(@"view.frame.size.height-49.f: %f", view.frame.size.height);
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
    }];
    _scrollPriceView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    _cuisineImage.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
}
@end
