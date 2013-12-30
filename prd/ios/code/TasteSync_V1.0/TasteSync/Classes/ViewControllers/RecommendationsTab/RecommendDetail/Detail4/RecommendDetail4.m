//
//  RecommendDetail4.m
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//


#import "RecommendDetail1.h"
#import "RecommendDetail2.h"
#import "RecommendDetail3.h"
#import "RecommendDetail4.h"
#import "Detail4Cell.h"
#import "CommonHelpers.h"
#import "AddRestaurantCell.h"
#import "FilterRestaurant.h"
#import "RestaurantRecommendations2.h"
#import "GlobalNotification.h"
#import "JSONKit.h"

@interface RecommendDetail4 ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AddRestaurantCellDelegate,FilterRestaurantDelegate,Detail4CellDelegate>
{
    __weak IBOutlet UILabel *lbNotification;
    __weak IBOutlet UITextField /**tfSearch*/ *cTextField;
    __weak IBOutlet UITableView *tbvFilter,*tbvResult;
    __weak IBOutlet UIView *view1,*view2;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIButton *btSearch,*btDone;
    __weak IBOutlet UIImageView *imv_frame;
    FilterRestaurant *filterView;

    GlobalNotification *glNotif ;
    NotificationObj *currentNotif;
    

}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeedTab:(id)sender;
- (IBAction)actionDone:(id)sender;



@end

@implementation RecommendDetail4

@synthesize notificationObj=_notificationObj,
indexOfNotification=_indexOfNotification,
totalNotification=_totalNotification,
arrData=_arrData,
arrDataFilter=_arrDataFilter,
arrDataRestaurant=_arrDataRestaurant;

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
    lbNotification.text = [NSString stringWithFormat:@"NOTIFICATION %d of %d",_indexOfNotification,_totalNotification];
    [CommonHelpers setBackgroudImageForView:self.view];
    
    
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
//    [view2 addGestureRecognizer:gestureRecognizer];
    
    glNotif = [[GlobalNotification alloc] init];
    filterView = [[FilterRestaurant alloc] initWithFrame:CGRectMake(-320,0, 320, 480)];
    filterView.delegate = self;
    _notificationObj.unread = NO;

//    UITapGestureRecognizer *recognizerDone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDone:)];
//    [btDone addGestureRecognizer:recognizerDone];
    
    // Do any additional setup after loading the view from its nib.
    [scrollViewMain setContentSize:CGSizeMake(320, 600)];

    if (glNotif.isSend) {
        view1.hidden = NO;
    }
    else
    {
        
        view1.hidden = YES;
        [view2 setFrame:CGRectMake(0, view2.frame.origin.y-60, view2.frame.size.width, view2.frame.size.height)];
    }
    
    self.arrDataRestaurant = [[NSMutableArray alloc] init ];
    self.arrData = [[NSMutableArray alloc] init];
    if (!_arrDataFilter) {
        self.arrDataFilter = [[NSMutableArray alloc] init];
    }
    
    NSString* link = [NSString stringWithFormat:@"recommendedrestaurants?recorequestid=%@",self.notificationObj.linkId];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    request.showIndicate = YES;
    [request startFormRequest];
    


}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBaction's define
- (IBAction)actionHidekeyboard:(id)sender
{
    [self hideKeyBoard];
}

- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}


