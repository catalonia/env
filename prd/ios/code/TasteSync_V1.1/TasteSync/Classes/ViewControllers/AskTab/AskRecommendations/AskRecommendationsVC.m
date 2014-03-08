//
//  AskRecommendationsVC.m
//  TasteSync
//
//  Created by Victor on 2/20/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "AskRecommendationsVC.h"
#import "CommonHelpers.h"
#import "FriendCell.h"
#import "FriendFilterCell.h"
#import "ConfigProfileVC.h"
#import "CustomProgressView.h"
@interface AskRecommendationsVC ()<FriendCellDelegate,UITextFieldDelegate,CFacebookDelegate,CustomProgressViewDelegate>
{
    BOOL isSend;
    BOOL postOnFbChecked;
    BOOL recommendationsSent;
    UITextField *cTextField;
    IBOutlet UILabel* askContentLabel;
    UserDefault *userDefault;
    CFacebook *facebook;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UIActivityIndicatorView *activityView;
    
    __weak IBOutlet UILabel *action1, *action2, *action3, *action4;
    __weak IBOutlet UIImageView *tickMark;
    
    NSMutableArray* _arrayData;
    TSGlobalObj* _location;
    NSString* _recoRequestId;
    CustomProgressView *customProgressView;
    int numberAskPress, numberBrowsePress;
}

@end

