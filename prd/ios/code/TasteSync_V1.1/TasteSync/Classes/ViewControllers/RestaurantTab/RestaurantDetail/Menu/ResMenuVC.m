//
//  ResMenuVC.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResMenuVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "ResMenuCell.h"
#import "MenuObj.h"

@interface ResMenuVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *lbResName,*lbResDetail;
    __weak IBOutlet UIView *viewRes;
    __weak IBOutlet UITableView *tbvmenu;
    __weak IBOutlet UIWebView* _webview;
    __weak IBOutlet UIActivityIndicatorView* _activityIndicate;
    NSString* _url;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionQuestion:(id)sender;


@end

@implementation ResMenuVC

@synthesize arrData=_arrData,
restaurantObj=_restaurantObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRestaurantObj:(RestaurantObj*)restaurantObj
{
    self = [super initWithNibName:@"ResMenuVC" bundle:nil];
    if (self) {
        self.restaurantObj = restaurantObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    tbvmenu.separatorStyle = UITableViewCellSelectionStyleNone ;
    _webview.scrollView.showsHorizontalScrollIndicator = NO;
    _webview.scrollView.showsVerticalScrollIndicator = NO;
    lbResDetail.text = [CommonHelpers getInformationRestaurant:_restaurantObj];

    
    if (_arrData==nil) {
        self.arrData = [[NSMutableArray alloc] init ];
        for (int i=0; i<4;i++) {
            MenuObj *menuObj = [[MenuObj alloc] init];
            if (i==0) {
                menuObj.kind = @"Appetizers";
            }
            else  if  (i==1) {
                menuObj.kind = @"Noodles";
            }else
            {
                menuObj.kind = @"Drinks";
            }
            
            NSMutableArray *arrFood = [[NSMutableArray alloc] init];
            
            for (int j=0; j<6; j++) {
                FoodObj *foodObj = [[FoodObj alloc] init];
                foodObj.name = @"Chicken Hakla";
                foodObj.price = j;
                [arrFood addObject:foodObj];
            }
            menuObj.foodArr = arrFood;
            
            [self.arrData addObject:menuObj];
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @""           , @"RestaurantID",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"RestaurantMenu" isBegin:YES];
    
    NSString* link = [NSString stringWithFormat:@"menu?userid=%@&restaurantid=%@",[UserDefault userDefault].userID, self.restaurantObj.uid];
    NSLog(@"%@, %@", [UserDefault userDefault].userID, self.restaurantObj.uid);
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
    _restaurantObj.uid           , @"RestaurantID",
    nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"RestaurantMenu" isBegin:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShare:(id)sender
{
    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}
- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _arrData.count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MenuObj *obj = [_arrData objectAtIndex:section];
    
    if (obj.foodArr) {
        return obj.foodArr.count;
    }
   
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MenuObj *obj = [_arrData objectAtIndex:section];
    return obj.kind;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
//                                 saturation:1.0
//                                 brightness:0.60
//                                      alpha:1.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:13];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIndentifier = @"resmenu_cell";
    
    ResMenuCell *cell = (ResMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        cell =(ResMenuCell *) [[[NSBundle mainBundle ] loadNibNamed:@"ResMenuCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    
    MenuObj *menuObj = [_arrData objectAtIndex:indexPath.section];    
    
    [cell initForCell:[menuObj.foodArr objectAtIndex:indexPath.row]];
    
    return cell;
    
    
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    NSDictionary* dicResponse = [response objectFromJSONString];
    if (key == 1) {
        _url = [dicResponse objectForKey:@"menuMobileUrl"];
        NSLog(@"%@",_url);
        [NSThread detachNewThreadSelector:@selector(loadWebview) toTarget:self withObject:nil];
    }
}
-(void)loadWebview
{
    NSURL* url = [NSURL URLWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webview setScalesPageToFit:YES];
    [_activityIndicate startAnimating];
    [_webview loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [_activityIndicate stopAnimating];
    [_activityIndicate removeFromSuperview];
//    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 5.0;"];
//    [_webview stringByEvaluatingJavaScriptFromString:jsCommand];
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    theWebView.scrollView.minimumZoomScale = rw;
//    theWebView.scrollView.maximumZoomScale = rw;
//    theWebView.scrollView.zoomScale = rw;
}

@end
