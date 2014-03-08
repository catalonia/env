//
//  ResRecommendVC.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResRecommendVC.h"
#import "ResRecommendDetailVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "RateCustom.h"

@interface ResRecommendVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbvRecommend;
    __weak IBOutlet UIButton *btAsk;
    __weak IBOutlet UIView *inforView;
    __weak IBOutlet UILabel *lbName, *lbDetail;
    int numberBuzzRecoList, numberBuzzTipList;
    NSString* actionClick;
}

- (IBAction)actionQuestion:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionShare:(id)sender;




@end

@implementation ResRecommendVC

@synthesize arrData=_arrData,
resRecommendObj=_resRecommendObj,
restaurantObj=_restaurantObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    actionClick = @"";
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""            , @"restaurant_id",
     @""            , @"RestaurantBuzzRecoList",
     @""            , @"RestaurantBuzzTipList",
     @""            , @"Click",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantReviewsAndTips" isBegin:YES];
    
    NSString* link = [NSString stringWithFormat:@"buzzcomplete?userid=%@&restaurantid=%@",[UserDefault userDefault].userID,_restaurantObj.uid];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     _restaurantObj.uid            , @"restaurant_id",
     [NSString stringWithFormat:@"%d",numberBuzzRecoList]            , @"RestaurantBuzzRecoList",
     [NSString stringWithFormat:@"%d",numberBuzzTipList]             , @"RestaurantBuzzTipList",
     actionClick            , @"Click",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantReviewsAndTips" isBegin:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(15, 47, 30, 4)];
    if (_restaurantObj.rates != 0) {
        [rateCustom setRateMedium:_restaurantObj.rates];
        [inforView addSubview:rateCustom];
        rateCustom.allowedRate = NO;
    }
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    // Do any additional setup after loading the view from its nib.
    self.arrData = [[NSMutableArray alloc] init ];
    [self configView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) configView
{
    if (_restaurantObj) {
        lbName.text = _restaurantObj.name;
        lbDetail.text = [CommonHelpers getInformationRestaurant:_restaurantObj];
    }
}

# pragma mark - IBAction 's Define

- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)actionShare:(id)sender
{
    [CommonHelpers showShareView:nil andObj:_restaurantObj];
    
}



# pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrData) {
        return _arrData.count;
    }
    
    NSLog(@"return number row 1");
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CellIndentifier = @"ResRecommendCell";
    
    ResRecommendCell *cell = (ResRecommendCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(ResRecommendCell *) [[[NSBundle mainBundle ] loadNibNamed:@"ResRecommendCell" owner:self options:nil] objectAtIndex:0];
    }
    ResRecommendObj *obj = [_arrData objectAtIndex:indexPath.row];
    [cell initForCell:obj];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIndentifier = @"ResRecommendCell";
    
    ResRecommendCell *cell = (ResRecommendCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(ResRecommendCell *) [[[NSBundle mainBundle ] loadNibNamed:@"ResRecommendCell" owner:self options:nil] objectAtIndex:0];
    }
    
    
    return cell.frame.size.height;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ResRecommendDetailVC *vc = [[ResRecommendDetailVC alloc] initWithNibName:@"ResRecommendDetailVC" bundle:nil];
    vc.resRecommendObj = [_arrData objectAtIndex:indexPath.row];
    
    if (vc.resRecommendObj.tipID == TipNone) {
        actionClick = @"restaurantBuzzRecoList ";
    }
    else
        actionClick = @"restaurantBuzzTipList";
    
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@",response);
    if (key == 1) {
        [self.arrData removeAllObjects];
        NSDictionary* dicResponseData = [response objectFromJSONString];
        NSArray* array  = [dicResponseData objectForKey:@"restaurantBuzzRecoList"];
        for (NSDictionary* dicResponse in array) {
            NSDictionary* dic = [dicResponse objectForKey:@"recommenderUser"];
            UserObj *user = [[UserObj alloc] init];
            user.name = [dic objectForKey:@"name"];
            user.avatarUrl = [dic objectForKey:@"photo"];
            user.uid = [dic objectForKey:@"userId"];
            ResRecommendObj *obj = [[ResRecommendObj alloc] init];
            obj.user = user;
            obj.numberOfLikes = 0;
            obj.title = [NSString stringWithFormat:@"%@ recommended for you.", user.name];
            obj.recotext = [dicResponse objectForKey:@"recorequestText"];
            obj.detail = [dicResponse objectForKey:@"replyText"];
            obj.uid = [dicResponse objectForKey:@"replyId"];;
            obj.tipID = TipNone;
            [self.arrData addObject:obj];
            numberBuzzRecoList++;
        }
        
        if (array.count == 0) {
            btAsk.hidden = YES;
        }
        
        NSArray* arrayTips = [dicResponseData objectForKey:@"restaurantBuzzTipList"];
        for (NSDictionary* dicResponse in arrayTips) {
            numberBuzzTipList++;
            UserObj *user = [[UserObj alloc] init];
            user.name = [NSString stringWithFormat:@"%@ %@", [dicResponse objectForKey:@"tipUserFirstName"], [dicResponse objectForKey:@"tipUserLastName"]];
            user.avatarUrl = [dicResponse objectForKey:@"tipUserPhoto"];
            if(![[dicResponse objectForKey:@"tipUserId"] isKindOfClass:[NSNull class]])
            {
                user.uid = [dicResponse objectForKey:@"tipUserId"];
            }
            else
            {
                user.uid = @"";
            }
            ResRecommendObj *obj = [[ResRecommendObj alloc] init];
            obj.user = user;
            obj.numberOfLikes = 0;
            obj.title = [NSString stringWithFormat:@"%@ left a tip.", user.name];
            
            obj.detail = [dicResponse objectForKey:@"tipText"];
            obj.uid = [dicResponse objectForKey:@"tipId"];
            NSString* source = [dicResponse objectForKey:@"tipSource"];
            NSString* from = [NSString stringWithFormat:@"%@", source];
            if ([from isEqualToString:@"TS"]) {
                obj.tipID = TipFromTS;
            }
            if ([from isEqualToString:@"4SQ"]) {
                obj.tipID = TipFrom4SQ;
            }
            
            [self.arrData addObject:obj];
        }
        
        [tbvRecommend reloadData];
    }
    
}

@end
