//
//  RecommendDetail1.m
//  TasteSync
//
//  Created by Victor on 12/26/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "RecommendDetail1.h"
#import "RecommendDetail2.h"
#import "RecommendDetail3.h"
#import "RecommendDetail4.h"
#import "CommonHelpers.h"
#import "AddRestaurantCell.h"
#import "FilterRestaurant.h"
#import "RestaurantRecommendations2.h"
#import "GlobalNotification.h"

@interface RecommendDetail1 ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,AddRestaurantCellDelegate,FilterRestaurantDelegate>
{
    __weak IBOutlet UIImageView *ivAvatar, *ivFrame;
    __weak IBOutlet UILabel *lbNotification,*lbName;
    __weak IBOutlet UITextView *tvLongMsg;
    __weak IBOutlet UILabel *lbReplyto;
    __weak IBOutlet UIButton *btFollow,*btSearch ,*btBack;
    __weak IBOutlet UITextField /**tfSearch*/*tfMsg;
    __weak IBOutlet UITableView *tbvFilter,*tbvResult;
    __strong IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIView *view1,*view2,*view3,*viewMsgSent,*viewMain;
    UITextField *cTextField;
    FilterRestaurant *filterView;
    UserDefault *userDefault;
    GlobalNotification *glNotif ;
    NotificationObj *currentNotif;
    TextView* textView;
    UITextView* tvMsg;

}


- (IBAction)actionFollow:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionNewsfeedTab:(id)sender;

- (IBAction)actionSearch:(id)sender;

- (IBAction)actionSend:(id)sender;

- (IBAction)actionHideKeyboard:(id)sender;

- (IBAction)actionAvatar:(id)sender;


@end

@implementation RecommendDetail1

@synthesize notificationObj=_notificationObj,
indexOfNotification=_indexOfNotification,
totalNotification=_totalNotification,
arrData=_arrData,
arrDataRestaurant=_arrDataRestaurant,
arrDataFilter=_arrDataFilter;

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
    // Do any additional setup after loading the view from its nib.
    
    textView = [[TextView alloc]initWithFrame:CGRectMake(10, 15, 200, 122)];
    textView.textView.font = [UIFont fontWithName:@"Avenir Medium" size:12.0];
    [textView.textView setBackgroundColor:[UIColor clearColor]];
    tvMsg = textView.textView;
    textView.delegate = self;
    [view3 addSubview:textView];
    
    glNotif = [[GlobalNotification alloc]initWithALlType];
    
    userDefault = [UserDefault userDefault];
    
    if (userDefault.loginStatus == NotLogin) {
        btBack.hidden = YES;
    }

    if (glNotif.isSend) {     
        [scrollViewMain setContentSize:CGSizeMake(320, 540)];
        viewMsgSent.hidden = NO;
        [viewMain setFrame:CGRectMake(0,70, viewMain.frame.size.width, viewMain.frame.size.height)];

    }
    else
    {
        [scrollViewMain setContentSize:CGSizeMake(320, 540)];
        viewMsgSent.hidden = YES;
        [viewMain setFrame:CGRectMake(0, 0, viewMain.frame.size.width, viewMain.frame.size.height)];
        [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x,260, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];


    }
     
    
    filterView = [[FilterRestaurant alloc] initWithFrame:CGRectMake(-320, 0, 320, 480)];
    filterView.delegate = self;
    
    if (_notificationObj) {
        ivAvatar.image = _notificationObj.user.avatar;        
        //NSString *firstCh = [_notificationObj.user.lastname substringToIndex:1];
        if (_notificationObj.type == TYPE_1) {
            lbName.text = [NSString stringWithFormat:@"%@. %@",_notificationObj.user.name,NO_TITLE_1];
        }
        else
        {
            lbName.text = [NSString stringWithFormat:@"%@. needs a",_notificationObj.user.name];
        }
        if (_notificationObj.user.status == UserStatusFollower) {
            btFollow.hidden = NO;
        }
        else
        {
            btFollow.hidden = YES;
        }
        
        tvLongMsg.text = _notificationObj.description;
        
        if (userDefault.loginStatus == NotLogin) {
            lbNotification.text = [NSString stringWithFormat:@"NOTIFICATION %d of %d",1,1];

        }
        else{
            lbNotification.text = [NSString stringWithFormat:@"NOTIFICATION %d of %d",_indexOfNotification,_totalNotification];

        }
        
        
        lbReplyto.text = [NSString stringWithFormat:@"Reply to %@",_notificationObj.user.name];
    }

    
    if (!_arrDataRestaurant) {
        self.arrDataRestaurant = [[NSMutableArray alloc] init ];
        for (int i=0; i<10; i++) {
            RestaurantObj *obj = [[RestaurantObj alloc] init];
            obj.name= [NSString stringWithFormat:@"Restaurant %d",i];
            [self.arrDataRestaurant addObject:obj];
        }
    }

    
    if (!_arrData) {
        self.arrData = [[NSMutableArray alloc] init ];
        
        RestaurantObj *obj = [[RestaurantObj alloc] init];
        [self.arrData addObject:obj];
        
    }
    
    if (!_arrDataFilter) {
        self.arrDataFilter = [[NSMutableArray alloc] init];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction define


- (IBAction)actionBack:(id)sender
{
    [self.global.recomendationDelegate reloadRecomendation];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (IBAction)actionFollow:(id)sender
{
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Share great recommendations \n Please Sign-up to help us" delegate:self tag:0];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            sleep(1);
            self.notificationObj.user.status = UserStatusFollow;
            dispatch_async(dispatch_get_main_queue(), ^{
                [btFollow setTitle:@"Following" forState:UIControlStateNormal];
                btFollow.enabled = NO;
            });
        });
    }
}