- (IBAction)actionBack:(id)sender
{
    [self.global.recomendationDelegate reloadRecomendation];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionDone:(id)sender
{
    _notificationObj.read = TRUE;
    [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
}

# pragma mark - Others

- (void) gotoDetailNotification:(NotificationObj *) obj atIndex:(int) index;
{
    debug(@"gotoDetailNotification");
    
    if (obj == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return ;
    }
    
    glNotif.index = index;
    index++;
    
    currentNotif = obj;
    
    if (obj.type==TYPE_1) {
        RecommendDetail1 *vc = [[RecommendDetail1 alloc] initWithNibName:@"RecommendDetail1" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (obj.type == TYPE_2)
    {
        debug(@"type 2");
        RestaurantRecommendations2 *vc = [[RestaurantRecommendations2 alloc] initWithNibName:@"RestaurantRecommendations2" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (obj.type== TYPE_3||obj.type==TYPE_4)
    {
        RecommendDetail2 *vc = [[RecommendDetail2 alloc] initWithNibName:@"RecommendDetail2" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (obj.type==TYPE_5)
    {
        RecommendDetail3 *vc = [[RecommendDetail3 alloc] initWithNibName:@"RecommendDetail3" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (obj.type==TYPE_6)
    {
        RecommendDetail4 *vc = [[RecommendDetail4 alloc] initWithNibName:@"RecommendDetail4" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(obj.type == TYPE_7)
    {
        debug(@"type 7");
        NSString *msg = [NSString stringWithFormat:@"Are you sure to see this detail restaurant?"];
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:msg delegate:self tag:1];
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
    if (tableView==tbvResult) {
        if (_arrData) {
            return _arrData.count +1;
        }
    }else if(tableView == tbvFilter)
    {
        if (_arrDataFilter) {
            return _arrDataFilter.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbvResult) {
        static NSString *CellIndentifier = @"detail4_cell";
        static NSString *CellIndentifier2 = @"add_restaurant_cell";
        
        Detail4Cell *cell = (Detail4Cell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(Detail4Cell *) [[[NSBundle mainBundle ] loadNibNamed:@"Detail4Cell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        if (indexPath.row < _arrData.count) {
            RestaurantObj* obj = [_arrData objectAtIndex:indexPath.row];
            [cell initForView:obj];
            cell.delegate = self;
            if (obj.liked) {
                [cell setLikeStatus:YES];
            }
            
        }
        else
        {
            AddRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier2];
            if (cell == nil) {
                cell = (AddRestaurantCell *)[ [[NSBundle mainBundle ] loadNibNamed:@"AddRestaurantCell" owner:self options:nil] objectAtIndex:0];
                
            }
            
            
            
            cell.btAdd.hidden = YES;
            cell.tfName.enabled = YES;
            cell.tfName.text = @"";
            cell.delegate = self;
            return cell;
            
        }

      
        
        return cell;

        
    }
    else
    {
        static NSString *CellIndentifier3 = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier3];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier3];
        }
        
        RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        
        cell.textLabel.text = obj.name;
//        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];


        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debug(@"row : %d",_arrData.count);
    if (tableView == tbvFilter) {
        RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        obj.liked = YES;
        [self.arrData addObject:obj];
        [tbvResult reloadData];
        tbvFilter.hidden= YES;
        [self hideKeyBoard];
        [self.arrDataFilter removeAllObjects];
        CRequest* request = [[CRequest alloc]initWithURL:@"likesunlikes" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:obj.uid forKey:@"restaurantid"];
        [request setFormPostValue:@"1" forKey:@"likeflag"];
        request.delegate = self;
        [request startFormRequest];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";

    if (glNotif.isSend) {
        [scrollViewMain setContentOffset:CGPointMake(0, 220) animated:YES];
        
    }
    else
    {
        [scrollViewMain setContentOffset:CGPointMake(0, 160) animated:YES];
        
    }
    
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [self hideKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
//    if (textField==tfSearch) {
//        tbvFilter.hidden = YES;
//    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == tfSearch) {
//        [self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
//        
//    }
    
    return TRUE;
    
}

# pragma mark - Others


- (void) searchLocal:(NSString *)txt
{
    [self.arrDataFilter removeAllObjects];
    if (txt.length >= 1) {
        TSGlobalObj* region1 = [CommonHelpers getDefaultCityObj];
        CRequest* request = [[CRequest alloc]initWithURL:@"suggestrestaurantnames" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:2 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:txt forKey:@"key"];
        [request setFormPostValue:region1.cityObj.uid forKey:@"cityid"];
        [request startFormRequest];
    }
    
    
}


- (void) hideKeyBoard
{
    [cTextField resignFirstResponder];
    cTextField.text = @"";
    [scrollViewMain setContentOffset:CGPointZero];
    tbvFilter.hidden = YES;
}

#pragma mark - Detail4CellDelegate



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        currentNotif.read = TRUE;
        RestaurantObj *obj = [[RestaurantObj alloc] init];
        obj.name = @"Nanking";
        obj.nation = @"American";
        obj.rates = 4;
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionSelectRestaurant:obj selectedIndex:1];

     
    }
    else
    {
        [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
    }
    
}

#pragma mark - addRestaurantCellDelegate

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell shouldBeginEditing:(UITextField *) aTextField
{
    NSIndexPath *indexPath = [tbvResult indexPathForCell:addRestaurantCell];

    cTextField = aTextField;
    CGFloat POINT_Y = 0;
    if (glNotif.isSend) {
        
        POINT_Y = 173;
    }
    else
    {
        POINT_Y = 113;
        if (indexPath.row < 5) {
            POINT_Y+= (indexPath.row*44);
            
        } else {
            POINT_Y+= 5*44;
        }
                     
    }
    
    
    
    if (indexPath.row < 5) {
        [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x, POINT_Y - 5, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
        [scrollViewMain setContentOffset:CGPointMake(0, POINT_Y-50)];
        
    } else {
        [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x, POINT_Y - 44, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
        [scrollViewMain setContentOffset:CGPointMake(0, POINT_Y-100)];
    }



}

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell didChangeTextFieldWithString:(NSString *) aString
{
    [self searchLocal:aString];
}



- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell didAction:(id)anObject tagAction:(int)aTag
{
    switch (aTag) {
        case TagAdd:
        {
            RestaurantObj *lastObj = [_arrData lastObject];
            if (lastObj.name == nil) {
                debug(@"don't add");
            }
            else
            {
                debug(@" add new box");
                RestaurantObj *obj = [[RestaurantObj alloc] init];
                [self.arrData addObject:obj];
                [tbvResult reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrData.count-1) inSection:0];
                [tbvResult scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
            }
            
            
        }
            break;
            
        case TagRemove:
        {
            tbvFilter.hidden = YES;
            NSIndexPath *indexPath = [tbvResult indexPathForCell:addRestaurantCell];
            [self.arrData removeObjectAtIndex:indexPath.row];
            [tbvResult deleteRowsAtIndexPaths:[[NSMutableArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;

            
        case TagSearch:
        {
            tbvFilter.hidden = YES;
            [self actionSearch:nil];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - FilterRestaurantDelegate

- (void) filterRestaurant:(FilterRestaurant *)filterRestaurant didFinish:(id)anObj tag:(int)aTag
{
    //    show restaurant in tbv
    
}


- (IBAction)actionSearch:(id)sender
{
    [self hideKeyBoard];
    [filterView show];
    
}

-(void)pressLikeButton:(UITableViewCell *)cell Liked:(BOOL)liked
{
    NSIndexPath* index = [tbvResult indexPathForCell:cell];
    RestaurantObj* res = [_arrData objectAtIndex:index.row];
    NSLog(@"%d %d",index.row,liked);
    CRequest* request = [[CRequest alloc]initWithURL:@"likesunlikes" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:3 WithView:self.view];
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
    [request setFormPostValue:res.uid forKey:@"restaurantid"];
    [request setFormPostValue:[NSString stringWithFormat:@"%d",liked] forKey:@"likeflag"];
    request.delegate = self;
    [request startFormRequest];
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 1) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* arrayRes = [response objectFromJSONString];
        for (NSDictionary* dic in arrayRes) {
            RestaurantObj* obj = [[RestaurantObj alloc]init];
            obj.uid     = [dic objectForKey:@"restaurantId"];
            obj.name    = [dic objectForKey:@"restaurantName"];
            [self.arrData addObject:obj];
        }
        [tbvResult reloadData];
        if (arrayRes.count > 0) {
            NSDictionary* dic = [arrayRes objectAtIndex:0];
            NSString* unreadCounter = [dic objectForKey:@"unreadCounter"];
            [CommonHelpers setBottomValue:unreadCounter];
        }
        
    }
    if (key == 2) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            RestaurantObj* obj = [[RestaurantObj alloc]init];
            obj.uid = [dic objectForKey:@"restaurantId"];
            obj.name = [dic objectForKey:@"restaurantName"];
            [self.arrDataFilter addObject:obj];
        }
        [tbvFilter reloadData];
        tbvFilter.hidden = NO;

    }
    if (key == 3) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        
    }
}

@end
