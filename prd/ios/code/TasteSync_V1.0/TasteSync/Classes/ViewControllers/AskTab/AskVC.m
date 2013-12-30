//
//  AskVC.m
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "AskVC.h"
#import "CommonHelpers.h"
#import "AskRecommendationsVC.h"
#import "AskObject.h"
#import "AskCell.h"
#import "TSGlobalObj.h"
#import "TSCityObj.h"
#import "SendMessageVC.h"
#import "AskContactCell.h"
#import "GlobalNotification.h"
#import "Reachability.h"
#import "Flurry.h"

@interface AskVC ()
{
    NSMutableArray *arrDataAsk;
    NSMutableArray *arrayCuisine;
    NSMutableArray *arrayAmbience;
    NSMutableArray *arrayWhoWithYou;
    NSMutableArray *arrayPrice;
    NSMutableArray *arrayCity;
    TSGlobalObj *region;
    NSString* cityLocal;
    BOOL isCuisine;
    BOOL isLoad;
    
    IBOutlet UITableView* _tableView;
    IBOutlet UITableView* _tableViewCuisine;
    IBOutlet UIView* _elementView;
    IBOutlet UIView* _cuisineView;
    IBOutlet UIView* _buttonView;
    IBOutlet UITextField* _textFieldSearch;
    
    IBOutlet UIImageView* cuisineDataImage, *neighberhoodImage, *ambienceImage, *priceImage, *whoareyouImage;
    IBOutlet UIImageView* line1, *line2, *line3, *line4;
    IBOutlet UIButton* cuisineButton, *neighberhoodButton, *ambienceButton, *priceButton, *whoareyouButton, *getRecomentdation;
    IBOutlet UILabel* cuisineLabel, *neighberhoodLabel, *ambienceLabel, *priceLabel, *whoareyouLabel;
    
    
    int number_cuisine, number_neighborhood, number_ambience, number_whoareyou, number_price, number_recomendation;
    AskObject* askNeiberhood;
}

@end

@implementation AskVC

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
    [self.navigationController setNavigationBarHidden:YES];

    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
    region = [CommonHelpers getDefaultCityObj];
    isLoad = NO;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [arrDataAsk removeAllObjects];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    number_cuisine = 0;
    number_neighborhood = 0;
    number_ambience = 0;
    number_whoareyou = 0;
    number_price = 0;
    number_recomendation = 0;
    
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",number_cuisine]       , @"Cuisine",
     [NSString stringWithFormat:@"%d",number_neighborhood]  , @"Neighberhood",
     [NSString stringWithFormat:@"%d",number_ambience]      , @"Ambience",
     [NSString stringWithFormat:@"%d",number_whoareyou]     , @"WhoAreYou",
     [NSString stringWithFormat:@"%d",number_price]         , @"Price",
     [NSString stringWithFormat:@"%d",number_recomendation] , @"GetRecomendation",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Home" isBegin:YES];
    
    if (isLoad == NO && [CommonHelpers appDelegate].isHaveError == NO) {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [CommonHelpers showInfoAlertConnectInternet];
        }
        else
        {
            GlobalNotification *globalNotification = [[GlobalNotification alloc] initWithALlType];
            [globalNotification requestData:self.view];
            [globalNotification requestRestaurantData:self.view];
        }
        isLoad = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%d %d %d %d %d - %d", number_ambience, number_cuisine, number_neighborhood, number_whoareyou, number_price, number_recomendation);
    
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%d",number_cuisine]       , @"Cuisine",
     [NSString stringWithFormat:@"%d",number_neighborhood]  , @"Neighberhood",
     [NSString stringWithFormat:@"%d",number_ambience]      , @"Ambience",
     [NSString stringWithFormat:@"%d",number_whoareyou]     , @"WhoAreYou",
     [NSString stringWithFormat:@"%d",number_price]         , @"Price",
     [NSString stringWithFormat:@"%d",number_recomendation] , @"GetRecomendation",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Home" isBegin:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private's function

