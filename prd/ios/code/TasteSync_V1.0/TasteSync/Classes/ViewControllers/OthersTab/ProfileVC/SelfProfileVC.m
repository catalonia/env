//
//  SelfProfileVC.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "SelfProfileVC.h"
#import "UserDefault.h"
#import "UserObj.h"
#import "CommonHelpers.h"
#import "UsersFollowing.h"
#import "RestaurantDetailVC.h"
#import "FacebookFriendsVC.h"
#import "blogger.h"
#import "PromptSignUpVC.h"
#import "DetailedStoryVC.h"
#import "SettingVC.h"
#import "RestaurantListsVC.h"
#import "UserActivityProfileCell.h"
#import "JSONKit.h"

@interface SelfProfileVC ()
{
    NSString* facebookURL, *twiterURL, *blogURL;
    UserObj *user;
    RestaurantObj *_restaurantObj1;
    RestaurantObj *_restaurantObj2;
    RestaurantObj *_restaurantObj3;
    NSMutableArray *_arryRestaurantsVisible;
    NSMutableArray *_arryListRestaurantShort;
    
    __weak IBOutlet UIActivityIndicatorView* activity1;
    __weak IBOutlet UIActivityIndicatorView* activity2;
    __weak IBOutlet UIActivityIndicatorView* activity3;
    __weak IBOutlet UIView* actionView;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
- (IBAction)actionCountinueReading:(id)sender;

@end

@implementation SelfProfileVC

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
    
    facebookURL     = @"";
    twiterURL       = @"";
    blogURL    = @"";
    