- (IBAction)actionAvatar:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:_notificationObj.user];
}

- (IBAction)actionSearch:(id)sender
{
    [self hideKeyBoard];
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Share great recommendations \n Please Sign-up to help us" delegate:self tag:0];
    }
    else
    {
        [filterView show];

    }
    
}

- (IBAction)actionSend:(id)sender
{
    if ([CommonHelpers trim:tfMsg.text].length == 0) {
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:REC_DETAIL1_MSG_SEND delegate:nil tag:0];
    }
    else
    {
        if (_arrData.count == 1)
        {
            RestaurantObj *obj = [_arrData objectAtIndex:0];
            if (obj.name == nil) {
                 [CommonHelpers showInfoAlertWithTitle:APP_NAME message:REC_DETAIL1_MSG_RES delegate:nil tag:0];
            }
            else
            {
                tfMsg.text = nil;
                [self hideKeyBoard];
                _notificationObj.read = TRUE;
                [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
            }
        
        }
        else
        {
            tfMsg.text = nil;
            [self hideKeyBoard];
            _notificationObj.read = TRUE;
            [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
        }

    }
}


- (IBAction)actionHideKeyboard:(id)sender
{
    [self hideKeyBoard];
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
            return _arrData.count;
        }
    }else
    {
        if (_arrDataFilter) {
            return _arrDataFilter.count;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvResult) {
        static NSString *CellIndentifier = @"add_restaurant_cell";
        
        AddRestaurantCell *cell = (AddRestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(AddRestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AddRestaurantCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        RestaurantObj *obj = [_arrData objectAtIndex:indexPath.row];
        
        cell.tag = indexPath.row;
        
        [cell initForCell:obj];
        if (indexPath.row == (_arrData.count -1)) {
//            tfSearch= cell.tfName;
//            tfSearch.delegate = self;
            cell.btAdd.hidden = NO;
            cell.btMinus.hidden = YES;
        }
        else
        {
            cell.btMinus.hidden = NO;
        }
        cell.delegate = self;

    
        return cell;
    }
    else
    {
        static NSString *CellIndentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        
        cell.textLabel.text = obj.name;
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
//        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor whiteColor];

        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvFilter) {
        
        RestaurantObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        
        [self.arrData replaceObjectAtIndex:(_arrData.count-1) withObject:obj];
        [tbvResult reloadData];
        tbvFilter.hidden= YES;
        [self.arrDataFilter removeAllObjects];
//        [self hideKeyBoard];
    }
}

/*
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbvResult) {
        if (indexPath.row < _arrData.count -1) {
            [self.arrData removeObjectAtIndex:indexPath.row];
            [tbvResult reloadData];
        }
    }
   
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Share great recommendations \n Please Sign-up to help us" delegate:self tag:0];
        return NO;
    }
    
    textField.text = @"";

    if (/*textField==tfSearch*/ FALSE) {
        
        if (glNotif.isSend) {
            [scrollViewMain setContentOffset:CGPointMake(0, 190) animated:YES];

        }
        else
        {
            [scrollViewMain setContentOffset:CGPointMake(0, 130) animated:YES];

        }
//        [self searchLocal:@""];

    }
    else
    {
        if (glNotif.isSend) {
            [scrollViewMain setContentOffset:CGPointMake(0, 310) animated:YES];
            
        }
        else
        {
            [scrollViewMain setContentOffset:CGPointMake(0, 250) animated:YES];
            
        }
    }
    
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
//    [self onClickLookup:nil];
    [scrollViewMain setContentOffset:CGPointZero];
    [self hideKeyBoard];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField == tfSearch) {
//        [self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
//
//    }
//    
    return TRUE;
    
}

