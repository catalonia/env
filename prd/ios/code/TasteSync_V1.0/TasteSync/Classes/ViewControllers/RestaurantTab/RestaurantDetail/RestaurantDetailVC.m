//
//  RestaurantDetailVC.m
//  TasteSync
//
//  Created by Victor on 12/28/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "RestaurantDetailVC.h"
#import "CommonHelpers.h"
#import "ResRecommendVC.h"
#import "ResQuestionVC.h"
#import "ResShareView.h"
#import "ResMoreInfoVC.h"
#import "ResPhotoVC.h"
#import "ResMenuVC.h"
#import "ResReserveVC.h"
#import "RateCustom.h"
#import "ResDealVC.h"
#import "LeaveATipVC.h"
#import "TSPhotoRestaurantObj.h"
#import "PhotoVC.h"

@interface RestaurantDetailVC ()<UIScrollViewDelegate,ResShareViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollViewPhotos,*scrollViewMain;
    __weak IBOutlet UIView *view1,*view2,*view3,*view4,*viewImage, *viewDeal;
    __weak IBOutlet UILabel *lbName,*lbDetail,*lbsortMSg,*lbLongMsg, *lbSave, *lbFav;
    __weak IBOutlet UIButton *btSave,*btUserQuestion,*btMore, *btMenu, *btMoreInfo,*btReviews,*btReserve,*btAddToMyFavorites , *btBack, *btRestaurant,*btAvatar;
    
    __weak IBOutlet UIView* actionView;
    __weak IBOutlet UIImageView* _avatarImageView;
    UserObj* _userBuzz;
    __weak IBOutlet UILabel* lbOpenNow, *lbDeal;
    __weak IBOutlet UILabel* _lbMenu, *_lbMore, *_lbAsk;
    BOOL isSaved, restaurantChains, isAddToMyFaves, isReload;
    ResShareView *shareView ;    
    ResRecommendObj *resRecommendObj ;
    UITextView *tvNote ;
    
    NSMutableArray* _arrayPhoto;
    CGFloat _locationImage;
    NSString* _urlImage;
    int _tagImage;
    CGFloat *offset;
    BOOL reloadThisPage;
}

- (IBAction)actionQuestion:(id)sender;

- (IBAction)actionRestaurant:(id)sender;

- (IBAction)actionShare:(id)sender;

- (IBAction)actionSave:(id)sender;

- (IBAction)actionMore:(id)sender;

- (IBAction)actionMenu:(id)sender ;

- (IBAction)actionMoreInfo:(id)sender;

- (IBAction)actionAvatar:(id)sender;

- (IBAction)actionDeal:(id)sender;

- (IBAction)actionAddToMyFavorites:(id)sender;

- (IBAction)actionLeaveATip:(id)sender;

- (IBAction)actionMorePhoto:(id)sender;




@end

@implementation RestaurantDetailVC

