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

@interface RestaurantVC ()
{
    int TFSelected;
    BOOL filterExtendsShown;
    TSGlobalObj *restaurant, *region;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    _storeOldValue = [self getLinkRequest];
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

- (void) initUI
{
    
    [self actionHide:nil];
   
    scrollViewMain.delegate = self;
    
    viewFilterExtends.hidden = YES;
    
    rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(20, 220, 150, 30)];
    [viewFilterExtends addSubview:rateCustom];
    rateCustom.delegate = self;
    rateCustom.allowedRate = YES;
    
    
    for (int i= 0; i< [[[CommonHelpers appDelegate] arrPrice] count]; i++) {
        
        TSGlobalObj* price = [[[CommonHelpers appDelegate ] arrPrice ] objectAtIndex:i];
        if (i < 5)
            [segCtrPrice setTitle:price.name forSegmentAtIndex:i];
        else
            [segCtrPrice insertSegmentWithTitle:price.name atIndex:i animated:NO];
        
        
    }
    
    for (int i = 0; i< [[[CommonHelpers appDelegate] arrCuisine] count]; i++){
        TSGlobalObj* cuisine = [[[CommonHelpers appDelegate] arrCuisine] objectAtIndex:i];
        if (i < 5)
            [segCtrCuisine setTitle:cuisine.name forSegmentAtIndex:i];
        else
            [segCtrCuisine insertSegmentWithTitle:cuisine.name atIndex:i animated:NO];
    }
    [self resizeSegmentsToFitTitles:segCtrCuisine];
    
    
    
    [segCtrCuisine addTarget:self action:@selector(actionSegmentControl:) forControlEvents:UIControlEventValueChanged];
    
    
    [self fixSegmentedControlForiOS7:segCtrCuisine];
    [segCtrPrice addTarget:self action:@selector(actionSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self fixSegmentedControlForiOS7:segCtrPrice];
    
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    [textAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [segCtrCuisine setTintColor:SEGNMENT_COLOR];
    [segCtrCuisine setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [segCtrPrice setTintColor:SEGNMENT_COLOR];
    [segCtrPrice setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    segCtrCuisine.selectedSegmentIndex = -1;
    segCtrPrice.selectedSegmentIndex = -1;

    [self resizeSegmentsToFitTitles:segCtrPrice];
    if ([CommonHelpers isiOS6]) {
//        NSDictionary *underlinerAtt =@{NSUnderlineStyleAttributeName : @1};
        lbCusine.attributedText = [[NSAttributedString alloc] initWithString:@"Cuisine"];
        lbPrice.attributedText = [[NSAttributedString alloc] initWithString:@"Price"];
        lbRating.attributedText = [[NSAttributedString alloc] initWithString:@"Rating"];
        lbShowOnlyThese.attributedText = [[NSAttributedString alloc] initWithString:@"Show only these"];
    }
    
    [self refreshView];
    
//    if ([CommonHelpers isPhone5]) {
//        tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, 270);
//    }
//    else
//    {
//        tbvResult.frame = CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, 180);
//    }
    
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
        if (isRestaurantRequest == NO) {
            
            _restaurantSearch = NO;
            lbTypingRestaurant.hidden = NO;
            tfRestaurant.text = @"";
            
            _arrData = [[NSMutableArray alloc] initWithArray:[CommonHelpers appDelegate].arrayRestaurant];
            numberPage = [CommonHelpers appDelegate].numberPage;
            isRestaurantRequest = YES;
            [tbvResult reloadData];
        }
        
        
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
    [self hideKeyBoard];
    filterExtendsShown = TRUE;
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,-50,viewMain.frame.size.width, viewMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         
                     }];
    [self refreshView];
}

- (IBAction)actionDoneFilter:(id)sender
{
    filterExtendsShown = FALSE;
    _restaurantSearch = NO;
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,0,viewMain.frame.size.width, viewMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         
                     }];
    
    
    [self refreshView];
    
