//
//  TabbarBaseVC.m
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "TabbarBaseVC.h"
#import "AskVC.h"
#import "RecommendVC.h"
#import "RestaurantVC.h"
#import "OthersTabVC.h"
#import "NewsFeedVC.h"
#import "ProfileVC.h"
#import "ResDealVC.h"
#import "SelfProfileVC.h"
#import "RestaurantDetailVC.h"
#import "MoreUserRecommendationsVC.h"
#import "CommonHelpers.h"

@interface TabbarBaseVC ()<UITabBarDelegate>
{
    UITabBar *cTabbar;
    UITabBarItem *askItem,*recommendItem,*restaurantItem;
    int selected;
}


@end

@implementation TabbarBaseVC

- (id) init
{
    self = [super init];
    if (self) {
        
            
        AskVC *askVC = [[AskVC alloc] initWithNibName:@"AskVC" bundle:nil];
        RecommendVC *recommendationsVC = [[RecommendVC alloc] initWithNibName:@"RecommendVC" bundle:nil];
        NewsFeedVC *newsfeedVC = [[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
        SelfProfileVC *othersTabVC = [[SelfProfileVC alloc] initWithNibName:@"SelfProfileVC" bundle:nil];
        RestaurantVC *restaurantVC = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];


        
        UINavigationController *askCtr = [[UINavigationController alloc] initWithRootViewController:askVC];
        UINavigationController *recommendCtr = [[UINavigationController alloc] initWithRootViewController:recommendationsVC];
        UINavigationController *restaurantCtr = [[UINavigationController alloc] initWithRootViewController:restaurantVC];
        UINavigationController *othersCtr = [[UINavigationController alloc] initWithRootViewController:othersTabVC];
        UINavigationController *newsfeedCtr = [[UINavigationController alloc] initWithRootViewController:newsfeedVC];
             
        NSMutableArray *arrTabbarControllers = [[NSMutableArray alloc] initWithObjects:askCtr,recommendCtr,restaurantCtr,othersCtr,newsfeedCtr,nil];
        
        [self setViewControllers:arrTabbarControllers animated:YES];
    }
    
    
    [self actionAsk];
    
    return self;
}

- (id) initWithRecomend
{
    self = [super init];
    if (self) {
        
        
        AskVC *askVC = [[AskVC alloc] initWithNibName:@"AskVC" bundle:nil];
        RecommendVC *recommendationsVC = [[RecommendVC alloc] initWithNotification];
        NewsFeedVC *newsfeedVC = [[NewsFeedVC alloc] initWithNibName:@"NewsFeedVC" bundle:nil];
        SelfProfileVC *othersTabVC = [[SelfProfileVC alloc] initWithNibName:@"SelfProfileVC" bundle:nil];
        RestaurantVC *restaurantVC = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
        
        
        
        UINavigationController *askCtr = [[UINavigationController alloc] initWithRootViewController:askVC];
        UINavigationController *recommendCtr = [[UINavigationController alloc] initWithRootViewController:recommendationsVC];
        UINavigationController *restaurantCtr = [[UINavigationController alloc] initWithRootViewController:restaurantVC];
        UINavigationController *othersCtr = [[UINavigationController alloc] initWithRootViewController:othersTabVC];
        UINavigationController *newsfeedCtr = [[UINavigationController alloc] initWithRootViewController:newsfeedVC];
        
        NSMutableArray *arrTabbarControllers = [[NSMutableArray alloc] initWithObjects:askCtr,recommendCtr,restaurantCtr,othersCtr,newsfeedCtr,nil];
        
        [self setViewControllers:arrTabbarControllers animated:YES];
    }
    
    
    [self actionRecommendations];
    
    return self;
}

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
    NSLog(@"TabbarbaseVC- viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tabBar.hidden = NO;
    
    cTabbar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
    
    cTabbar.delegate = self;
    
    askItem = [[UITabBarItem alloc] initWithTitle:@"Ask" image:[CommonHelpers getImageFromName:@"ic_tab_ask.png"] tag:1];
    [askItem setFinishedSelectedImage:[CommonHelpers getImageFromName:@"ic_tab_ask_on.png"] withFinishedUnselectedImage:[CommonHelpers getImageFromName:@"ic_tab_ask.png"]];
    recommendItem= [[UITabBarItem alloc] initWithTitle:@"Recommendations" image:[CommonHelpers getImageFromName:@"ic_tab_Recommendations.png"] tag:1];
    [recommendItem setFinishedSelectedImage:[CommonHelpers getImageFromName:@"ic_tab_recommendations_on.png"] withFinishedUnselectedImage:[CommonHelpers getImageFromName:@"ic_tab_Recommendations.png"]];
    restaurantItem = [[UITabBarItem alloc] initWithTitle:@"Restaurants" image:[CommonHelpers getImageFromName:@"ic_tab_restaurants.png"] tag:1];
    [restaurantItem setFinishedSelectedImage:[CommonHelpers getImageFromName:@"ic_tab_restaurants_on.png"] withFinishedUnselectedImage:[CommonHelpers getImageFromName:@"ic_tab_restaurants.png"]];
    
    [cTabbar setBackgroundColor:[UIColor blackColor]];
    [cTabbar setBackgroundImage:[self imageWithColor:[UIColor blackColor] andSize:CGSizeMake(320, 49)]];
    
    [cTabbar setItems:[[NSArray alloc] initWithObjects:askItem,recommendItem,restaurantItem, nil]];
    
    [[self.tabBar superview] addSubview:cTabbar];
    [askItem setImage:[CommonHelpers getImageFromName:@"ic_tab_ask_on.png"]];
    [self.navigationController setNavigationBarHidden:YES];
    [CommonHelpers appDelegate].cTabbar = cTabbar;

    
}
- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
    UIImage *img = nil;
    
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabbarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item==askItem) {
        [self actionAsk];
    }
    else if (item==recommendItem)
    {
        [self actionRecommendations];
    }
    else if (item == restaurantItem)
    {
        [self actionRestaurant];
    }
    else
    {
        
    }
    
}


