//
//  RestaurantRecommendations2.m
//  TasteSync
//
//  Created by Victor on 3/14/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RestaurantRecommendations2.h"
#import "RestaurantRecommendationCell.h"
#import "CommonHelpers.h"
#import "MoreUserRecommendationsVC.h"
#import "ReplyRecomendationObj.h"
#import "ResRecommendDetailVC.h"

@interface RestaurantRecommendations2 ()<UITableViewDelegate, UITableViewDataSource,RestaurantRecommendationDelegate>
{
    __weak IBOutlet UILabel* askQuestion;
}
@end

@implementation RestaurantRecommendations2

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
    _notificationObj.unread = NO;
    [CommonHelpers setBackgroudImageForView:self.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData
{
    self.arrData = [[NSMutableArray alloc] init];
    _notificationObj.read = TRUE;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
    NSString* link = [NSString stringWithFormat:@"recos4you?userid=%@&recorequestid=%@",[UserDefault userDefault].userID, self.notificationObj.linkId];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

- (void) viewWillAppear:(BOOL)animated
{
    [tbv reloadData];
}
#pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.global.recomendationDelegate reloadRecomendation];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsFeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [self.arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"restaurant_recommendation_cell";
    
    RestaurantRecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (RestaurantRecommendationCell *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantRecommendationCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    RestaurantObj* restaurantObj = [self.arrData objectAtIndex:indexPath.row];
    
    if ([restaurantObj.name isEqualToString:@""]) {
        cell.haveRestaurant = NO;
        cell.delegate = self;
    }
    else
        cell.haveRestaurant = YES;
    
    
    NSLog(@"%d",restaurantObj.recommendArray.count);
    switch (restaurantObj.recommendArray.count) {
        case 1:
        {
            [cell initCellTest1:restaurantObj];
        }
            break;
            
        case 2:
        {
            [cell initCellTest2:restaurantObj];

        }
            break;
        default:
        {
            [cell initCellTest3:restaurantObj];

        }
            break;
    }
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"restaurant_recommendation_cell";
    
    RestaurantRecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (RestaurantRecommendationCell *)[[[NSBundle mainBundle] loadNibNamed:@"RestaurantRecommendationCell" owner:self options:nil] objectAtIndex:0];
        
    }
    RestaurantObj* restaurantObj = [self.arrData objectAtIndex:indexPath.row];
    
    float heighValue = 0;
    if ([restaurantObj.name isEqualToString:@""]) {
        heighValue = heightLength;
    }
    
    switch (restaurantObj.recommendArray.count) {
        case 1:
            {
                return 94 - heighValue;
            }
            break;
        case 2:
        {
            return 139- heighValue;
        }
            break;
        default:
        {
            return 198- heighValue;
        }
            break;
    }
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    NSDictionary* dicResponse = [responseString objectFromJSONString];
    askQuestion.text = [dicResponse objectForKey:@"recorequestText"];
    NSArray* arrayResponse = [dicResponse objectForKey:@"restaurantsForYouObjList"];
    NSString* unreadCounter = [dicResponse objectForKey:@"unreadCounter"];
    [CommonHelpers setBottomValue:unreadCounter];
    for (NSDictionary* dic in arrayResponse) {
        RestaurantObj* obj = [[RestaurantObj alloc]init];
        obj.uid = [CommonHelpers checkString:[dic objectForKey:@"restaurantId"]];
        obj.name = [CommonHelpers checkString:[dic objectForKey:@"restaurantName"]];
        obj.cuisineTier2 = [CommonHelpers checkString:[dic objectForKey:@"cuisineTier2Name"]];
        obj.price = [CommonHelpers checkString:[dic objectForKey:@"price"]];
        obj.cityObj = [[TSCityObj alloc]init];
        obj.cityObj.cityName = [CommonHelpers checkString:[dic objectForKey:@"restaurantCity"]];
        if ([[dic objectForKey:@"restaurantLat"] isKindOfClass:([NSNull class])]) {
            obj.lattitude = 0;
            obj.longtitude = 0;
            obj.rates = 0;
        }
        else
        {
            obj.lattitude = [[CommonHelpers checkString:[dic objectForKey:@"restaurantLat"]] floatValue];
            obj.longtitude = [[CommonHelpers checkString:[dic objectForKey:@"restaurantLong"]] floatValue];
            obj.deal = [CommonHelpers checkString:[dic objectForKey:@"restaurantDealFlag"]];
            obj.rates = [[CommonHelpers checkString:[dic objectForKey:@"restaurantRating"]] floatValue];
        }
        obj.deal = [CommonHelpers checkString:[dic objectForKey:@"restaurantDealFlag"]];
        obj.recommendArray = [[NSMutableArray alloc]init];
        
        NSArray* arrayReply = [dic objectForKey:@"recommendationsForYouList"];
        for (NSDictionary* dic2 in arrayReply) {
            ReplyRecomendationObj* replyObj = [[ReplyRecomendationObj alloc]init];
            replyObj.replyText = [dic2 objectForKey:@"replyText"];
            replyObj.recommenderUserFolloweeFlag = [dic2 objectForKey:@"recommenderUserFolloweeFlag"];
            NSDictionary* dicReply = [dic2 objectForKey:@"recommendeeUser"];
            replyObj.userObj = [[UserObj alloc]init];
            replyObj.userObj.uid = [dicReply objectForKey:@"userId"];
            replyObj.userObj.name = [dicReply objectForKey:@"name"];
            replyObj.userObj.avatarUrl = [dicReply objectForKey:@"photo"];
            [obj.recommendArray addObject:replyObj];
        }
        [self.arrData addObject:obj];
    }
    [tbv reloadData];
}
-(void)pressAtIndex:(int)index Reco:(ReplyRecomendationObj *)replyObject
{
    ResRecommendDetailVC* detail = [[ResRecommendDetailVC alloc]initWithNibName:@"ResRecommendDetailVC" bundle:nil];
    detail.replyRecomendationObj = replyObject;
    detail.fromRecomendation = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