# pragma mark - Others

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    tbvFilter.hidden = YES;
    [self hideKeyBoard];
}

- (void) searchLocal:(NSString *)txt
{
    NSString *str = [NSString stringWithFormat:@"name MATCHES[cd] '%@.*'", [CommonHelpers trim:txt]];    
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    NSArray *array = [self.arrDataRestaurant filteredArrayUsingPredicate:predicate];
    if(array)
    {
        self.arrDataFilter = [NSMutableArray arrayWithArray:array];
    }
   
    for (RestaurantObj *obj in _arrData) {
        if ([_arrDataFilter containsObject:obj]) {
            [self.arrDataFilter removeObject:obj];
        }
    }
    
    if (self.arrDataFilter.count>0) {
        
              
        tbvFilter.hidden = NO;
        [tbvFilter reloadData];
    }
       

}

- (void) hideKeyBoard
{
    debug(@"hideKeyBoard");
    [tfMsg resignFirstResponder];
    [cTextField resignFirstResponder];
    [tvLongMsg resignFirstResponder];
    [scrollViewMain setContentOffset:CGPointZero];

}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
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
    else
    {
        if (buttonIndex ==1) {
            [[CommonHelpers appDelegate] showLoginDialog];
        }
    }
    
}

#pragma mark - addRestaurantCellDelegate

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell shouldBeginEditing:(UITextField *) aTextField
{
    
    debug(@"addRestaurantCell -> shouldBeginEditing ");
    cTextField = aTextField;
    
    NSIndexPath *indexPath = [tbvResult indexPathForCell:addRestaurantCell];
    
    // Robin : replace scroll content offset
    
    CGFloat POINT_Y = 0;
    if (glNotif.isSend) {
        
        POINT_Y = 324;
    }
    else
    {
        POINT_Y = 254;

        if (indexPath.row < 2) {
            POINT_Y+= (indexPath.row*44);
        
        } else {
            POINT_Y+= 88;
        }
      
        
    }
    
    [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x, POINT_Y, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
    [scrollViewMain setContentOffset:CGPointMake(0, POINT_Y-50)];
}

- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell didChangeTextFieldWithString:(NSString *) aString
{
    [self searchLocal:aString];
}
- (void) addRestaurantCell:(AddRestaurantCell *)addRestaurantCell didAction:(id)anObject tagAction:(int)aTag
{

    NSIndexPath *indexPathFrame = [tbvResult indexPathForCell:addRestaurantCell];
    switch (aTag) {
        case TagAdd:
        {
            RestaurantObj *lastObj = [_arrData lastObject];
            if (lastObj.name == nil) {
                debug(@"don't add");
            }
            else
            {
                debug(@"Show atag : %d for row : %d",aTag,(_arrData.count-1));
                RestaurantObj *obj = [[RestaurantObj alloc] init];
                [self.arrData addObject:obj];
                [tbvResult reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrData.count-1) inSection:0];
                debug(@"Show atag : %d for row : %d and IndexPath row : %d",aTag,(_arrData.count-1),indexPath.row);
                [tbvResult scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
                if (indexPathFrame.row < 2) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [view2 setFrame:CGRectMake(view2.frame.origin.x, view2.frame.origin.y, view2.frame.size.width, view2.frame.size.height + 40)];
                        [view3 setFrame:CGRectMake(view3.frame.origin.x, view3.frame.origin.y + 40, view3.frame.size.width, view3.frame.size.height)];
                    }];
                }
            }
           
            
        }
            break;
            
        case TagSearch:
        {
            tbvFilter.hidden = YES;
            [self actionSearch:nil];
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
            
        default:
            break;
    }
    
}

#pragma mark - FilterRestaurantDelegate

- (void) filterRestaurant:(FilterRestaurant *)filterRestaurant didFinish:(id)anObj tag:(int)aTag
{
    //    show restaurant in tbv
    
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
    NSLog(@"Line: %f", textView.textView.contentSize.height);
    //[scrollViewMain setContentOffset:CGPointMake(0, 190) animated:YES];
}
-(void)enterSearchObject:(NSString *)text
{
    NSLog(@"%@",text);
    [self searchLocal:text];
}
-(void)beginEditting
{
    [scrollViewMain setContentOffset:CGPointMake(0, 190) animated:YES];
}

@end