    NSString* linkRequest = [self getLinkRequest];
    if (![linkRequest isEqualToString:_storeOldValue]) {
        _storeOldValue = linkRequest;
        currentPage = 1;
        [_arrData removeAllObjects];
        [tbvResult reloadData];
        [self requestRestaurant];
    }
    
    [arrayDictionary addObject:[self getDictionary]];
    
}

-(NSString*)getLinkRequest
{
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray* arrayDataCuisine = [[NSMutableArray alloc]init];
    NSMutableArray* arrayDataPrice = [[NSMutableArray alloc]init];
    
    int price = 0;
    int cuisine = 0;
    
    NSString* listCuisine, *listPrice;
    listCuisine = @"";
    listPrice = @"";
    
    for (TSGlobalObj* global in arrDataStickFilter) {
        if (global.type == GlobalDataCuisine_1) {
            if (cuisine == 0) {
                listCuisine = global.uid;
                cuisine++;
            }
            else
                listCuisine = [listCuisine stringByAppendingString:[NSString stringWithFormat:@",%@",global.uid]];
            [arrayDataCuisine addObject:global.uid];
        }
        if (global.type == GlobalDataPrice) {
            if (price == 0) {
                listPrice = global.uid;
                price++;
            }
            else
                listPrice = [listPrice stringByAppendingString:[NSString stringWithFormat:@",%@",global.uid]];
            [arrayDataPrice addObject:global.uid];
        }
    }
    
    NSString* rate;
    
    if (_rating == 0) {
        rate = @"0";
    }
    else
        rate = [NSString stringWithFormat:@"%d",_rating];
    
    [dictionary setObject:rate forKey:@"rate"];
    
    NSString* save = @"0";
    
    if (saved) {
        save = @"1";
    }
    
    [dictionary setObject:save forKey:@"save"];
    
    NSString* fav = @"0";
    if (favs) {
        fav = @"1";
    }
    
    [dictionary setObject:fav forKey:@"fav"];
    
    NSString* _deal = @"0";
    if (deals) {
        _deal = @"1";
    }
    
    [dictionary setObject:_deal forKey:@"deal"];
    
    NSString* _chain = @"0";
    if (restaurantChains) {
        _chain = @"1";
    }
    
    [dictionary setObject:_chain forKey:@"chain"];
    
    NSString* neighborhoodid = @"";
    if(![[NSString stringWithFormat:@"%@",region.uid] isEqualToString:[NSString stringWithFormat:@"%@",region.cityObj.uid]])
    {
        neighborhoodid = region.uid;
    }
    [dictionary setObject:arrayDataCuisine forKey:@"cuisine"];
    [dictionary setObject:arrayDataPrice forKey:@"price"];
    
    NSString* page = [NSString stringWithFormat:@"%d",currentPage];
    
    NSString* link = [NSString stringWithFormat:@"recosrestaurantsearchresults?userid=%@&restaurantid=%@&neighborhoodid=%@&cityid=%@&statename=%@&cuisineidtier1idlist=%@&priceidlist=%@&rating=%@&savedflag=%@&favflag=%@&dealflag=%@&chainflag=%@&paginationid=%@",[UserDefault userDefault].userID,@"",neighborhoodid,_cityObj.uid,_cityObj.stateName,listCuisine,listPrice,rate,save,fav,_deal,_chain,page];
    return link;
}