@synthesize restaurantObj = _restaurantObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRestaurantObj:(RestaurantObj *)restaurantObj
{
    self = [super initWithNibName:@"RestaurantDetailVC" bundle:nil];
    if (self) {
        self.restaurantObj = restaurantObj;
        _arrayPhoto = [[NSMutableArray alloc]init];
    }
    return self;
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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    reloadThisPage = NO;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    if (self.selectedIndex != 2) {
        btBack.hidden = NO;
        btRestaurant.hidden = YES;
    }
    else
    {
        btBack.hidden = YES;
        btRestaurant.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isReload == NO) {
        [self hideTabBar:self.tabBarController];
        isReload = YES;
    }
    if (reloadThisPage == NO) {
        NSString* link = [NSString stringWithFormat:@"details?userid=%@&restaurantid=%@",[UserDefault userDefault].userID, self.restaurantObj.uid];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:1 WithView:self.view];
        request.delegate = self;
        [request startFormRequest];
    
        reloadThisPage = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction Define

- (IBAction) actionBackToSelectedIndex:(id)sender
{
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-49.f, view.frame.size.width, view.frame.size.height)];
        }
        else {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height-49.f)];
        }
    }
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionBackToSelectedIndex:self.selectedIndex];
}
- (IBAction)actionRestaurant:(id)sender
{
    [self showTabBar:self.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)actionShare:(id)sender
{
    debug(@"actionShare");
    [CommonHelpers showShareView:self andObj:_restaurantObj];
}

- (IBAction)actionSave:(id)sender
{
    debug(@"actionSave");
    
  
        if ([UserDefault userDefault].loginStatus == NotLogin) {
            [[CommonHelpers appDelegate] showLoginDialog];
        }
        else
        {
            NSString* saveFlag = @"";
            if (!_restaurantObj.isSaved)
                saveFlag = @"1";
            else
                saveFlag = @"0";
            CRequest* request = [[CRequest alloc]initWithURL:@"save" RQType:RequestTypePost RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:3 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
            [request setFormPostValue:_restaurantObj.uid forKey:@"restaurantid"];
            [request setFormPostValue:saveFlag forKey:@"userrestaurantsavedflag"];
            [request startFormRequest];
           

        }

    

}

- (IBAction)actionMore:(id)sender
{
    debug(@"actionMore");
    ResRecommendVC *vc = [[ResRecommendVC alloc] initWithNibName:@"ResRecommendVC" bundle:nil];
    vc.resRecommendObj = resRecommendObj;
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];

}



- (IBAction)actionMenu:(id)sender
{
        debug(@"actionMenu");
        ResMenuVC *vc = [[ResMenuVC alloc] initWithRestaurantObj:_restaurantObj];
        [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionMoreInfo:(id)sender
{
    debug(@"actionMoreInfo");
    ResMoreInfoVC *vc = [[ResMoreInfoVC alloc] initWithRestaurantObj:self.restaurantObj];
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithRestaurantObj:self.restaurantObj];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionDeal:(id)sender
{
    ResDealVC *vc = [[ResDealVC alloc] initWithNibName:@"ResDealVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}



- (IBAction)actionAvatar:(id)sender
{

    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:resRecommendObj.user];
    
}

- (IBAction)actionAddToMyFavorites:(id)sender
{
    if ([UserDefault userDefault].loginStatus != NotLogin) {
        
        NSString* saveFavFlag = @"";
        if (!_restaurantObj.isFavs)
            saveFavFlag = @"1";
        else
            saveFavFlag = @"0";
        CRequest* request = [[CRequest alloc]initWithURL:@"savefavs" RQType:RequestTypePost RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:4 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:_restaurantObj.uid forKey:@"restaurantid"];
        [request setFormPostValue:saveFavFlag forKey:@"userrestaurantfavflag"];
        [request startFormRequest];
        
    }
    else
    {
        [[CommonHelpers appDelegate] showLoginDialog];

    }
    
}

- (IBAction)actionLeaveATip:(id)sender
{
    LeaveATipVC *vc = [[LeaveATipVC alloc] initWithRestaurantObj:_restaurantObj];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)actionMorePhoto:(id)sender
{
    ResPhotoVC* restPhoto = [[ResPhotoVC alloc]initWithArrayPhoto:_restaurantObj];
    [self.navigationController pushViewController:restPhoto animated:YES];
}

# pragma mark - others

- (void) configView
{
    [scrollViewMain setContentSize:CGSizeMake(320, 580)];
    if (_restaurantObj.isSaved) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btSave];
        lbSave.text = @"Saved";
        
    }else
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved.png"] forButton:btSave];
        lbSave.text = @"Save";
        
    }
    
    if (_restaurantObj.isFavs) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addedtomyfaves.png"] forButton:btAddToMyFavorites];
        lbFav.text = @"Added to Favs";
    }
    else
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addtomyfaves.png"] forButton:btAddToMyFavorites];
        lbFav.text = @"Add to Favs";
    }
    
    lbDeal.text = self.restaurantObj.deal;
    
    if (!self.restaurantObj.isMenuFlag) {
        btMenu.hidden = YES;
        _lbMenu.hidden = YES;
    }
    
    if (!self.restaurantObj.isMoreInfo) {
        btMoreInfo.hidden = YES;
        _lbMore.hidden = YES;
    }
    
    resRecommendObj = [[ResRecommendObj alloc] init];
    resRecommendObj.title = @"Victor recommends for ";
    resRecommendObj.detail = @"Victor wrote : it's really bored ...";
    UserObj *user = [[UserObj alloc] init];
    user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
    user.firstname = @"Victor";
    user.lastname = @"NGO";
    resRecommendObj.user = user;