- (void) initUI
{
    [CommonHelpers setBackgroudImageForView:self.view];
    _cuisineSelectImage.hidden = YES;
    neighborhoodSelectImage.hidden = YES;
    _ambienceSelectImage.hidden = YES;
    _whoareyouSelectImage.hidden = YES;
    _priceSelectImage.hidden = YES;
    
    arrDataAsk = [[NSMutableArray alloc] init];
    _arrDataFilter = [[NSMutableArray alloc]init];
    arrayCuisine = [[NSMutableArray alloc]init];
    arrayAmbience = [[NSMutableArray alloc]init];
    arrayWhoWithYou = [[NSMutableArray alloc]init];
    arrayPrice = [[NSMutableArray alloc]init];
    arrayCity = [[NSMutableArray alloc]init];
    
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
    //[self sortArray:arrayCuisine];
    [arrayAmbience removeAllObjects];
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrayAmbience) {
        AskObject* obj = [[AskObject alloc]init];
        obj.selected = NO;
        obj.object = global;
        [arrayAmbience addObject:obj];
    }
    
//    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrTheme) {
//        AskObject* obj = [[AskObject alloc]init];
//        obj.selected = NO;
//        obj.object = global;
//        [arrayAmbience addObject:obj];
//    }
//    
//    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrTypeOfRestaurant) {
//        AskObject* obj = [[AskObject alloc]init];
//        obj.selected = NO;
//        obj.object = global;
//        [arrayAmbience addObject:obj];
//    }
    
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
    
    [self getCityData];
    
    _elementView.frame = CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    [self.view addSubview:_elementView];
    _elementView.hidden = YES;
    
    _cuisineView.frame = CGRectMake(0, 44, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    [self.view addSubview:_cuisineView];
    _cuisineView.hidden = YES;
    [self configUI];
}

-(void)getCityData
{
    arrayCity = [[NSMutableArray alloc]initWithArray:[CommonHelpers appDelegate].arrayNeighberhood];
    //[self sortArray:arrayCity];
}

-(void)configUI
{
    
    if([CommonHelpers isPhone5])
    {
        cuisineLabel.frame = CGRectMake(cuisineLabel.frame.origin.x, 225-28, cuisineLabel.frame.size.width, cuisineLabel.frame.size.height);
        cuisineDataImage.frame = CGRectMake(0, 0, 159, 225);
        cuisineButton.frame = CGRectMake(0, 0, 159, 225);
        
        neighberhoodLabel.frame = CGRectMake(neighberhoodLabel.frame.origin.x, 226+105-28, neighberhoodLabel.frame.size.width, neighberhoodLabel.frame.size.height);
        neighberhoodImage.frame = CGRectMake(0, 226, 159, 105);
        neighborhoodSelectImage.frame = CGRectMake(neighborhoodSelectImage.frame.origin.x, neighborhoodSelectImage.frame.origin.y + 20, neighborhoodSelectImage.frame.size.width, neighborhoodSelectImage.frame.size.height);
        neighberhoodButton.frame = CGRectMake(0, 226, 159, 105);
        
        _buttonView.frame = CGRectMake(46,355,229,41);
        
        whoareyouLabel.frame = CGRectMake(whoareyouLabel.frame.origin.x, 113+112-28, whoareyouLabel.frame.size.width, whoareyouLabel.frame.size.height);
        whoareyouImage.frame = CGRectMake(161, 113, 159, 112);
        _whoareyouSelectImage.frame = CGRectMake(_whoareyouSelectImage.frame.origin.x, _whoareyouSelectImage.frame.origin.y + 10, _whoareyouSelectImage.frame.size.width, _whoareyouSelectImage.frame.size.height);
        whoareyouButton.frame = CGRectMake(161, 113, 159, 112);
        
        priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, 226+105-28, priceLabel.frame.size.width, priceLabel.frame.size.height);
        priceImage.frame = CGRectMake(161, 226, 159, 105);
        _priceSelectImage.frame = CGRectMake(_priceSelectImage.frame.origin.x, _priceSelectImage.frame.origin.y + 21, _priceSelectImage.frame.size.width, _priceSelectImage.frame.size.height);
        priceButton.frame = CGRectMake(161, 226, 159, 105);
        
        ambienceLabel.frame = CGRectMake(ambienceLabel.frame.origin.x, 112-28, ambienceLabel.frame.size.width, ambienceLabel.frame.size.height);
        ambienceImage.frame = CGRectMake(161, 0, 159, 112);
        ambienceButton.frame = CGRectMake(161, 0, 159, 112);
        
        line1.frame = CGRectMake(159,0,2,331);
        line2.frame = CGRectMake(161,112,159,1);
        line3.frame = CGRectMake(0,225,320,1);
        line4.frame = CGRectMake(0,331,320,1);
    }
    
    NSString *fileName1 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/cuisine_tile.png"]];
    _cuisineImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName1] withSize:CGSizeMake(_cuisineImage.frame.size.width, _cuisineImage.frame.size.height)];
    cuisineDataImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName1] withSize:CGSizeMake(cuisineDataImage.frame.size.width, cuisineDataImage.frame.size.height)];
    
    NSString *fileName2 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/nbrhood_tile.png"]];
    neighberhoodImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName2] withSize:CGSizeMake(neighberhoodImage.frame.size.width, neighberhoodImage.frame.size.height)];
    
    NSString *fileName3 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/ambience_tile.png"]];
    ambienceImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName3] withSize:CGSizeMake(ambienceImage.frame.size.width, ambienceImage.frame.size.height)];
    
    NSString *fileName4 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/whoswithyou_tile.png"]];
    whoareyouImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName4] withSize:CGSizeMake(whoareyouImage.frame.size.width, whoareyouImage.frame.size.height)];
    
    NSString *fileName5 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/price_tile.png"]];
    priceImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName5] withSize:CGSizeMake(priceImage.frame.size.width, priceImage.frame.size.height)];
    
}