-(NSMutableDictionary*)getDictionary
{
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray* arrayDataCuisine = [[NSMutableArray alloc]init];
    NSMutableArray* arrayDataPrice = [[NSMutableArray alloc]init];
    
    int price = 0;
    int cuisine = 0;
    
    NSString* listCuisine, *listPrice;
    listCuisine = @"";
    listPrice = @"";
    
    for (TSGlobalObj* global in arrDataStickFilter) {
        if (global.type == GlobalDataCuisine_1) {
            if (cuisine == 0) {
                listCuisine = global.uid;
                cuisine++;
            }
            else
                listCuisine = [listCuisine stringByAppendingString:[NSString stringWithFormat:@",%@",global.uid]];
            [arrayDataCuisine addObject:global.uid];
        }
        if (global.type == GlobalDataPrice) {
            if (price == 0) {
                listPrice = global.uid;
                price++;
            }
            else
                listPrice = [listPrice stringByAppendingString:[NSString stringWithFormat:@",%@",global.uid]];
            [arrayDataPrice addObject:global.uid];
        }
    }
    
    NSString* rate;
    
    if (_rating == 0) {
        rate = @"0";
    }
    else
        rate = [NSString stringWithFormat:@"%d",_rating];
    
    [dictionary setObject:rate forKey:@"rate"];
    
    NSString* save = @"0";
    
    if (saved) {
        save = @"1";
    }
    
    [dictionary setObject:save forKey:@"save"];
    
    NSString* fav = @"0";
    if (favs) {
        fav = @"1";
    }
    
    [dictionary setObject:fav forKey:@"fav"];
    
    NSString* _deal = @"0";
    if (deals) {
        _deal = @"1";
    }
    
    [dictionary setObject:_deal forKey:@"deal"];
    
    NSString* _chain = @"0";
    if (restaurantChains) {
        _chain = @"1";
    }
    
    [dictionary setObject:_chain forKey:@"chain"];
    
    NSString* neighborhoodid = @"";
    if(![[NSString stringWithFormat:@"%@",region.uid] isEqualToString:[NSString stringWithFormat:@"%@",region.cityObj.uid]])
    {
        neighborhoodid = region.uid;
    }
    
    [dictionary setObject:arrayDataCuisine forKey:@"cuisine"];
    [dictionary setObject:arrayDataPrice forKey:@"price"];
    return dictionary;
}

-(void)requestRestaurant
{
    
    tfRegion.text = @"";
    tfRestaurant.text = @"";
    lbTypeRegions.hidden = NO;
    lbTypingRestaurant.hidden = NO;
    
    
    CRequest* request = [[CRequest alloc]initWithURL:[self getLinkRequest] RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
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
        viewFilterSmall.hidden = YES;
        [scrollViewMain setContentSize:CGSizeMake(320, 360)];
        [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, 450, tbvResult.frame.size.width, 180)];
    }
    else
    {
        viewFilterExtends.hidden = YES;
        viewFilterSmall.hidden = NO;
        [scrollViewMain setContentSize:CGSizeMake(320, 730)];
        [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, 110, tbvResult.frame.size.width, 520)];
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
    if (segCtrl == segCtrCuisine)
        [scrollViewCuisine setContentSize:CGSizeMake(segCtrCuisine.frame.size.width + 40, 30)];
    else
        [scrollViewPrice setContentSize:CGSizeMake(total + 5, 30)];
}

#pragma mark - IBAction Define