#pragma mark - IBAction define

- (void)actionOthers
{
    NSLog(@"actionOthers");
    
    [self setSelectedIndex:3];
        
    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count>3) {
        self.selectedViewController = [viewControllersArr objectAtIndex:3];
        if (self.selectedIndex ==selected) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }
        
    }
    selected = self.selectedIndex;
    cTabbar.selectedItem = nil;
}

- (void)actionNewsfeed
{
    NSLog(@"actionNewsfeed");
    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count > 4) {
        self.selectedViewController = [viewControllersArr objectAtIndex:4];
        if (self.selectedIndex ==selected) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }
        
    }
    selected = self.selectedIndex;
    cTabbar.selectedItem = nil;


}

- (void)actionAsk
{
    NSLog(@"actionAsk");    

    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count>0) {
        self.selectedViewController = [viewControllersArr objectAtIndex:0];
        if (self.selectedIndex ==selected) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }
        
    }
    selected = self.selectedIndex;
    cTabbar.selectedItem = askItem;
    
}

- (void)actionRecommendations
{
    NSLog(@"actionRecommend");
    

    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count>1) {
        self.selectedViewController = [viewControllersArr objectAtIndex:1];
        if (self.selectedIndex ==selected) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }
        
    }
    selected = self.selectedIndex;
    cTabbar.selectedItem = recommendItem;
    
}

- (void)actionRestaurant
{
    NSLog(@"actionRestaurant");
    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count>2) {
        self.selectedViewController = [viewControllersArr objectAtIndex:2];
        if (self.selectedIndex ==selected) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }
        
    }
    selected = self.selectedIndex;
    cTabbar.selectedItem = restaurantItem;
    
}

- (void) actionRestaurantViaAskTab:(NSString*)recorequestID
{
    RestaurantVC *vc = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
    vc.notHomeScreen = YES;
    vc.recorequestID = recorequestID;
    
    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count > 2) {
        self.selectedViewController = [viewControllersArr objectAtIndex:2];
        [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
    }
   
    
    selected = self.selectedIndex;
    cTabbar.selectedItem = restaurantItem;
}
- (void) actionProfile:(UserObj *) user
{
    
//    CRequest* request = [[CRequest alloc]initWithURL:@"getUserId" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:TabbarRequestProfile];
//    request.delegate = self;
//    request.userData = user;
//    [request setFormPostValue:user.uid forKey:@"userFBID"];
//    [request startFormRequest];
    
    if ([[NSString stringWithFormat:@"%@",user.uid] isEqualToString:[NSString stringWithFormat:@"%@",[UserDefault userDefault].userID]]) {
        SelfProfileVC *othersTabVC = [[SelfProfileVC alloc] initWithNibName:@"SelfProfileVC" bundle:nil];
        [(UINavigationController *) self.selectedViewController pushViewController:othersTabVC animated:YES];
    }
    else
    {
        ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
        vc.user = user;
        vc.userID = user.uid;
        [(UINavigationController *) self.selectedViewController pushViewController:vc animated:YES];
    }
}

-(void)gotoProfile:(UserObj*)obj
{
    ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    vc.user = obj;
    vc.userID = obj.uid;
    [(UINavigationController *) self.selectedViewController pushViewController:vc animated:YES];
}

- (void) actionSelectRestaurant:(RestaurantObj *) aRestaurantObj selectedIndex:(int)aSelectedIndex;
{
    RestaurantDetailVC *vc = [[RestaurantDetailVC alloc] initWithRestaurantObj:aRestaurantObj];
    //vc.restaurantObj = aRestaurantObj;
    vc.selectedIndex = aSelectedIndex;
    
    NSArray *viewControllersArr = self.viewControllers;
    if (viewControllersArr.count>2) {
        self.selectedViewController = [viewControllersArr objectAtIndex:2];
        [(UINavigationController *)self.selectedViewController pushViewController:vc animated:YES];
    }
    
    selected = self.selectedIndex;
    cTabbar.selectedItem = restaurantItem;

}

- (void) actionBackToSelectedIndex:(int) aSelectedIndex
{
    self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
    selected = aSelectedIndex;
    if (aSelectedIndex == 1) {
        cTabbar.selectedItem = recommendItem;

    }else
    {
        cTabbar.selectedItem = nil;

    }
}


- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
    {
        view.backgroundColor = [UIColor clearColor];
        
        
        
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
            cTabbar.hidden = YES;
            break;
        }
    }
    
    
}

- (void)showTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = NO;
            cTabbar.hidden = NO;
            break;
        }
    }
}

#pragma mark - Global's method for RecommendationsTab

- (void) actionRecommendationsShowMore:(RestaurantObj*)restaurantObj
{
    MoreUserRecommendationsVC *vc = [[MoreUserRecommendationsVC alloc] initWithRestaurantObj:restaurantObj];

    [(UINavigationController *) self.selectedViewController pushViewController:vc animated:YES];
}


-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (key == TabbarRequestProfile) {
        NSDictionary* dic = [response objectFromJSONString];
        NSString* str = [dic objectForKey:@"successMsg"];
        if (str != (id)[NSNull null] && str != NULL) {
            NSLog(@"UserID_Profile: %@", str);
            ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
            vc.user = userData;
            vc.userID = str;
            [(UINavigationController *) self.selectedViewController pushViewController:vc animated:YES];
        }
    }
}
@end