//    [self setupHorizontalScrollView];
    if (_restaurantObj) {
        lbName.text = self.restaurantObj.name;
    }
}
- (void)setupHorizontalScrollView
{
    
    RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(15, 55, 30, 4)];
    if (_restaurantObj.rates != 0) {
        [rateCustom setRateMedium:_restaurantObj.rates];
        [view1 addSubview:rateCustom];
        rateCustom.allowedRate = NO;
    }
    
    scrollViewPhotos.delegate = self;
    [scrollViewPhotos setContentSize:CGSizeMake(90*[_arrayPhoto count], [scrollViewPhotos bounds].size.height)];
   // [scrollViewPhotos setCanCancelContentTouches:NO];
    
    scrollViewPhotos.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollViewPhotos.clipsToBounds = YES;
    scrollViewPhotos.scrollEnabled = YES;
    scrollViewPhotos.pagingEnabled = YES;
    
    NSInteger tot=0;
    CGFloat cx = 15;
    //for (; ; nimages++)
    for (TSPhotoRestaurantObj* photoObj in _arrayPhoto)
    {
       _urlImage = [NSString stringWithFormat:@"%@%dx%d%@", photoObj.prefix, photoObj.width, photoObj.height, photoObj.suffix];
        _locationImage = cx;
        _tagImage = [_arrayPhoto count] + tot ;
        [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
        
        CGRect rect;
        rect.size.height = 60;
        rect.size.width = 60;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        UIButton *btn = [[UIButton alloc] init];
        
        UIImage* image = [CommonHelpers getImageFromName:@"frame1.png"];
        
        btn.frame = rect;
        btn.tag = tot;
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
//        [btn addTarget:self action:@selector(showPhotoDetail:) forControlEvents:UIControlEventTouchUpInside];
        [scrollViewPhotos addSubview:btn];
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame = rect;
        activityView.tag = [_arrayPhoto count] + tot;
        [activityView startAnimating];
        [scrollViewPhotos addSubview:activityView];
        
        cx += rect.size.width+30;
        tot++;
    }
   
//    [scrollViewPhotos setFrame:CGRectMake(30, 340, 260, 90)];
    
    
    debug(@"scrollview x-> %f, y-> %f, width-> %f, height-> %f",scrollViewPhotos.frame.origin.x,scrollViewPhotos.frame.origin.y,scrollViewPhotos.frame.size.width,scrollViewPhotos.frame.size.height) ;
}

