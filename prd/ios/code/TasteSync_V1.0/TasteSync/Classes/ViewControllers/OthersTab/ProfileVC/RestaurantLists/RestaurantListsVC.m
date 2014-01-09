//
//  RestaurantListsVC.m
//  TasteSync
//
//  Created by Victor on 3/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RestaurantListsVC.h"
#import "CommonHelpers.h"

#define NUMBER_LOAD 3;

@interface RestaurantListsVC ()<UIActionSheetDelegate>
{
    BOOL filterViewShown;
    BOOL isRecommended, isFavs, isTips, isSaved;
    int _from, _to;
    NSMutableArray* _arrayData;
}

@end

@implementation RestaurantListsVC

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
    isRecommended = YES;
    isFavs = YES;
    isTips = YES;
    isSaved = YES;
    [CommonHelpers setBackgroudImageForView:self.view];
    [self initUI];
    self.arrDataRestaurant = [[NSMutableArray alloc]init];
    _arrayData = [[NSMutableArray alloc]init];
    _from = 0;
    _to = NUMBER_LOAD;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestData:RestaurantTypeNone from:_from to:_to];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    [scrollViewMain setContentSize:CGSizeMake(320, 500)];
    if ([CommonHelpers isPhone5]) {
        [tbvRestaurant setFrame:CGRectMake(10, 60, 300, 315)];
    }
    else
        [tbvRestaurant setFrame:CGRectMake(10, 60, 300, 228)];

    viewFilterExtends.hidden = YES;
    if (_userObj) {
        lbTitle.text = [NSString stringWithFormat:@"%@'s Restaurant List",_userObj.name];
    }
    else
    {
        lbTitle.text = @"You have been to";
    }
}