@implementation AskRecommendationsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithArrayData:(NSMutableArray*)array atLocation:(TSGlobalObj*)location Reco_RequestID:(NSString*)recorequestID
{
    self = [super initWithNibName:@"AskRecommendationsVC" bundle:nil];
    if (self) {
        _arrayData = array;
        _location = location;
        _recoRequestId = recorequestID;
       
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    numberAskPress = 0;
    numberBrowsePress = 0;
    
    
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%@",_recoRequestId]       , @"recorequestId",
     [NSString stringWithFormat:@"%d",numberAskPress]       , @"Click on Ask Friends",
     [NSString stringWithFormat:@"%d",numberBrowsePress]  , @"Click on Browse our picks for you",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Confirmation" isBegin:YES];
    
    if (isSend == NO) {
        
        NSString* link = [NSString stringWithFormat:@"recofriends?recorequestid=%@",_recoRequestId];
        CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataAsk RQCategory:ApplicationForm withKey:1 WithView:self.view];
        request.delegate = self;
        request.showIndicate = YES;
        [request startFormRequest];
        
        isSend = YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewProgress.hidden = YES;
    [CommonHelpers setBackgroudImageForView:self.view];
//    [self performSelector:@selector(initUI) withObject:nil afterDelay:1.0];
    [self initData];
    [activityView startAnimating];
    isSend = NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSDictionary *askhomeParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%@",_recoRequestId]       , @"recorequestId",
     [NSString stringWithFormat:@"%d",numberAskPress]       , @"Click on Ask Friends",
     [NSString stringWithFormat:@"%d",numberBrowsePress]  , @"Click on Browse our picks for you",
     nil];
    [CommonHelpers implementFlurry:askhomeParams forKey:@"Ask_Confirmation" isBegin:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
 
    btGotIt.hidden = YES;
    viewWaiting.hidden = YES;
    btNewsfeed.hidden = YES;
    viewMain.hidden = NO;
    btSkipThis.hidden = NO;
    if (_askSentences) {
        tfAsk.text =  _askSentences;
    }
    else
    {
        tfAsk.text = @"I am looking for a Nanking";
    }
    
}

- (void) initData
{
    userDefault = [UserDefault userDefault];
    if(_arrData == nil)
    {
        UserObj *obj = [[UserObj alloc] init];
        
        self.arrData = [[NSMutableArray alloc] initWithObjects:obj, nil];
    }
    if (_arrDataFriends == nil) {
        self.arrDataFriends = [[NSMutableArray alloc] init];
        self.arrDataFriends = [[CommonHelpers appDelegate] arrDataFBFriends];
    }
    
    self.arrDataFilter = [[NSMutableArray alloc] init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [gesture setCancelsTouchesInView:NO];
    [tbvResult addGestureRecognizer:gesture];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (recommendationsSent) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        self.view = viewNotLogin;
        
    }
    else
    {
        self.view = viewLogin;
    }
    
    [CommonHelpers setBackgroudImageForView:self.view];
   
    
}

#pragma mark - IBAction's function

- (IBAction)actionOthersTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionOthers];
}
- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}
- (IBAction)actionSkipThis:(id)sender
{
    recommendationsSent = YES;
    
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionRestaurantViaAskTab:_recoRequestId];
}
- (IBAction)actionPostOnFb:(id)sender
{
    if (postOnFbChecked) {
        postOnFbChecked = FALSE;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check.png"] forButton:btPostOnFb];
    }
    else
    {
        postOnFbChecked = TRUE;
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forButton:btPostOnFb];
    }
}
- (IBAction)actionRecommendations:(id)sender
{
    //[self sendRequest];
    [self performSelector:@selector(actionSkipThis:) withObject:nil afterDelay:1.0];
}
-(void)sendRequestData
{
    //[self sendRequest];
}
-(void)numberClick:(int)countnumberEmail SMS:(int)countnumberSMS TSNumber:(int)countnumberTS
{
    
}
-(void)sendRequest
{
    NSString* facebookID = @"";
    int i = 0;
    for (UserObj* obj in _arrData) {
        if (obj.uid != nil) {
            NSString* str = [NSString stringWithFormat:@"%@", obj.uid];
            if (i == 0)
                facebookID = str;
            else
                facebookID = [facebookID stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
            i++;
        }
    }
    NSLog(@"%@",facebookID);
    NSString* postOnFacebook = @"";
    if (postOnFbChecked)
        postOnFacebook = @"1";
    else
        postOnFacebook = @"0";
    
    
    CRequest* request = [[CRequest alloc]initWithURL:@"saverecofriends" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:2 WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
    [request setFormPostValue:_recoRequestId forKey:@"recorequestid"];
    [request setFormPostValue:tfAsk.text forKey:@"recorequestfriendtext"];
    [request setFormPostValue:facebookID forKey:@"friendsfacebookidlist"];
    [request setFormPostValue:postOnFacebook forKey:@"postonfacebook"];
    [request startFormRequest];
//    btSkipThis.hidden = YES;
//    btNewsfeed.hidden = NO;
//    viewMain.hidden = YES;
//    viewWaiting.hidden = NO;
    recommendationsSent = YES;
    
}

- (IBAction)actionGotIt:(id)sender
{
    [self initUI];
}

- (IBAction)actionConnectWithFacebook:(id)sender
{
    facebook = [[CFacebook alloc] init];
    [facebook getUserFriends:self tagAction:CFacebookTagActionGetFriendsInfo];

}
- (IBAction)actionSkipAhead:(id)sender
{
    
    self.view = viewLogin;
    [self initUI];
}
- (IBAction)actionNoThanks:(id)sender
{
    
    numberBrowsePress = 1;
    [self performSelector:@selector(actionSkipThis:) withObject:nil afterDelay:1.0];
}
- (IBAction)actionSentEmail:(id)sender
{
    numberAskPress = 1;
    AskContactVC* ask = [[AskContactVC alloc]initWithAsk:_askSentences WithRecoID:_recoRequestId];
    
    ask.delegate = self;
    [self.navigationController pushViewController:ask animated:YES];
    
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
            return self.arrData.count;
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
        static NSString *CellIndentifier = @"friend_cell";
        
        FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(FriendCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        UserObj *obj = [self.arrData objectAtIndex:indexPath.row];
        debug(@"%@ %@",obj.firstname,obj.lastname);
        [cell initForCell:obj];
        cell.delegate = self;
        if (indexPath.row < self.arrData.count-1) {
            cell.btAdd.hidden = YES;
            cell.btnMinus.hidden = NO;
            
        }
        else
        {
            cell.btnMinus.hidden = YES;
            cell.btAdd.hidden = NO;
            
//            tfSearch= cell.tfName;
//            tfSearch.delegate = self;
            
        }
        if (obj.uid ==0) {
            cell.tfName.enabled = YES;
            cell.tfName.text = @"Friend's name";
            
        }
        else
        {
            cell.tfName.enabled = NO;
            
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIndentifier = @"friend_filter_cell";
        
        FriendFilterCell *cell = (FriendFilterCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(FriendFilterCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendFilterCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        [cell initForCell:[_arrDataFilter objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvFilter) {        
        UserObj *obj = [[UserObj alloc] init];
        obj = [_arrDataFilter objectAtIndex:indexPath.row];
        [self.arrData replaceObjectAtIndex:(self.arrData.count-1) withObject:obj];
        [tbvResult reloadData];
        tbvFilter.hidden= YES;
//        tfSearch.text = nil;
        [self.arrDataFilter removeAllObjects];
        [self hideKeyBoard:YES];
        
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    cTextField = textField;
    if ([textField isEqual:tfAsk]) {
        return YES;
    }
    textField.text = @"";
    if ([UserDefault userDefault].loginStatus == NotLogin) {        
        [[CommonHelpers appDelegate] showLoginDialog];
        return NO;
    }
    else
    {
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             self.view.frame=CGRectMake(self.view.frame.origin.x,-100,self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             debug(@"move done");
//                             [self searchLocal:@""];
                             
                             
                         }];
    }
    
    
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    //    [self onClickLookup:nil];
    [self hideKeyBoard:YES];
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
    
    return TRUE;
    
}

# pragma mark - Others


- (void) searchLocal:(NSString *)txt
{
    
    tbvFilter.hidden = YES;
    
    [self.arrDataFilter removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    
    
    for (UserObj *userObj in self.arrDataFriends) {
        NSString *firstName = [userObj.firstname uppercaseString];
        NSString *uTxt = [txt uppercaseString];
        int diff = strncmp([firstName UTF8String], [uTxt UTF8String], uTxt.length);
        
        if (diff == 0) {
           
            [self.arrDataFilter addObject:userObj];
        }
        
    }
    
    for (UserObj *userObj in self.arrDataFriends) {
        NSString *lastName = [userObj.lastname uppercaseString];
        NSString *uTxt = [txt uppercaseString];
        int diff = strncmp([lastName UTF8String], [uTxt UTF8String], uTxt.length);
        
        if (diff == 0) {
            if (![self.arrDataFilter containsObject:userObj]) {
                [self.arrDataFilter addObject:userObj];
                
            }
        }
    }

    
    for (UserObj *obj in _arrData) {
        if ([_arrDataFilter containsObject:obj]) {
            [self.arrDataFilter removeObject:obj];
        }
    }
    
    if (self.arrDataFilter.count>0) {
        
                
        tbvFilter.hidden = NO;
        [tbvFilter reloadData];
    }
    
    debug(@"AskRecommendationsVC -> searchLocal arrDatarFilter.count = %d arrDataFriends.count =%d",_arrDataFilter.count, _arrDataFriends.count);
}


- (void) hideKeyBoard:(BOOL)check
{
    tbvFilter.hidden = YES;
    [cTextField resignFirstResponder];
    //[tfSearch resignFirstResponder];
    [tfAsk resignFirstResponder];
    if (!check) {
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                                viewMain.frame=CGRectMake(viewMain.frame.origin.x,20,viewMain.frame.size.width, viewMain.frame.size.height);                         }
                         completion:^(BOOL finished){
                             debug(@"hideKeyBoard -> move done ");
                             
                         }];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    tbvFilter.hidden = YES;
    [self hideKeyBoard:NO];
  
    
}

- (IBAction)actionHideKeyPad:(id)sender
{
    [self hideKeyBoard:NO];
}


# pragma mark - FriendCellDelegate

- (void) friendCell:(FriendCell *)friendCell shouldBeginEditingTextField:(UITextField *)aTextField option:(int) anOption
{
    cTextField = aTextField;
    
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
        
    }
    else
    {
        CGFloat POINT_Y = 0;
        CGRect frame= tbvFilter.frame;
        
        NSIndexPath *indexPath = [tbvResult indexPathForCell:friendCell];
        if (indexPath.row<3) {
            POINT_Y = (indexPath.row)*44;
        }
        else
        {
            POINT_Y = 88;
        }
        
        frame.origin.y = 140 + POINT_Y;
        
        
        //        [scrollViewMain setContentOffset:CGPointMake(0, POINT_Y)];
        [tbvFilter setFrame:frame];
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             viewMain.frame=CGRectMake(viewMain.frame.origin.x,-POINT_Y-100,viewMain.frame.size.width, viewMain.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             debug(@"move done");
                             //                             [self searchLocal:@""];
                             
                             
                         }];
        
    }

}
- (void) friendCell:(FriendCell *)friendCell didChangeTextFieldWithString:(NSString *) aString
{
    debug(@"AskRecommendationsVC friendCell - didChangeTextFieldWithString -> aString = %@",aString);
       
    [self searchLocal:aString];


}

- (void) friendCell:(FriendCell *)friendCell didAction:(id)anObj tag:(int)aTag
{
    switch (aTag) {
        case FriendCellActionTagAdd:
        {
            
            UserObj *userObj = [self.arrData lastObject];
            if (userObj.uid == 0) {
                debug(@"don't add");
            }
            else
            {
                UserObj *obj = [[UserObj alloc] init ];
                [self.arrData addObject:obj];
                [tbvResult reloadData];
                
              
                
                CGFloat CELL_HIGH_DEFAULT = 44;
                
                int count = _arrData.count -1;
                
                if (count < 3) {
                    
                    [viewFriends setFrame:CGRectMake(viewFriends.frame.origin.x, viewFriends.frame.origin.y, viewFriends.frame.size.width,54 + CELL_HIGH_DEFAULT*count)];
                    /*
                    [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width,44 + CELL_HIGH_DEFAULT*count)];
                    [imv_frame setFrame:CGRectMake(imv_frame.frame.origin.x, imv_frame.frame.origin.y, imv_frame.frame.size.width, 44 + CELL_HIGH_DEFAULT*count)];
                    
                     
                     */
                     [viewfacebook setFrame:CGRectMake(viewfacebook.frame.origin.x, 170 + CELL_HIGH_DEFAULT*count, viewfacebook.frame.size.width, viewfacebook.frame.size.height)];
                    [btRecommend setFrame:CGRectMake(btRecommend.frame.origin.x, 235 + CELL_HIGH_DEFAULT*count, btRecommend.frame.size.width, btRecommend.frame.size.height)];
                   
                }
                if (count >1) {
                    [scrollViewMain setContentSize:CGSizeMake(320, 450)];

                }
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrData.count-1) inSection:0];

                [tbvResult scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
            }
            
            
            
        }
            break;
            
            case FriendCellActionTabMinus:
        {
            [self.arrData removeObject:anObj];
            
                        CGFloat CELL_HIGH_DEFAULT = 44;
            
            int count = _arrData.count -1;
            
            if (count < 3) {
                
                [viewFriends setFrame:CGRectMake(viewFriends.frame.origin.x, viewFriends.frame.origin.y, viewFriends.frame.size.width,54 + CELL_HIGH_DEFAULT*count)];
                /*
                [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width,44 + CELL_HIGH_DEFAULT*count)];
                [imv_frame setFrame:CGRectMake(imv_frame.frame.origin.x, imv_frame.frame.origin.y, imv_frame.frame.size.width, 54 + CELL_HIGH_DEFAULT*count)];
                 */
                [viewfacebook setFrame:CGRectMake(viewfacebook.frame.origin.x, 170 + CELL_HIGH_DEFAULT*count, viewfacebook.frame.size.width, viewfacebook.frame.size.height)];
                [btRecommend setFrame:CGRectMake(btRecommend.frame.origin.x, 235 + CELL_HIGH_DEFAULT*count, btRecommend.frame.size.width, btRecommend.frame.size.height)];
            }
            if (count <= 1) {
                [scrollViewMain setContentSize:CGSizeMake(320, 420)];
                
            }
            
            [tbvResult reloadData];

        }
            break;
            
        default:
            break;
    }
}

#pragma mark - CFacebookDelegate

- (void) cFacebook:(CFacebook *)aCFacebook didFinish:(id)anObj tagAction:(int)aTag
{
    debug(@"AskRecommendationsVC -> cFacebookDidFinish tag -> %d",aTag);
    switch (aTag) {
        case CFacebookTagActionError:
        {
            debug(@"AskRecommendationsVC -> CFacebookTagActionError");
            
        }
            break;
            
        case CFacebookTagActionGetUserInfo:
        {
            userDefault.loginStatus = LoginViaFacebook;
            UserObj *userObj = (UserObj *) anObj;
            userObj.city = userDefault.city;
            userObj.state = userDefault.state;
            userDefault.user = userObj;
            [UserDefault update];
            
            ConfigProfileVC *vc = [[ConfigProfileVC alloc] initWithNibName:@"ConfigProfileVC" bundle:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
            
        case CFacebookTagActionGetFriendsInfo:
        {
            userDefault.loginStatus = LoginViaFacebook;       
            
            
            ConfigProfileVC *vc = [[ConfigProfileVC alloc] initWithNibName:@"ConfigProfileVC" bundle:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark RequestData
-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    if (key == 1) {
        NSDictionary* dic = [response objectFromJSONString];
        NSString* questionAsk = [dic objectForKey:@"valueNameValue"];
        NSString* cuisine = @"";
        int count = 0;
        
//        CRequest* request = [[CRequest alloc]initWithURL:@"recosearch" RQType:RequestTypePost RQData:RequestDataAsk RQCategory:ApplicationForm withKey:2];
//        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        
        for (TSGlobalObj* global in _arrayData) {
            
            
            if (count == 0) {
                cuisine = global.name;
            }
            else
            {
                cuisine = [cuisine stringByAppendingFormat:@", %@", global.name];
            }
            count++;
        }
        questionAsk = [questionAsk stringByReplacingOccurrencesOfString:@"<cuisine>" withString:cuisine];
        questionAsk = [questionAsk stringByReplacingOccurrencesOfString:@"<location>" withString:_location.name];
        _askSentences = questionAsk;
        tfAsk.text = _askSentences;
        askContentLabel.text = questionAsk;
        
        [self onProgressBtnPressed];
    }
    if (key == 2) {
        
    }
}

-(IBAction)hideAction:(id)sender
{
    _viewAction.hidden = YES;
    _viewProgress.hidden = NO;
}

#pragma mark CustomAnimation
- (void)didFinishAnimation:(CustomProgressView*)progressView
{
    [progressView removeFromSuperview];
    action3.hidden = YES;
    action4.hidden = NO;
    _submitButton.hidden = NO;
    _submitButtonImage.hidden = NO;
    
    [self performSelector:@selector(showTickMark) withObject:nil afterDelay:0.5];
    
}

-(void)showTickMark
{
    tickMark.hidden = NO;
}

- (void)onProgressBtnPressed
{
    customProgressView = [[CustomProgressView alloc] init];
    customProgressView.delegate = self;
    [self.view addSubview:customProgressView];
    
    //change here

    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.2] afterDelay:0.0];
//    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.66] afterDelay:2.0];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:5.0];

    
//    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.33] afterDelay:1.0];
//    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0.66] afterDelay:2.0];
//    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:3.0];


}

-(void)setProgress:(NSNumber*)value
{
    [customProgressView performSelectorOnMainThread:@selector(setProgress:) withObject:value
                                      waitUntilDone:NO];
}
- (void)didFinishForNumber:(CustomProgressView *)progressView ForPath:(NSNumber *)number
{
    if ([number floatValue] >0 && [number floatValue] < 1) {
        action1.hidden = NO;
    }
    
    if ([number floatValue] == 1.0) {
                action1.hidden = YES;
        
            }

    
    
    
    
//    {
//        if ([number floatValue] >0.3 && [number floatValue] < 0.4) {
//            action1.hidden = NO;
//        }
    
    
//    if ([number floatValue] > 0.6 && [number floatValue] < 0.7 ) {
//        action1.hidden = YES;
//        action2.hidden = NO;
//    }
//    if ([number floatValue] == 1.0) {
//        action2.hidden = YES;
//        action3.hidden = NO;
//        
//    }
}
@end