- (void) showPhotoDetail:(id) params
{
    debug(@"showPhotoDetail");
    UIButton* button = (UIButton*)params;
    NSLog(@"TAG: %d",button.tag);
    int data;
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (int i = 0; i < [_arrayPhoto count]; i++) {
        TSPhotoRestaurantObj* obj = [_arrayPhoto objectAtIndex:i];
        if (obj.image != nil) {
            if (i == button.tag) {
                data = [array count];
            }
            [array addObject:obj];
        }
        
        
    }
    
    PhotoVC* photo = [[PhotoVC alloc]initWithArrayPhotos:array AtIndex:button.tag];
    [self.navigationController pushViewController:photo animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    debug(@"alertView -> clickedButtonAtIndex");
    switch (buttonIndex) {
        case 0:
            debug(@"cancel");
            break;
            
            case 1:
            debug(@"save with note -> %@",tvNote.text);
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saverestaurants.png"] forButton:btSave];
            _restaurantObj.isSaved = YES;
            
            break;
        default:
            break;
    }
}
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    if (key == 1) {
        NSDictionary* dicResponse = [response objectFromJSONString];
        NSString* str = [dicResponse objectForKey:@"openNowFlag"];
        if (![str isKindOfClass:([NSNull class])]) {
            self.restaurantObj.isOpenNow                =  [[dicResponse objectForKey:@"openNowFlag"] isEqualToString:@"1"]?YES:NO;
            if (_restaurantObj.isOpenNow)
                lbOpenNow.text = @"Open Now";
            else
                lbOpenNow.text = @"Closed Now";
        }
        else
        {
            lbOpenNow.text = @"";
        }
        self.restaurantObj.deal                            =  [dicResponse objectForKey:@"dealHeadline"];
        if ([self.restaurantObj.deal isEqualToString:@""]) 
            self.restaurantObj.isDeal = NO;
        else
            self.restaurantObj.isDeal = YES;
        
        self.restaurantObj.isMoreInfo                  =  [[dicResponse objectForKey:@"moreInfoFlag"]  isEqualToString:@"1"]?YES:NO;
        self.restaurantObj.isMenuFlag                =  [[dicResponse objectForKey:@"menuFlag"] isEqualToString:@"1"]?YES:NO;
        self.restaurantObj.isSaved                      =  [[dicResponse objectForKey:@"userRestaurantSavedFlag"] isEqualToString:@"1"]?YES:NO;
        self.restaurantObj.isFavs                         =  [[dicResponse objectForKey:@"userRestaurantFavFlag"]  isEqualToString:@"1"]?YES:NO;
        self.restaurantObj.isTipFlag                     =  [[dicResponse objectForKey:@"userRestaurantTipFlag"]  isEqualToString:@"1"]?YES:NO;
        [self configView];
        
        NSArray* dicPhoto = [dicResponse objectForKey:@"photoList"];
        
        if (dicPhoto.count > 0) {
            for (NSDictionary* dic in dicPhoto) {
                TSPhotoRestaurantObj* obj = [[TSPhotoRestaurantObj alloc]init];
                obj.uid                              = [dic objectForKey:@"restaurantId"];
                obj.photoId                       = [dic objectForKey:@"photoId"];
                obj.prefix                          = [dic objectForKey:@"prefix"];
                obj.suffix                           = [dic objectForKey:@"suffix"];
                obj.width                           = [[dic objectForKey:@"width"] intValue];
                obj.height                          = [[dic objectForKey:@"height"] intValue];
                obj.ultimateSourceName = [dic objectForKey:@"ultimateSourceName"];
                obj.ultimateSourceUrl      = [dic objectForKey:@"ultimateSourceUrl"];
                obj.photoSource               =  [dic objectForKey:@"photoSource"];
                [_arrayPhoto addObject:obj];
            }
        }
        else
        {
            view4.frame = CGRectMake(view4.frame.origin.x, 278, view4.frame.size.width, view4.frame.size.height);
            viewImage.hidden = YES;
        }
        
        NSDictionary* dic = [dicResponse objectForKey:@"restaurantBuzz"];
        if (![dic  isKindOfClass:[NSNull class]] && dic != nil) {
            _userBuzz = [[UserObj alloc]init];
            lbLongMsg.text = [dic objectForKey:@"replyText"];
            NSDictionary* dicUser = [dic objectForKey:@"recommenderUser"];
            lbsortMSg.text = [NSString stringWithFormat:@"%@ recommends for you",[dicUser objectForKey:@"name"]];
            _userBuzz.avatarUrl = [dicUser objectForKey:@"photo"];
            _userBuzz.uid = [dicUser objectForKey:@"userId"];
            if (![_userBuzz.avatarUrl isKindOfClass:[NSNull class]]) {
                [NSThread detachNewThreadSelector:@selector(loadImageUserObj) toTarget:self withObject:nil];
            }
        }
        else
        {
            NSDictionary* dicBuzz = [dicResponse objectForKey:@"restaurantBuzzComplete"];
            NSArray* arrayBuzzRecoList;
            NSArray* arrayBuzzTipList;
            arrayBuzzRecoList = [dicBuzz objectForKey:@"restaurantBuzzRecoList"];
            arrayBuzzTipList = [dicBuzz objectForKey:@"restaurantBuzzTipList"];

            
            if (![arrayBuzzRecoList isKindOfClass:[NSNull class]]) {
                NSDictionary* dicUser = [arrayBuzzRecoList objectAtIndex:0];
                _userBuzz = [[UserObj alloc]init];
                lbLongMsg.text = [dicUser objectForKey:@"tipText"];
                NSDictionary* dicObj = [dicUser objectForKey:@"recommenderUser"];
                lbsortMSg.text = [NSString stringWithFormat:@"%@ recommended for you", [dicObj objectForKey:@"name"]];
                
                NSString* via = [NSString stringWithFormat:@"%@", [dicUser objectForKey:@"tipSource"]];
                if ([via isEqualToString:@"4SQ"]) {
                    lbsortMSg.text = [lbsortMSg.text stringByAppendingString:@" via foursquare"];
                    btAvatar.enabled = NO;
                }
                if ([via isEqualToString:@"TS"]) {
                    lbsortMSg.text = [lbsortMSg.text stringByAppendingString:@" via TasteSync"];
                }
                
                _userBuzz.avatarUrl = [dicObj objectForKey:@"photo"];
                _userBuzz.uid = [dicObj objectForKey:@"userId"];
                if (![_userBuzz.avatarUrl isKindOfClass:[NSNull class]]) {
                    [NSThread detachNewThreadSelector:@selector(loadImageUserObj) toTarget:self withObject:nil];
                }
                
            }
            else
            {
                btUserQuestion.hidden = YES;
                _lbAsk.hidden = YES;
                if(![arrayBuzzTipList isKindOfClass:[NSNull class]])
                {
                    NSDictionary* dicUser = [arrayBuzzTipList objectAtIndex:0];
                    _userBuzz = [[UserObj alloc]init];
                    lbLongMsg.text = [dicUser objectForKey:@"tipText"];
                    lbsortMSg.text = [NSString stringWithFormat:@"%@ %@ left a tip", [dicUser objectForKey:@"tipUserFirstName"],[dicUser objectForKey:@"tipUserLastName"]];
                    
                    NSString* via = [NSString stringWithFormat:@"%@", [dicUser objectForKey:@"tipSource"]];
                    if ([via isEqualToString:@"4SQ"]) {
                        lbsortMSg.text = [lbsortMSg.text stringByAppendingString:@" via foursquare"];
                        btAvatar.enabled = NO;
                    }
                    if ([via isEqualToString:@"TS"]) {
                        lbsortMSg.text = [lbsortMSg.text stringByAppendingString:@" via TasteSync"];
                    }
                    _userBuzz.avatarUrl = [dicUser objectForKey:@"tipUserPhoto"];
                    _userBuzz.uid = [dicUser objectForKey:@"tipUserId"];
                    if (![_userBuzz.avatarUrl isKindOfClass:[NSNull class]]) {
                        [NSThread detachNewThreadSelector:@selector(loadImageUserObj) toTarget:self withObject:nil];
                    }
                }
                
                else
                {
                    view4.frame = CGRectMake(view4.frame.origin.x, view4.frame.origin.y - 120, view4.frame.size.width, view4.frame.size.height);
                    viewImage.frame = CGRectMake(viewImage.frame.origin.x, viewImage.frame.origin.y - 120, viewImage.frame.size.width, viewImage.frame.size.height);
                    view2.hidden = YES;
                }
            }
        }
        
        if (self.restaurantObj.isDeal) {
            lbDeal.text = self.restaurantObj.deal;
        }
        else
        {
            view4.frame = CGRectMake(view4.frame.origin.x, view4.frame.origin.y - 46, view4.frame.size.width, view4.frame.size.height);
            viewImage.frame = CGRectMake(viewImage.frame.origin.x, viewImage.frame.origin.y - 46, viewImage.frame.size.width, viewImage.frame.size.height);
            view2.frame = CGRectMake(view2.frame.origin.x, view2.frame.origin.y - 46, view2.frame.size.width, view2.frame.size.height);
            viewDeal.hidden = YES;
        }
        
        NSDictionary* dicInfomation = [dicResponse objectForKey:@"restaurantsTileSearch"];
        
        self.restaurantObj.uid               =  [dicInfomation objectForKey:@"restaurantId"];
        self.restaurantObj.name              = [dicInfomation objectForKey:@"restaurantName"];
        self.restaurantObj.cuisineTier2      = [dicInfomation objectForKey:@"cuisineTier2Name"];
        self.restaurantObj.price             = [dicInfomation objectForKey:@"price"];
        self.restaurantObj.deal              =  [dicInfomation objectForKey:@"restaurantDealFlag"];
        self.restaurantObj.rates             = [[dicInfomation objectForKey:@"restaurantRating"] floatValue];
        
        self.restaurantObj.lattitude         = [[dicInfomation objectForKey:@"restaurantLat"] floatValue];
        self.restaurantObj.longtitude        = [[dicInfomation objectForKey:@"restaurantLong"] floatValue];
        self.restaurantObj.cityObj           = [[TSCityObj alloc]init];
        self.restaurantObj.cityObj.cityName  = [dicInfomation objectForKey:@"restaurantCity"];
        
        lbDetail.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
        
        [self setupHorizontalScrollView];
    
        actionView.hidden = YES;
    }
    if (key == 3) {
        if (!_restaurantObj.isSaved) {
            
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btSave];
            lbSave.text = @"Saved";
            _restaurantObj.isSaved = YES;
            
            
        }
        else
        {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved.png"] forButton:btSave];
            lbSave.text = @"Save";
            _restaurantObj.isSaved = NO;
        }
    }
    if (key == 4) {
        if (!_restaurantObj.isFavs) {
            _restaurantObj.isFavs = TRUE;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addedtomyfaves.png"] forButton:btAddToMyFavorites];
            lbFav.text = @"Added to Favs";
        }
        else
        {
            _restaurantObj.isFavs = FALSE;
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_addtomyfaves.png"] forButton:btAddToMyFavorites];
            lbFav.text = @"Add to Favs";
        }
    }
}

-(void)loadImage
{
    @autoreleasepool {
        int tag = _tagImage;
        CGRect rect = CGRectMake(_locationImage, 0, 60, 60);
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_urlImage]]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = rect;
        [scrollViewPhotos addSubview:imageView];
        for (UIView* view in scrollViewPhotos.subviews) {
            if (view.tag == tag) {
                UIActivityIndicatorView* activity= ( UIActivityIndicatorView*)view;
                [activity stopAnimating];
                [activity removeFromSuperview];
            }
        }
        
        TSPhotoRestaurantObj* obj = [_arrayPhoto objectAtIndex:tag - [_arrayPhoto count]];
        obj.image = image;
    }
}

-(void)loadImageUserObj
{
    @autoreleasepool {
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_userBuzz.avatarUrl]]];
        _userBuzz.avatar = image;
        _avatarImageView.image = image;
    }
}

@end