- (void)requestData:(RestaurantType)type from:(int)from to:(int)to
{
    CRequest* request = [[CRequest alloc]initWithURL:@"showProfileRestaurants" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:type WithView:self.view];
    request.delegate = self;
    NSLog(@"User ID: %@", self.userObj.uid);
    [request setFormPostValue:self.userObj.uid forKey:@"userId"];
    [request setFormPostValue:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    [request setFormPostValue:[NSString stringWithFormat:@"%d",from] forKey:@"from"];
    [request setFormPostValue:[NSString stringWithFormat:@"%d",to] forKey:@"to"];
    [request startFormRequest];
}

# pragma mark - IBAction's Define
- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
//    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:APP_NAME delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (IBAction)actionDoneFilter:(id)sender
{
    filterViewShown = FALSE;
    viewFilterExtends.hidden = YES;
    viewFilter.hidden = NO;
    //[tbvRestaurant setFrame:CGRectMake(10, 60, 300, 220)];
    [scrollViewMain setContentSize:CGSizeMake(320, 500)];
    [_arrDataRestaurant removeAllObjects];
    for (RestaurantObj* obj in _arrayData) {
        if ((obj.isFavs == isFavs && isFavs)|| (obj.isReco == isRecommended && isRecommended) || (obj.isSaved == isSaved && isSaved) || (obj.isTipFlag == isTips && isTips)) {
            [_arrDataRestaurant addObject:obj];
        }
    }
    [tbvRestaurant reloadData];
}

- (IBAction)actionFilter:(id)sender
{
    if (filterViewShown) {
        filterViewShown = NO;
        viewFilterExtends.hidden = YES;
        viewFilter.hidden = NO;
        //[tbvRestaurant setFrame:CGRectMake(10, 60, 300, 220)];
        [scrollViewMain setContentSize:CGSizeMake(320, 500)];

    
    }
    else
    {
        filterViewShown = YES;
        viewFilterExtends.hidden = NO;
        viewFilter.hidden = YES;
        //[tbvRestaurant setFrame:CGRectMake(10, 240, 300, 220)];
        [scrollViewMain setContentSize:CGSizeMake(320, 600)];

    }
}
- (IBAction)actionChooseFilter:(id)sender
{
    UIButton *bt = (UIButton *) sender;
    if (bt== btRecommended) {
        if (isRecommended) {
            isRecommended = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_recommended.png"] forButton:btRecommended];
        }
        else
        {
            isRecommended = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_recommended_on.png"] forButton:btRecommended];
        }
    }
    else  if (bt== btFavs) {
        if (isFavs) {
            isFavs = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_favs.png"] forButton:btFavs];
        }
        else
        {
            isFavs = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_favs_on.png"] forButton:btFavs];
        }
    } else  if (bt== btTips) {
        if (isTips) {
            isTips = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_tips.png"] forButton:btTips];
        }
        else
        {
            isTips = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_tips_on.png"] forButton:btTips];
        }
    } else  if (bt== btSaved) {
        if (isSaved) {
            isSaved = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saved125_off.png"] forButton:btSaved];
        }
        else
        {
            isSaved = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saved125_on.png"] forButton:btSaved];
        }
    }
    else
    {
        
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (_arrDataRestaurant) {
        return  _arrDataRestaurant.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvRestaurant) {
        static NSString *CellIndentifier = @"RestaurantProfileCell";
        
        RestaurantProfileCell *cell = (RestaurantProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(RestaurantProfileCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantProfileCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        [cell initForCell:[_arrDataRestaurant objectAtIndex:indexPath.row] Rec:isRecommended Sav:isSaved Tip:isTips Fav:isFavs];
        
        return cell;
    }
    return nil;
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvRestaurant) {
        static NSString *CellIndentifier = @"RestaurantProfileCell";
        
        RestaurantProfileCell *cell = (RestaurantProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(RestaurantProfileCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantProfileCell" owner:self options:nil] objectAtIndex:0];
        }
        
        return cell.frame.size.height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionSelectRestaurant:[_arrDataRestaurant objectAtIndex:indexPath.row] selectedIndex:3];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y == (tbvRestaurant.contentSize.height - tbvRestaurant.frame.size.height)) {
//        _to += NUMBER_LOAD;
//        [self requestData:RestaurantTypeNone from:_from to:_to];
//    }
    
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
        //[_arrayData removeAllObjects];
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            NSString* restaurantID = [NSString stringWithFormat:@"%@", [dic objectForKey:@"restauarntId"]];
            if ([self checkRestaurant:restaurantID]) {
                RestaurantObj* restaurantObj        = [[RestaurantObj alloc]init];
                restaurantObj.type                           = key;
                restaurantObj.uid                             =  [dic objectForKey:@"restauarntId"];
                restaurantObj.factualId                    = [dic objectForKey:@"factualId"];
                restaurantObj.name                         = [dic objectForKey:@"restaurantName"];
                restaurantObj.isOpenNow               =  [[dic objectForKey:@"openNowFlag"] isEqualToString:@"1"]?YES:NO;
                restaurantObj.deal                            =  [dic objectForKey:@"restaurantDealFlag"];
                if (![restaurantObj.deal isEqual:[NSNull null]]) {
                    if ([restaurantObj.deal isEqualToString:@""])
                        restaurantObj.isDeal = NO;
                    else
                        restaurantObj.isDeal = YES;
                }
                restaurantObj.isMoreInfo                  =  [[dic objectForKey:@"moreInfoFlag"]  isEqualToString:@"1"]?YES:NO;
                restaurantObj.isMenuFlag                =  [[dic objectForKey:@"menuFlag"] isEqualToString:@"1"]?YES:NO;
                restaurantObj.isSaved                      =  [[dic objectForKey:@"userSavedFlag"] isEqualToString:@"1"]?YES:NO;
                restaurantObj.isFavs                         =  [[dic objectForKey:@"userFavFlag"]  isEqualToString:@"1"]?YES:NO;
                restaurantObj.isTipFlag                     =  [[dic objectForKey:@"userTipFlag"]  isEqualToString:@"1"]?YES:NO;
                restaurantObj.isReco                        =  [[dic objectForKey:@"userRecommendedFlag"]  isEqualToString:@"1"]?YES:NO;
                restaurantObj.userFavFlag                   =  [[dic objectForKey:@"userFavFlag"] boolValue];
                restaurantObj.userSavedFlag                 =  [[dic objectForKey:@"userSavedFlag"] boolValue];
                restaurantObj.userRecommendedFlag           =  [[dic objectForKey:@"userRecommendedFlag"] boolValue];
                restaurantObj.userTipFlag                   =  [[dic objectForKey:@"userTipFlag"] boolValue];
                restaurantObj.rates = [[dic objectForKey:@"restaurantRating"] floatValue];
                restaurantObj.lattitude = [[dic objectForKey:@"restaurantLat"] floatValue];
                restaurantObj.longtitude = [[dic objectForKey:@"restaurantLong"] floatValue];
                restaurantObj.price = [dic objectForKey:@"price"];
                restaurantObj.cuisineTier2 = [dic objectForKey:@"cuisineTier2Name"];
                
                TSCityObj* cityObj = [[TSCityObj alloc]init];
                NSDictionary* dicCity = [dic objectForKey:@"restaurantCity"];
                cityObj.uid = [dicCity objectForKey:@"cityId"];
                cityObj.country = [dicCity objectForKey:@"country"];
                cityObj.stateName = [dicCity objectForKey:@"state"];
                cityObj.cityName = [dicCity objectForKey:@"city"];
                restaurantObj.cityObj = cityObj;
                
                [_arrayData addObject:restaurantObj];
            }
    }
    _arrDataRestaurant = [[NSMutableArray alloc]initWithArray:_arrayData];
    [tbvRestaurant reloadData];
}
- (BOOL)checkRestaurant:(NSString*)str
{
    for (RestaurantObj* obj in _arrDataRestaurant) {
        NSString* str1 = [NSString stringWithFormat:@"%@", obj.uid];
        if ([str1 isEqualToString:str]) {
            return NO;
        }
    }
    return YES;
}
- (void) removeType:(RestaurantType)type
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (RestaurantObj* obj in _arrDataRestaurant) {
        if (obj.type == type) {
            [array addObject:obj];
        }
    }
    for (int i = 0; i < [array count]; i++) {
        [_arrDataRestaurant removeObject:[array objectAtIndex:i]];
    }
    
    [tbvRestaurant reloadData];
}
@end
