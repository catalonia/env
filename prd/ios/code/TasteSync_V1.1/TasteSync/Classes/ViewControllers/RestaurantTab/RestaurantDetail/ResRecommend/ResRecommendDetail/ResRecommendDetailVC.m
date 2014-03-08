//
//  ResRecommendDetailVC.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResRecommendDetailVC.h"
#import "FriendFilterCell.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "RateCustom.h"
@interface ResRecommendDetailVC ()
{
    __weak IBOutlet UILabel *lbName,*lbDetail;
    __weak IBOutlet UILabel *lbTitle, *lbLikes;
    __weak IBOutlet UITextView *tvDetail;
    __weak IBOutlet UITableView *tbvUser;
    __weak IBOutlet UIButton *btFollow,*btLike;
    __weak IBOutlet UIImageView* _avatar;
    
    TextView* textView;
    __weak IBOutlet UIView* replyView;
    __weak IBOutlet UIScrollView* scrollMain;
    __weak IBOutlet UITableView* tbvFilter;
    NSMutableArray* _arrDataFilter;
    __weak IBOutlet UILabel* replyText;
    
    NSString* restaurantID, *replyID, *actionClick;
    
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionLike:(id)sender;
- (IBAction)actionFollow:(id)sender;
- (IBAction)actionQuestion:(id)sender;
- (IBAction)actionAvatar:(id)sender;

@end

@implementation ResRecommendDetailVC

@synthesize arrData=_arrData,
resRecommendObj =_resRecommendObj,
restaurantObj=_restaurantObj;

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
    restaurantID = @"";
    replyID = @"";
    actionClick = @"";
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    [self configView];
    if (!self.fromRecomendation) {
        RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(18, 59, 30, 4)];
        if (_restaurantObj.rates != 0) {
            [rateCustom setRateMedium:_restaurantObj.rates];
            [scrollMain addSubview:rateCustom];
            rateCustom.allowedRate = NO;
        }
    }
    _arrData = [[NSMutableArray alloc]init];
    _arrDataFilter = [[NSMutableArray alloc]init];
    textView = [[TextView alloc]initWithFrame:CGRectMake(13, 15, 232, 88)];
    textView.textView.font = [UIFont fontWithName:@"Avenir Medium" size:12.0];
    [textView.textView setBackgroundColor:[UIColor clearColor]];
    textView.delegate = self;
    [replyView addSubview:textView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""            , @"restaurant_id",
     @""            , @"replyId",
     @""            , @"ClickSendReply",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantReviewsAndTipsDetail" isBegin:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     restaurantID            , @"restaurant_id",
     replyID            , @"replyId",
     actionClick            , @"ClickSendReply",
     nil];
    [CommonHelpers implementFlurry:params forKey:@"RestaurantReviewsAndTipsDetail" isBegin:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction's define


- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShare:(id)sender
{
//    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}
- (IBAction)actionSentMessage:(id)sender
{
    actionClick = @"SentClick";
    
    [UIView animateWithDuration:0.3 animations:^{
        [textView.textView resignFirstResponder];
        scrollMain.frame = CGRectMake(0, 44, scrollMain.frame.size.width, scrollMain.frame.size.height);
    }];
    
    NSString* listRestaurant = @"";
    for (RestaurantObj* obj in self.arrData) {
        if (obj.uid.length != 0) {
            if (listRestaurant.length == 0) {
                listRestaurant = [listRestaurant stringByAppendingString:obj.uid];
            }
            else
            {
                listRestaurant = [listRestaurant stringByAppendingString:@","];
                listRestaurant = [listRestaurant stringByAppendingString:obj.uid];
            }
        }
        
    }
    
    CRequest* request = [[CRequest alloc]initWithURL:@"recosreply" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:2 WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:_resRecommendObj.uid    forKey:@"replyid"];
    [request setFormPostValue:textView.textView.text                forKey:@"replytext"];
    [request setFormPostValue:[UserDefault userDefault].userID      forKey:@"userid"];
    [request setFormPostValue:listRestaurant                        forKey:@"restaurantidlist"];
    
    NSLog(@"List restaurant: %@", listRestaurant);
    NSLog(@"Text: %@", textView.textView.text );
    NSLog(@"replyid: %@", _resRecommendObj.uid );
    
    
    [request startFormRequest];
    
    
}
- (IBAction)actionLike:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        if (_resRecommendObj.isLike) {
            _resRecommendObj.isLike = NO;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like.png"] forButton:btLike];
            _resRecommendObj.numberOfLikes --;
        }
        else
        {
            _resRecommendObj.isLike = YES;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_like_on.png"] forButton:btLike];
            _resRecommendObj.numberOfLikes ++;
        }
        
        if (_resRecommendObj.numberOfLikes == 0) {
            lbLikes.hidden = YES;
        }
        else if (_resRecommendObj.numberOfLikes ==1)
        {
            lbLikes.hidden = NO;
            lbLikes.text = [NSString stringWithFormat:@"%d Like",_resRecommendObj.numberOfLikes];
            
        }
        else
        {
            lbLikes.hidden = NO;
            lbLikes.text = [NSString stringWithFormat:@"%d Likes",_resRecommendObj.numberOfLikes];
        }


    }
       
}
- (IBAction)actionFollow:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        btFollow.hidden = YES;

    }
}
- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionAvatar:(id)sender
{
    if (_resRecommendObj.tipID != TipFrom4SQ)
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:_resRecommendObj.user];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrDataFilter) {
        return _arrDataFilter.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"cell";
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
        
    RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        
    cell.textLabel.text = obj.name;
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setBackgroundColor:[UIColor blackColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
    [textView addRestaurant:obj];
    tbvFilter.hidden= YES;
    [_arrDataFilter removeAllObjects];
    
}

# pragma mark - others

- (void) configView
{
    if (self.fromRecomendation) {
        if(!self.replyRecomendation)
        {
            replyView.hidden = YES;
            lbName.hidden = YES;
            lbDetail.hidden = YES;
            lbLikes.text = [NSString stringWithFormat:@"%d people like this.",_resRecommendObj.numberOfLikes];
        }
        
        lbName.text = _restaurantObj.name;
        lbDetail.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
        replyText.text = [NSString stringWithFormat:@"Reply to %@",_replyRecomendationObj.userObj.name];
        lbTitle.text = _replyRecomendationObj.userObj.name;
        tvDetail.text = _replyRecomendationObj.replyText;
        
        replyID = _replyRecomendationObj.uid;
        restaurantID = _restaurantObj.uid;
        
        if (_replyRecomendationObj.userObj.avatar != nil) {
            _avatar.image = _replyRecomendationObj.userObj.avatar;
        }
        else
            [NSThread detachNewThreadSelector:@selector(loadimagerecomend) toTarget:self withObject:nil];
    }
    else
    {
        if (_restaurantObj) {
            lbName.text = _restaurantObj.name;
            lbDetail.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
            replyView.hidden = YES;
            replyID = _resRecommendObj.uid;
            restaurantID = _restaurantObj.uid;
            if (_resRecommendObj.tipID == TipNone) {
                replyView.hidden = NO;
                lbTitle.text = _resRecommendObj.title;
                tvDetail.text = [NSString stringWithFormat:@"%@ \n in response to your question - %@",_resRecommendObj.detail, _resRecommendObj.recotext];
                replyText.text = [NSString stringWithFormat:@"Reply to %@",_resRecommendObj.user.name];
            }
            else
            {
                lbTitle.text = _resRecommendObj.user.name;
                
                tvDetail.text = _resRecommendObj.detail;
            }
            
            if (_resRecommendObj.user.avatar != nil) {
                _avatar.image = _resRecommendObj.user.avatar;
            }
            else
                [NSThread detachNewThreadSelector:@selector(loadimage) toTarget:self withObject:nil];
        }
    }
    
    
}
-(void)loadimage
{
    _avatar.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_resRecommendObj.user.avatarUrl]]];
}
-(void)loadimagerecomend
{
    _avatar.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_replyRecomendationObj.userObj.avatarUrl]]];
}
-(IBAction)hideKeyboardPress:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [textView.textView resignFirstResponder];
        scrollMain.frame = CGRectMake(0, 44, scrollMain.frame.size.width, scrollMain.frame.size.height);
    }];
}
- (void) searchLocal:(NSString *)txt
{
    
    if (txt.length == 0) {
        return;
        
    }
    if (txt.length >= 1) {
        {
            TSGlobalObj* region = [CommonHelpers getDefaultCityObj];
            CRequest* request = [[CRequest alloc]initWithURL:@"suggestrestaurantnames" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:1 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:txt forKey:@"key"];
            [request setFormPostValue:region.cityObj.uid forKey:@"cityid"];
            [request startFormRequest];
        }
    }
}
#pragma mark TextviewDelegate
-(void)addNewObject:(HighlightText *)object
{
    [_arrData addObject:object.userObj];
}
-(void)removeObject:(HighlightText *)object
{
    [_arrData removeObject:object.userObj];
}
-(void)enterCharacter:(NSString *)text
{
    
}
-(void)enterSearchObject:(NSString *)text
{
    [self searchLocal:text];
    
}
-(void)beginEditting
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollMain.frame = CGRectMake(0, -200, scrollMain.frame.size.width, scrollMain.frame.size.height);
    }];
}
#pragma mark RequestDelegate
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key != 2) {
        [_arrDataFilter removeAllObjects];
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            
            RestaurantObj* restaurantObj = [[RestaurantObj alloc]init];
            
            restaurantObj.uid                              =  [dic objectForKey:@"restaurantId"];
            restaurantObj.factualId                     = [dic objectForKey:@"factualId"];
            restaurantObj.name                          = [dic objectForKey:@"restaurantName"];
            restaurantObj.isOpenNow                =  [[dic objectForKey:@"openNowFlag"] isEqualToString:@"1"]?YES:NO;
            restaurantObj.deal                            =  [dic objectForKey:@"dealHeadline"];
            if ([restaurantObj.deal isEqualToString:@""])
                restaurantObj.isDeal = NO;
            else
                restaurantObj.isDeal = YES;
            
            restaurantObj.isMoreInfo                  =  [[dic objectForKey:@"moreInfoFlag"]  isEqualToString:@"1"]?YES:NO;
            restaurantObj.isMenuFlag                =  [[dic objectForKey:@"menuFlag"] isEqualToString:@"1"]?YES:NO;
            restaurantObj.isSaved                      =  [[dic objectForKey:@"userRestaurantSavedFlag"] isEqualToString:@"1"]?YES:NO;
            restaurantObj.isFavs                         =  [[dic objectForKey:@"userRestaurantFavFlag"]  isEqualToString:@"1"]?YES:NO;
            restaurantObj.isTipFlag                     =  [[dic objectForKey:@"userRestaurantTipFlag"]  isEqualToString:@"1"]?YES:NO;
            [_arrDataFilter addObject:restaurantObj];
        }
        tbvFilter.hidden = NO;
        [tbvFilter reloadData];
    }
    else
    {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