- (void) initData
{
    self.arrData = [[NSMutableArray alloc] initWithArray:[[CommonHelpers appDelegate] arrCuisine]];
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrDropdown]) {
        int i = 0;
        for (TSGlobalObj* global2 in [[CommonHelpers appDelegate] arrCuisine])
        {
            NSString* str1 = [NSString stringWithFormat:@"%@", global.name];
            NSString* str2 = [NSString stringWithFormat:@"%@", global2.name];
            if ([str1 isEqualToString:str2]) {
                break;
            }
            i++;
        }
        if (i == [[CommonHelpers appDelegate] arrCuisine].count) {
            [self.arrData addObject:global];
        }
    }
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrOccasion]) {
        [self.arrData addObject:global];
    }
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrPrice]) {
        [self.arrData addObject:global];
    }
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrTheme]) {
        [self.arrData addObject:global];
    }
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrTypeOfRestaurant]) {
        [self.arrData addObject:global];
    }
    
    for (TSGlobalObj* global in [[CommonHelpers appDelegate] arrWhoAreUWith]) {
        [self.arrData addObject:global];
    }
    
    self.arrDataRegion = [[NSMutableArray alloc] init];
    self.arrDataFilter = [[NSMutableArray alloc] init];
    
    
}





- (IBAction)actionGetLiveRecommendations:(id)sender
{
    [CommonHelpers appDelegate].askSubmited = YES;
    if (/*[UserDefault userDefault].loginStatus == NotLogin*/ FALSE) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        NSString* cuisineList1 = @"";
        NSString* cuisineList2 = @"";
        NSString* priceList = @"";
        NSString* themeList = @"";
        NSString* whoareyouList = @"";
        NSString* typeofrestaurantList = @"";
        NSString* occasionList = @"";
        
        CRequest* request = [[CRequest alloc]initWithURL:@"recosearch" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:2 WithView:self.view];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        
        for (TSGlobalObj* global in arrDataAsk) {
            if (global.type == GlobalDataCuisine_1 ) {
                if (cuisineList1.length == 0) {
                    cuisineList1 = global.uid;
                }
                else
                    cuisineList1 = [cuisineList1 stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataCuisine_2 ) {
                if (cuisineList2.length == 0) {
                    cuisineList2 = global.uid;
                }
                else
                    cuisineList2 = [cuisineList2 stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataOccasion ) {
                if (occasionList.length == 0) {
                    occasionList = global.uid;
                }
                else
                    occasionList = [occasionList stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataPrice ) {
                if (priceList.length == 0) {
                    priceList = global.uid;
                }
                else
                    priceList = [priceList stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataTheme ) {
                if (themeList.length == 0) {
                    themeList = global.uid;
                }
                else
                    themeList = [themeList stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataTypeOfRestaurant ) {
                if (typeofrestaurantList.length == 0) {
                    typeofrestaurantList = global.uid;
                }
                else
                    typeofrestaurantList = [typeofrestaurantList stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataWhoAreUWith ) {
                if (whoareyouList.length == 0) {
                    whoareyouList = global.uid;
                }
                else
                    whoareyouList = [whoareyouList stringByAppendingFormat:@",%@", global.uid];
            }
            if (global.type == GlobalDataCity) {
                region = global;
            }
            NSLog(@"%@ - %d - %@", global.name, global.type, global.uid);
        }
        [request setFormPostValue:cuisineList1              forKey:@"cuisinetier1idlist"];
        [request setFormPostValue:cuisineList2              forKey:@"cuisineiier2idlist"];
        [request setFormPostValue:priceList                    forKey:@"priceidlist"];
        [request setFormPostValue:themeList                  forKey:@"themeidlist"];
        [request setFormPostValue:whoareyouList          forKey:@"whoareyouwithidlist"];
        [request setFormPostValue:typeofrestaurantList forKey:@"typeofrestaurantidList"];
        [request setFormPostValue:occasionList             forKey:@"occasionidlist"];
        NSLog(@"%@ - %@ - %@", region.cityObj.neighbourhoodID, region.cityObj.uid, region.cityObj.stateName);
//        [request setFormPostValue:@"neighborhoodid" forKey:@"neighborhoodid"];
//        [request setFormPostValue:@"typeofrestaurantidList" forKey:@"cityid"];
//        [request setFormPostValue:@"occasionidlist" forKey:@"statename"];
        
//        if (region.cityObj == nil) {
            [request setFormPostValue:region.cityObj.neighbourhoodID forKey:@"neighborhoodid"];
            [request setFormPostValue:region.cityObj.uid forKey:@"cityid"];
            [request setFormPostValue:region.cityObj.stateName forKey:@"statename"];
        
        
//        }//[self parseStateFromCityObj:region.name]
//        else
//        {
//            [request setFormPostValue:region.uid forKey:@"neighborhoodid"];
//            [request setFormPostValue:region.cityObj.uid forKey:@"cityid"];
//            [request setFormPostValue:region.cityObj.stateName forKey:@"statename"];
//        }
        request.delegate = self;
        [request startFormRequest];
        NSLog(@"%@ - %@ - %@", region.cityObj.neighbourhoodID, region.cityObj.uid, region.cityObj.stateName);
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
        _cuisineSelectImage.hidden = YES;
        neighborhoodSelectImage.hidden = YES;
        _ambienceSelectImage.hidden = YES;
        _whoareyouSelectImage.hidden = YES;
        _priceSelectImage.hidden = YES;
        region = [CommonHelpers getDefaultCityObj];
    }

}

#pragma mark - UITableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    return _arrDataFilter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString *CellIndentifier = @"AskCell";
        
        AskCell *cell = (AskCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(AskCell *) [[[NSBundle mainBundle ] loadNibNamed:CellIndentifier owner:self options:nil] objectAtIndex:0];
        }
        AskObject* obj = [_arrDataFilter objectAtIndex:indexPath.row];
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
        AskObject* obj = [_arrDataFilter objectAtIndex:indexPath.row];
        if (obj.selected) {
            [cell.buttonright setImage:[CommonHelpers getImageFromName:@"Tick mark icon.png"] forState:UIControlStateHighlighted];
            [cell.buttonright setImage:[CommonHelpers getImageFromName:@"Tick mark icon.png"] forState:UIControlStateNormal];
        }
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        cell.name.text = obj.object.name;
        cell.name.textColor = [UIColor whiteColor];
        //cell.name.font = [UIFont systemFontOfSize:14];
        cell.name.frame = CGRectMake(cell.name.frame.origin.x, cell.name.frame.origin.y, cell.name.frame.size.width + 20, cell.name.frame.size.height);
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        static NSString *CellIndentifier = @"AskCell";
        AskCell *cell = (AskCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            NSLog(@"cell is nil");
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
    if (tableView == _tableView) {
        AskObject* obj = [_arrDataFilter objectAtIndex:indexPath.row];
        obj.selected = !obj.selected;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        if (isCuisine) {
            AskObject* obj = [_arrDataFilter objectAtIndex:indexPath.row];
            obj.selected = !obj.selected;
            [_tableViewCuisine reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            AskObject* obj = [_arrDataFilter objectAtIndex:indexPath.row];
            if (obj.selected == YES) {
                obj.selected = NO;
                askNeiberhood = nil;
            }
            else
            {
                obj.selected = YES;
                if (askNeiberhood != nil) {
                    askNeiberhood.selected = NO;
                }
                askNeiberhood = obj;
            }
            
            [_tableViewCuisine reloadData];
        }
    }
}


-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    if (key == 2) {
        number_recomendation = 1;
        NSDictionary* dic = [response objectFromJSONString];
        AskRecommendationsVC *vc = [[AskRecommendationsVC alloc] initWithArrayData:arrDataAsk atLocation:region Reco_RequestID:[dic objectForKey:@"valueNameValue"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSString*)parseStateFromCityObj:(NSString*)name
{
    NSArray* data= [name componentsSeparatedByString:@", "];
    return [data objectAtIndex:1];
}
#pragma mark Action
-(IBAction)doneAction:(id)sender
{
    [self showTabBar:self.tabBarController];
    [_textFieldSearch resignFirstResponder];
    UIButton* button = (UIButton*)sender;
    _elementView.hidden = YES;
    _cuisineView.hidden = YES;
    if (button.tag == 0) {
        
        _ambienceSelectImage.hidden = YES;
        for (AskObject* obj in arrayAmbience) {
            if (obj.selected == YES && ![arrDataAsk containsObject:obj.object]) {
                [arrDataAsk addObject:obj.object];
                _ambienceSelectImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataAsk removeObject:obj.object];
            }
            else
            {
                _ambienceSelectImage.hidden = NO;
            }
        }
        
        _priceSelectImage.hidden = YES;
        for (AskObject* obj in arrayPrice) {
            if (obj.selected == YES && ![arrDataAsk containsObject:obj.object]) {
                [arrDataAsk addObject:obj.object];
                _priceSelectImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataAsk removeObject:obj.object];
            }
            else
            {
                _priceSelectImage.hidden = NO;
            }
        }
        
        _whoareyouSelectImage.hidden = YES;
        for (AskObject* obj in arrayWhoWithYou) {
            if (obj.selected == YES && ![arrDataAsk containsObject:obj.object]) {
                [arrDataAsk addObject:obj.object];
                _whoareyouSelectImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataAsk removeObject:obj.object];
            }
            else
            {
                _whoareyouSelectImage.hidden = NO;
            }
        }
    }
    else
    {
        neighborhoodSelectImage.hidden = YES;
        for (AskObject* obj in arrayCity) {
            if (obj.selected == YES && ![arrDataAsk containsObject:obj.object]) {
                [arrDataAsk addObject:obj.object];
            }
            if (obj.selected == NO)
            {
                [arrDataAsk removeObject:obj.object];
            }
            else
            {
                neighborhoodSelectImage.hidden = NO;
            }
                
        }
        
        _cuisineSelectImage.hidden = YES;
        for (AskObject* obj in arrayCuisine) {
            if (obj.selected == YES && ![arrDataAsk containsObject:obj.object]) {
                [arrDataAsk addObject:obj.object];
                _cuisineSelectImage.hidden = NO;
            }
            if (obj.selected == NO)
            {
                [arrDataAsk removeObject:obj.object];
            }
            else
            {
                _cuisineSelectImage.hidden = NO;
            }
        }
    }
    
    [_arrDataFilter removeAllObjects];
    [_tableView reloadData];
    [_tableViewCuisine reloadData];
    
}
-(IBAction)showTypePopUpAction:(id)sender
{
    
    [self hideTabBar:self.tabBarController];
    [_arrDataFilter removeAllObjects];
    _elementView.hidden = NO;
    UIButton* button = (UIButton*)sender;
    switch (button.tag) {
        case 1:
            [self reloadAmbience];
            number_ambience++;
            break;
        case 2:
            [self reloadWhoWithYou];
            number_whoareyou++;
            break;
        case 3:
            [self reloadPrice];
            number_price++;
            break;
        default:
            break;
    }
}
- (void)showTabBar:(UITabBarController *)tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *view in tabbarcontroller.view.subviews) {
            if ([view isKindOfClass:[UITabBar class]]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
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
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+49.f, view.frame.size.width, view.frame.size.height)];
            }
            else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+49.f)];
            }
        }
    } completion:^(BOOL finished) {
        //do smth after animation finishes
        tabbarcontroller.tabBar.hidden = YES;
    }];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
    _cuisineImage.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 44);
}
-(IBAction)cuisinePress:(id)sender
{
    [self hideTabBar:self.tabBarController];
    [_arrDataFilter removeAllObjects];
    _textFieldSearch.placeholder = @"Search Cuisines";
    NSString *fileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/cuisine_popup_back.png"]];
    _cuisineImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName] withSize:CGSizeMake(_cuisineImage.frame.size.width, _cuisineImage.frame.size.height)];
    _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCuisine];
    [_tableViewCuisine reloadData];
    _cuisineView.hidden = NO;
    isCuisine = YES;
    
    number_cuisine++;
}
-(IBAction)showProfileAction:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}
-(IBAction)neiberhoodPress:(id)sender
{
    [self hideTabBar:self.tabBarController];
    [_arrDataFilter removeAllObjects];
    _textFieldSearch.placeholder = @"Search NYC Neighborhoods";
    NSString *fileName = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/nbrhood_popup_back.png"]];
    _cuisineImage.image = [CommonHelpers generateThumbnailFromImage:[UIImage imageWithContentsOfFile:fileName] withSize:CGSizeMake(_cuisineImage.frame.size.width, _cuisineImage.frame.size.height)];
    _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCity];
    [_tableViewCuisine reloadData];
    _cuisineView.hidden = NO;
    isCuisine = NO;
    
    number_neighborhood++;
}
-(void)reloadAmbience
{
    _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayAmbience];
    [_tableView reloadData];
}
-(void)reloadWhoWithYou
{
    _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayWhoWithYou];
    [_tableView reloadData];
}
-(void)reloadPrice
{
    _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayPrice];
    [_tableView reloadData];
}
-(void)sortArray:(NSMutableArray*)_arrayContact
{
    int n = [_arrayContact count];
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n;  j++) {
            AskObject* obj1 = [_arrayContact objectAtIndex:i];
            AskObject* obj2 = [_arrayContact objectAtIndex:j];
            if ([[NSString stringWithFormat:@"%@",obj1.object.name] compare:[NSString stringWithFormat:@"%@",obj2.object.name]] == NSOrderedDescending) {
                [_arrayContact removeObjectAtIndex:j];
                [_arrayContact insertObject:obj1 atIndex:j];
                [_arrayContact removeObjectAtIndex:i];
                [_arrayContact insertObject:obj2 atIndex:i];
            }
        }
    }
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (isCuisine)
        _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCuisine];
    else
        _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCity];
    [_tableViewCuisine reloadData];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [_arrDataFilter removeAllObjects];
    if ([searchText isEqualToString:@""]) {
        if (isCuisine)
            _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCuisine];
        else
            _arrDataFilter = [[NSMutableArray alloc]initWithArray:arrayCity];
        
    }
    else
    {
        if (isCuisine)
        {
            for (AskObject* obj in arrayCuisine) {
                if ([[[NSString stringWithFormat:@"%@",obj.object.name] uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound) {
                    [_arrDataFilter addObject:obj];
                }
            }
        }
        else
        {
            for (AskObject* obj in arrayCity) {
                if ([[[NSString stringWithFormat:@"%@",obj.object.name] uppercaseString] rangeOfString:[searchText uppercaseString]].location != NSNotFound) {
                    [_arrDataFilter addObject:obj];
                }
            }
        }
        
    }
    [_tableViewCuisine reloadData];
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}
@end