    _restaurantObj1 = [[RestaurantObj alloc]init];
    _restaurantObj2 = [[RestaurantObj alloc]init];
    _restaurantObj3 = [[RestaurantObj alloc]init];
    _arryRestaurantsVisible = [[NSMutableArray alloc]init];
    _arryListRestaurantShort = [[NSMutableArray alloc]init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    viewRecentActivity.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    [CommonHelpers setBackgroudImageForView:self.view];
    self.navigationController.navigationBarHidden = YES;
    
    
    user = [UserDefault userDefault].user;
    [UserDefault userDefault].user.name = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    [UserDefault userDefault].user.uid = [UserDefault userDefault].userID;
    [UserDefault update];
    [self initUI];
    
    
    if ([UserDefault userDefault].loginStatus != NotLogin) {
        debug(@"logined with emailID - > %@",user.email);
    }
    else
    {
        debug(@"not login");
        [self promptSignUp:nil];
        return;
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CRequest* request1 = [[CRequest alloc]initWithURL:@"getHomeProfile" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
    
    request1.delegate = self;
    [request1 setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
    [request1 startFormRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    [scrollViewMain setContentSize:CGSizeMake(320, 520)];//660)];
    if (user) {
        ivAvatar.image = user.avatar;
        lbUserName.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
        
        lbUserDetail.text = [NSString stringWithFormat:@"%@, %@",[UserDefault userDefault].user.hometown_location,[UserDefault userDefault].user.locate];
        lbAboutTitle.text = [NSString stringWithFormat:@"About %@", user.firstname];
        
        
    }
    
}

- (void)promptSignUp:(id)sender
{
    PromptSignUpVC *promtpSignUpVC = [[PromptSignUpVC alloc]initWithNibName:@"PromptSignUpVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:promtpSignUpVC animated:NO];
}

- (IBAction)iconAvatarButtonClick:(id)sender
{
    
}



- (void)shareProfile
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:APP_NAME delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    //  [actionSheet showInView:self.view];
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}
- (IBAction)actionNewsfeed:(id)sender
{
//    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
    [self shareProfile];
    
}


- (IBAction)actionCountinueReading:(id)sender
{
    EditAboutMeVC *vc = [[EditAboutMeVC alloc] initWithAboutText:lbAboutDetail.text];
    vc.delegate = self;
    vc.isYourProfile = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)actionSettings:(id)sender
{
    SettingVC *vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionEdit:(id)sender
{
    EditAboutMeVC *vc = [[EditAboutMeVC alloc] initWithAboutText:lbAboutDetail.text];
    vc.delegate = self;
    vc.isYourProfile = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc actionEdit:nil];
}


- (IBAction)actionFollowing:(id)sender
{
    UsersFollowing *vc = [[UsersFollowing alloc]initWithNibName:@"UsersFollowing" bundle:nil];
    vc.viewFollowing = YES;
    vc.user = [UserDefault userDefault].user;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionFollowers:(id)sender
{
    UsersFollowing *vc = [[UsersFollowing alloc]initWithNibName:@"UsersFollowing" bundle:nil];   
    vc.viewFollowing = NO;
    vc.user = [UserDefault userDefault].user;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)actionFriends:(id)sender
{
    FacebookFriendsVC *vc = [[FacebookFriendsVC alloc]initWithNibName:@"FacebookFriendsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)actionRestaurant:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (button.tag == 1) {
        RestaurantDetailVC *vc = [[RestaurantDetailVC alloc] initWithRestaurantObj:_restaurantObj1];
        vc.selectedIndex = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 2) {
        RestaurantDetailVC *vc = [[RestaurantDetailVC alloc] initWithRestaurantObj:_restaurantObj2];
        vc.selectedIndex = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 3) {
        RestaurantDetailVC *vc = [[RestaurantDetailVC alloc] initWithRestaurantObj:_restaurantObj3];
        vc.selectedIndex = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)actionMoreRestaurant:(id)sender
{
    RestaurantListsVC *vc = [[RestaurantListsVC alloc] initWithNibName:@"RestaurantListsVC" bundle:nil];
    vc.userObj = [UserDefault userDefault].user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionFacebook:(id)sender
{
    if (![facebookURL isEqualToString:@""] && facebookURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: facebookURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
- (IBAction)actionTwitter:(id)sender
{
    if (![twiterURL isEqualToString:@""] && twiterURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: twiterURL ];
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (IBAction)actionBlog:(id)sender
{
    if (![blogURL isEqualToString:@""] && blogURL != NULL) {
        NSURL *url = [ [ NSURL alloc ] initWithString: blogURL ];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - EditRateReViewDialogDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"actionSheet:click share Facebook");
            break;
        case 1:
            NSLog(@"actionSheet:click Twitter");
            break;
        case 2:
            NSLog(@"actionSheet:click Tumblr");
            break;
        case 3:
            NSLog(@"actionSheet:click Email");
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"user_activity_profile_cell";
    UserActivityProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        
        cell = (UserActivityProfileCell *) [[[NSBundle mainBundle] loadNibNamed:@"UserActivityProfileCell" owner:self options:nil] objectAtIndex:0];
    }
    
    UserActivityObj *obj = [[UserActivityObj alloc] init];
    UserObj *anUser = [[UserObj alloc] init];
    anUser.firstname = @"Victor";
    anUser.lastname = @"Ngo";
    anUser.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
    obj.user = anUser;
    obj.content = @"recommended ...";
    
    [cell initCell:obj];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailedStoryVC *detailStoryVC = [[DetailedStoryVC alloc]initWithNibName:@"DetailedStoryVC" bundle: [NSBundle mainBundle]];
    [self.navigationController pushViewController:detailStoryVC animated:YES];
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",response);
    if (response != NULL) {
        NSDictionary* dic = [response objectFromJSONString];
        lbFollowing.text = [dic objectForKey:@"numFollowers"];
        lbFollowers.text = [dic objectForKey:@"numFollowees"];
        lbFriends.text = [dic objectForKey:@"numFriendsOnTs"];
        lbPoints.text = [dic objectForKey:@"numPoints"];
        lbAboutDetail.text = [dic objectForKey:@"aboutMeText"];
        lbUserDetail.text = [dic objectForKey:@"facebookCity"];
        
        facebookURL = [dic objectForKey:@"facebookUrl"];
        twiterURL   = [dic objectForKey:@"twitterUrl"];
        blogURL     = [dic objectForKey:@"blogUrl"];
        
        NSArray* restaurantArray = [dic objectForKey:@"restaurantList"];
        if ([restaurantArray count] == 0) {
            lbRestaurant1.hidden = YES;
            lbRestaurant2.hidden = YES;
            lbRestaurant3.hidden = YES;
            btRestaurant1.hidden = YES;
            btRestaurant2.hidden = YES;
            btRestaurant3.hidden = YES;
            activity1.hidden = YES;
            activity2.hidden = YES;
            activity3.hidden = YES;
        }
        if ([restaurantArray count] == 1) {
            lbRestaurant2.hidden = YES;
            lbRestaurant3.hidden = YES;
            btRestaurant2.hidden = YES;
            btRestaurant3.hidden = YES;
            activity2.hidden = YES;
            activity3.hidden = YES;
            
            NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
            _restaurantObj1.uid = [dicRes objectForKey:@"id"];
            
            NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
            _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
            _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
            _restaurantObj1.price = [dicInformation objectForKey:@"price"];
            _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
            _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo = [dicRes objectForKey:@"photo"];
            NSString* str = [photo objectForKey:@"prefix"];
            if (![str isKindOfClass:([NSNull class])]) {
                _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                
                NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                [activity1 startAnimating];
            }
            else
            {
                activity1.hidden = YES;
            }
            
            lbRestaurant1.text = _restaurantObj1.name;
            
            [_arryRestaurantsVisible addObject:_restaurantObj1];
            
            
        }
        if ([restaurantArray count] == 2) {
            lbRestaurant3.hidden = YES;
            btRestaurant3.hidden = YES;
            activity3.hidden = YES;
            
            NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
            _restaurantObj1.uid = [dicRes objectForKey:@"id"];
            
            NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
            _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
            _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
            _restaurantObj1.price = [dicInformation objectForKey:@"price"];
            _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
            _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo = [dicRes objectForKey:@"photo"];
            NSString* str = [photo objectForKey:@"prefix"];
            if (![str isKindOfClass:([NSNull class])]) {
                _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                [activity1 startAnimating];
            }
            else
            {
                activity1.hidden = YES;
            }
            lbRestaurant1.text = _restaurantObj1.name;
            NSLog(@"lbRestaurant1.text: %@", [dicRes objectForKey:@"name"]);
            [_arryRestaurantsVisible addObject:_restaurantObj1];
            
            NSDictionary* dicRes2 = [restaurantArray objectAtIndex:1];
            _restaurantObj2.uid = [dicRes2 objectForKey:@"id"];
            
            NSDictionary* dicInformation2 = [dicRes2 objectForKey:@"information"];
            _restaurantObj2.name = [dicInformation2 objectForKey:@"restaurantName"];
            _restaurantObj2.cuisineTier2 = [dicInformation2 objectForKey:@"cuisineTier2Name"];
            _restaurantObj2.price = [dicInformation2 objectForKey:@"price"];
            _restaurantObj2.cityObj.cityName = [dicInformation2 objectForKey:@"restaurantCity"];
            _restaurantObj2.lattitude = [[dicInformation2 objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj2.longtitude = [[dicInformation2 objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj2.rates = [[dicInformation2 objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo2 = [dicRes2 objectForKey:@"photo"];
            NSString* str2 = [photo2 objectForKey:@"prefix"];
            if (![str2 isKindOfClass:([NSNull class])]) {
                _restaurantObj2.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo2 objectForKey:@"prefix"],[photo2 objectForKey:@"width"],[photo2 objectForKey:@"height"],[photo2 objectForKey:@"suffix"]];
                NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj2.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant2) toTarget:self withObject:nil];
                [activity2 startAnimating];
            }
            else
            {
                activity2.hidden = YES;
            }
            lbRestaurant2.text = _restaurantObj2.name;
            [_arryRestaurantsVisible addObject:_restaurantObj2];
            
        }
        if ([restaurantArray count] == 3) {
            NSDictionary* dicRes = [restaurantArray objectAtIndex:0];
            _restaurantObj1.uid = [dicRes objectForKey:@"id"];
            
            NSDictionary* dicInformation = [dicRes objectForKey:@"information"];
            _restaurantObj1.name = [dicInformation objectForKey:@"restaurantName"];
            _restaurantObj1.cuisineTier2 = [dicInformation objectForKey:@"cuisineTier2Name"];
            _restaurantObj1.price = [dicInformation objectForKey:@"price"];
            _restaurantObj1.cityObj.cityName = [dicInformation objectForKey:@"restaurantCity"];
            _restaurantObj1.lattitude = [[dicInformation objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj1.longtitude = [[dicInformation objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj1.rates = [[dicInformation objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo = [dicRes objectForKey:@"photo"];
            NSString* str = [photo objectForKey:@"prefix"];
            if (![str isKindOfClass:([NSNull class])]) {
                _restaurantObj1.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo objectForKey:@"prefix"],[photo objectForKey:@"width"],[photo objectForKey:@"height"],[photo objectForKey:@"suffix"]];
                NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj1.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant1) toTarget:self withObject:nil];
                [activity1 startAnimating];
            }
            else
            {
                activity1.hidden = YES;
            }
            lbRestaurant1.text = _restaurantObj1.name;
            [_arryRestaurantsVisible addObject:_restaurantObj1];
            
            NSDictionary* dicRes2 = [restaurantArray objectAtIndex:1];
            _restaurantObj2.uid = [dicRes2 objectForKey:@"id"];
            
            NSDictionary* dicInformation2 = [dicRes2 objectForKey:@"information"];
            _restaurantObj2.name = [dicInformation2 objectForKey:@"restaurantName"];
            _restaurantObj2.cuisineTier2 = [dicInformation2 objectForKey:@"cuisineTier2Name"];
            _restaurantObj2.price = [dicInformation2 objectForKey:@"price"];
            _restaurantObj2.cityObj.cityName = [dicInformation2 objectForKey:@"restaurantCity"];
            _restaurantObj2.lattitude = [[dicInformation2 objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj2.longtitude = [[dicInformation2 objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj2.rates = [[dicInformation2 objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo2 = [dicRes2 objectForKey:@"photo"];
            NSString* str2 = [photo2 objectForKey:@"prefix"];
            if (![str2 isKindOfClass:([NSNull class])]) {
                _restaurantObj2.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo2 objectForKey:@"prefix"],[photo2 objectForKey:@"width"],[photo2 objectForKey:@"height"],[photo2 objectForKey:@"suffix"]];
                NSLog(@"restaurantObj1.imageUrl: %@", _restaurantObj2.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant2) toTarget:self withObject:nil];
                [activity2 startAnimating];
            }
            else
            {
                activity2.hidden = YES;
            }
            lbRestaurant2.text = _restaurantObj2.name;
            [_arryRestaurantsVisible addObject:_restaurantObj2];
            
            NSDictionary* dicRes3 = [restaurantArray objectAtIndex:2];
            _restaurantObj3.uid = [dicRes3 objectForKey:@"id"];
            
            NSDictionary* dicInformation3 = [dicRes3 objectForKey:@"information"];
            _restaurantObj3.name = [dicInformation3 objectForKey:@"restaurantName"];
            _restaurantObj3.cuisineTier2 = [dicInformation3 objectForKey:@"cuisineTier2Name"];
            _restaurantObj3.price = [dicInformation3 objectForKey:@"price"];
            _restaurantObj3.cityObj.cityName = [dicInformation3 objectForKey:@"restaurantCity"];
            _restaurantObj3.lattitude = [[dicInformation3 objectForKey:@"restaurantLat"] floatValue];
            _restaurantObj3.longtitude = [[dicInformation3 objectForKey:@"restaurantLong"] floatValue];
            _restaurantObj3.rates = [[dicInformation3 objectForKey:@"restaurantRating"] floatValue];
            
            NSDictionary* photo3 = [dicRes3 objectForKey:@"photo"];
            NSString* str3 = [photo3 objectForKey:@"prefix"];
            if (![str3 isKindOfClass:([NSNull class])]) {
                _restaurantObj3.imageUrl = [NSString stringWithFormat:@"%@%@x%@%@",[photo3 objectForKey:@"prefix"],[photo3 objectForKey:@"width"],[photo3 objectForKey:@"height"],[photo3 objectForKey:@"suffix"]];
                NSLog(@"restaurantObj2.imageUrl: %@", _restaurantObj3.imageUrl);
                [NSThread detachNewThreadSelector:@selector(loadImageRestaurant3) toTarget:self withObject:nil];
                [activity3 startAnimating];
            }
            else
            {
                activity3.hidden = YES;
            }
            lbRestaurant3.text = _restaurantObj3.name;
            
            [_arryRestaurantsVisible addObject:_restaurantObj3];
        }
    }
    actionView.hidden = YES;
}

-(void)loadImageRestaurant1
{
    [btRestaurant1 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj1.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant1 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj1.imageUrl]]] forState:UIControlStateNormal];
    [activity1 stopAnimating];
    [activity1 setHidden:YES];
}
-(void)loadImageRestaurant2
{
    [btRestaurant2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj2.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant2 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj2.imageUrl]]] forState:UIControlStateNormal];
    [activity2 stopAnimating];
    [activity2 setHidden:YES];
}
-(void)loadImageRestaurant3
{
    [btRestaurant3 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj3.imageUrl]]] forState:UIControlStateHighlighted];
    [btRestaurant3 setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_restaurantObj3.imageUrl]]] forState:UIControlStateNormal];
    [activity3 stopAnimating];
    [activity3 setHidden:YES];
}

-(void)getAboutText:(NSString *)text
{
    lbAboutDetail.text = text;
}

@end