- (IBAction)actionSaved:(id)sender
{
    if (saved) {
        saved = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved.png"] forButton:btSaved];
        lbSaved.text = @"Save";
    }
    else
    {
        saved = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btSaved];
        lbSaved.text = @"Saved";
        
    }
}
- (IBAction)actionFavs:(id)sender
{
    if (favs) {
        favs = NO;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addtomyfaves.png"] forButton:btFavs];
        lbFaved.text = @"Add to Fav";
        
    }
    else
    {
        favs = YES;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addedtomyfaves.png"] forButton:btFavs];
        lbFaved.text = @"Added to Fav";
        
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
    
    
    TSGlobalObj *strObj;
    

    
    if (segCtr == segCtrCuisine) {
        strObj = [[[CommonHelpers appDelegate] arrCuisine] objectAtIndex:segCtr.selectedSegmentIndex];
    }
    else
        if (segCtr == segCtrPrice) {
        strObj =[[[CommonHelpers appDelegate] arrPrice] objectAtIndex:segCtr.selectedSegmentIndex];
        }
        else
        {
        
        }

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
        if (_arrDataFilter) {
            return _arrDataFilter.count;
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
                NSLog(@"cell is nil");
                cell =(LoadDataCell *) [[[NSBundle mainBundle ] loadNibNamed:@"LoadDataCell" owner:self options:nil] objectAtIndex:0];
            }
            return cell;
        }
        static NSString *CellIndentifier = @"RestaurantCell";
        
        RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(RestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantCell" owner:self options:nil] objectAtIndex:0];
        }
        
        TSGlobalObj* obj = [_arrData objectAtIndex:indexPath.row];
        cell.isJustName = _restaurantSearch;
        [cell initForView:obj.restaurantObj];
//        cell.delegate =self;
        return cell;
    }
    else
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvResult) {
        if (indexPath.row == _arrData.count) {
            static NSString *CellIndentifier = @"LoadDataCell";
            
            LoadDataCell *cell = (LoadDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            
            if (cell==nil) {
                NSLog(@"cell is nil");
                cell =(LoadDataCell *) [[[NSBundle mainBundle ] loadNibNamed:@"LoadDataCell" owner:self options:nil] objectAtIndex:0];
            }
            return cell.frame.size.height;
        }
        static NSString *CellIndentifier = @"RestaurantCell";
        
        RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell = (RestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantCell" owner:self options:nil] objectAtIndex:0];
        }
        TSGlobalObj *obj = [_arrData objectAtIndex:indexPath.row];
        cell.isJustName = _restaurantSearch;
        return [cell getHeight:obj.restaurantObj];
    }
    else
    {
        static NSString *CellIndentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
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
            tfRestaurant.text = obj.name;
            lbTypingRestaurant.hidden = YES;
            restaurant = obj;
            [tbvResult reloadData];
            [arrayResID addObject:obj.uid];
        }
        else if (TFSelected == TFRegion)
        {
            TSGlobalObj* gloabal =  [_arrDataFilter objectAtIndex:indexPath.row];
            tfRegion.text = gloabal.name;
            lbTypeRegions.hidden = YES;
            region = gloabal;
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
    else
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
        region = nil;
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
    [self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return YES;
    
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
        if (txt.length >= 1) {
            [tbvFilter setFrame:CGRectMake(20, tbvFilter.frame.origin.y, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
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
        
        if (txt.length >= 1) {
            [tbvFilter setFrame:CGRectMake(160, tbvFilter.frame.origin.y, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
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
//    else
//    {
//        tfRestaurant.text = restaurant.name;
//    }
//    
    if (region == nil) {
        lbTypeRegions.hidden = NO;
        tfRegion.text = nil;

    }
//    else
//    {
//        tfRegion.text = region.name;
//    }
}

#pragma mark - UISCrollViewDelegate


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollViewMain) {
        
        //debug(@"scrollViewMain ->scrollViewDidEndDragging");
    }
    else if(scrollView == tbvResult)
    {
        if(scrollView.contentOffset.y == scrollView.contentSize.height - tbvResult.frame.size.height)
        {
            currentPage++;
            
            if (currentPage <= numberPage) {
                if (_notHomeScreen == NO) {
                    [self requestRestaurant];
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
        _arrData = [[NSMutableArray alloc]initWithArray:_arrDataRestaurant];
        if (self.arrDataFilter.count>0) {
            CGRect frame = tbvFilter.frame;
            if (self.arrDataFilter.count > 5) {
                frame.size.height = 5*44;
                
            }
            else{
                frame.size.height = (_arrDataFilter.count) *44;
            }
            tbvFilter.hidden = NO;
            [tbvFilter reloadData];
            [tbvResult reloadData];
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
            CGRect frame = tbvFilter.frame;
            if (self.arrDataFilter.count > 5) {
                frame.size.height = 5*44;
                
            }
            else{
                frame.size.height = (_arrDataFilter.count) *44;
            }
            tbvFilter.hidden = NO;
            [tbvFilter reloadData];
            [tbvResult reloadData];
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
        //_arrData = _arrDataRestaurant;
        [tbvResult reloadData];
        
        
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
        
        numberPage = [CommonHelpers appDelegate].numberPage;
        _arrData = [[NSMutableArray alloc]initWithArray:[CommonHelpers appDelegate].arrayRestaurant];
        [tbvResult reloadData];
    }
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


@end
