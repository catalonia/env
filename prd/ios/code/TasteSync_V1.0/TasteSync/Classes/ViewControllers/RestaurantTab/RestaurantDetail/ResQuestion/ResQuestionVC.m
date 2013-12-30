//
//  ResQuestionVC.m
//  TasteSync
//
//  Created by Victor on 1/4/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResQuestionVC.h"
#import "FriendCell.h"
#import "CommonHelpers.h"
#import "FriendFilterCell.h"

@interface ResQuestionVC ()<UITableViewDataSource,UITableViewDelegate,FriendCellDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UIView *view1,*view2,*view3,*view4, *viewMain;
    __weak IBOutlet UITableView *tbvResult,*tbvFilter, *tbvFriend;
    __weak IBOutlet UITextField *tfQuestion, *cTextField;
    __weak IBOutlet UIButton *btcheck1,*btcheck2;
    __weak IBOutlet UILabel *lbName, *lbHolver;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UIScrollView *scrollViewMain;
    
    BOOL check1,check2;
    BOOL isHaveUser;
    NSString *askString;
    NSMutableArray* _arrayUserTasteSync;
    NSMutableArray* _arrayUserSend;
    NSMutableArray* _arrayUserChecked;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionCheck2:(id)sender;
- (IBAction)actionSendMessage:(id)sender;
- (IBAction)actionAvatar:(id)sender;

@end

@implementation ResQuestionVC

@synthesize arrData=_arrData,
arrDataFilter=_arrDataFilter,
arrDataFriends=_arrDataFriends,
restaurantObj=_restaurantObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRestaurantObj:(RestaurantObj*)obj
{
    self = [super initWithNibName:@"ResQuestionVC" bundle:nil];
    if (self) {
        self.restaurantObj = obj;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CRequest* request = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
    [request startFormRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [CommonHelpers setBackgroudImageForViewRestaurant:self.view];
    scrollViewMain.contentSize = CGSizeMake(320, 550);
    _arrayUserTasteSync = [[NSMutableArray alloc]init];
    _arrayUserSend = [[NSMutableArray alloc]init];
    _arrayUserChecked = [[NSMutableArray alloc]init];
    
    NSString* link = [NSString stringWithFormat:@"askdetails?userid=%@&restaurantid=%@",[UserDefault userDefault].userID, self.restaurantObj.uid];
    CRequest* request2 = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:3 WithView:self.view];
    request2.delegate = self;
    [request2 startFormRequest];
    
    if (!self.arrDataFriends) {
        self.arrDataFriends = [[NSMutableArray alloc] init];
        self.arrDataFriends = [CommonHelpers appDelegate].arrDataFBFriends;
    }
    
    self.arrDataFilter = [[NSMutableArray alloc] init];

    UserObj *obj = [[UserObj alloc] init];
    
    self.arrData = [[NSMutableArray alloc] initWithObjects:obj, nil];
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
    [CommonHelpers showShareView:nil andObj:_restaurantObj];

}

- (IBAction)actionHideKeyPad:(id)sender
{
    [self hideKeyBoard];
}
- (IBAction)actionCheck2:(id)sender
{
    if (check2) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check.png"] forButton:btcheck2];
        check2 = FALSE;
        
    }
    else {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_check_on.png"] forButton:btcheck2];
        check2 = TRUE;
        
    }
}
- (IBAction)actionSendMessage:(id)sender
{
    NSString* friendsfacebookidlist = @"";
    NSLog(@"Count: %d", [_arrayUserTasteSync count]);
    for (UserObj* obj in _arrData) {
        if (obj.uid != nil) {
            if ([self checkID:obj.uid]) {
                
                NSLog(@"1. Send message facebook: %@", obj.uid);
                
//                CRequest* request = [[CRequest alloc]initWithURL:@"sendMessageToUser" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:2];
//                request.delegate = self;
//                [request setFormPostValue:[UserDefault userDefault].userID forKey:@"senderID"];
//                [request setFormPostValue:@"ID" forKey:@"recipientID"];
//                [request setFormPostValue:tfQuestion.text forKey:@"content"];
//                [request startFormRequest];
//                NSLog(@"Send message: %@", obj.uid);
            }
            else
            {
                CFacebook* facebook = [[CFacebook alloc]init];
                [facebook sendMessageToFBID:obj.uid Message:tfQuestion.text];
                NSLog(@"2. Send message facebook: %@", obj.uid);
            }
            if (friendsfacebookidlist.length == 0)
            {
                NSString* str = [NSString stringWithFormat:@"%@", obj.uid];
                friendsfacebookidlist = str;
            }
            else
            {
                NSString* str = [NSString stringWithFormat:@"%@", obj.uid];
                friendsfacebookidlist = [friendsfacebookidlist stringByAppendingFormat:@",%@", str];
            }
        }
    }
  
    NSLog(@"friendsfacebookidlist: %@",  friendsfacebookidlist);
    
    NSString* recommendersuseridlist = @"";
    
    for (UserObj* obj in _arrayUserChecked) {
        if (recommendersuseridlist.length == 0)
        {
            NSString* str = [NSString stringWithFormat:@"%@", obj.uid];
            recommendersuseridlist = str;
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"%@", obj.uid];
            recommendersuseridlist = [recommendersuseridlist stringByAppendingFormat:@",%@", str];
        }
    }
    
    NSLog(@"recommendersuseridlist: %@",  recommendersuseridlist);
    
    NSString* postFlag = @"";
    if (check2) 
        postFlag = @"1";
    else
        postFlag = @"0";
    
    if (tfQuestion.text.length != 0 && (friendsfacebookidlist.length != 0 || recommendersuseridlist.length != 0)){
        CRequest* request = [[CRequest alloc]initWithURL:@"askquestion" RQType:RequestTypePost RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:2 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
        [request setFormPostValue:self.restaurantObj.uid forKey:@"restaurantid"];
        [request setFormPostValue:tfQuestion.text forKey:@"questiontext"];
        [request setFormPostValue:postFlag forKey:@"postquestiononforum"];
        [request setFormPostValue:recommendersuseridlist forKey:@"recommendersuseridlist"];
        [request setFormPostValue:friendsfacebookidlist forKey:@"friendsfacebookidlist"];
        [request startFormRequest];
    }
    
}

- (BOOL) checkID:(NSString*)uid
{
    for (UserObj* obj in _arrayUserTasteSync) {
        NSString* str1 = [NSString stringWithFormat:@"%@", obj.uid];
        NSString* str2 = [NSString stringWithFormat:@"%@", uid];
        if ([str1 isEqualToString:str2]) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)actionAvatar:(id)sender
{
    
  //  [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:userRecommended];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbvFriend) {
         return [_arrayUserSend count];
    }
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
    if (tableView == tbvFriend) {
        static NSString *CellIndentifier = @"RestaurantQuestionCell";
        
        RestaurantQuestionCell *cell = (RestaurantQuestionCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(RestaurantQuestionCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantQuestionCell" owner:self options:nil] objectAtIndex:0];
        }
        
        UserObj* obj = [_arrayUserSend objectAtIndex:indexPath.row];
        cell.name.text = obj.name;
        cell.imageLink = obj.avatarUrl;
        cell.userObj = obj;
        cell.delegate = self;
        return cell;
        
    }
    if (tableView==tbvResult) {
        static NSString *CellIndentifier = @"friend_cell";
        
        FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
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
            NSLog(@"cell is nil");
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
//        [self hideKeyBoard];
        
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    lbHolver.hidden = YES;
     return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [self hideKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
        CGRect frame = tbvFilter.frame;
        if (self.arrDataFilter.count>5) {
            frame.size.height = 5*44;
            
        }
        else{
            frame.size.height = (_arrDataFilter.count) *44;
            
        }
  
        tbvFilter.hidden = NO;
        [tbvFilter reloadData];
    }
    
    
}


- (void) hideKeyBoard
{
    if (tfQuestion.text.length == 0) {
        lbHolver.hidden = NO;
    }else
    {
        lbHolver.hidden = YES;
    }
    [cTextField resignFirstResponder];
    [tfQuestion resignFirstResponder];
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,20,viewMain.frame.size.width, viewMain.frame.size.height);
                         tbvFilter.hidden = YES;
                     }
                     completion:^(BOOL finished){
                         debug(@" hideKeyBoard -> move done");
                         
                     }];
     
     
    
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    tbvFilter.hidden = YES;
    [self hideKeyBoard];
}




# pragma mark - FriendCellDelegate

- (void) friendCell:(FriendCell *)friendCell shouldBeginEditingTextField:(UITextField *)aTextField option:(int) anOption
{
    NSIndexPath *indexPath = [tbvResult indexPathForCell:friendCell];
    
    cTextField = aTextField;
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
        
    }
    else
    {
        CGFloat POINT_Y = 0;
        CGRect frame= tbvFilter.frame;

        
        if (indexPath.row<2) {
            POINT_Y = (indexPath.row)*44;
        }
        else
        {
            POINT_Y = 70;
        }
        
        if (isHaveUser) 
            frame.origin.y = 290 + POINT_Y;
        else
            frame.origin.y = 150 + POINT_Y;
        
        
//        [scrollViewMain setContentOffset:CGPointMake(0, POINT_Y)];
        [tbvFilter setFrame:frame];
        
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             if (isHaveUser) {
                                 viewMain.frame=CGRectMake(viewMain.frame.origin.x,-POINT_Y-175,viewMain.frame.size.width, viewMain.frame.size.height);
                             }
                             else
                             {
                                 viewMain.frame=CGRectMake(viewMain.frame.origin.x,-POINT_Y-110,viewMain.frame.size.width, viewMain.frame.size.height);
                             }
                         }
                         completion:^(BOOL finished){
                             debug(@"move done");
                             //                             [self searchLocal:@""];
                             
                             
                         }];
         
         
        
    }

}
- (void) friendCell:(FriendCell *)friendCell didChangeTextFieldWithString:(NSString *) aString
{
    [self searchLocal:aString];
}

-(void) friendCell:(FriendCell *)friendCell didAction:(id)anObj tag:(int)aTag

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
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrData.count-1) inSection:0];
                [tbvResult scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
            }
            
            
            
        }
            break;
            
            case FriendCellActionTabMinus:
        {
            [self.arrData removeObject:anObj];
            [tbvResult reloadData];

            
        }
            break;
            
        default:
            break;
    }
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 1) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        for (NSDictionary* dic in arrayFriend) {
            UserObj *obj = [CommonHelpers getUserObj:dic];
            [_arrayUserTasteSync addObject:obj];
        }
    }
    if (key == 2) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (key == 3) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"recommendersDetailsList"];
        for (NSDictionary* dic2 in arrayFriend) {
            UserObj *obj = [[UserObj alloc]init];
            obj.uid = [dic2 objectForKey:@"userId"];
            obj.name = [dic2 objectForKey:@"name"];
            obj.avatarUrl = [dic2 objectForKey:@"photo"];
            [_arrayUserSend addObject:obj];
        }
        if ([_arrayUserSend count] == 0) {
            view2.hidden = YES;
            view3.hidden = YES;
            view4.frame = CGRectMake(view4.frame.origin.x, 77, view4.frame.size.width, view4.frame.size.height);
            isHaveUser = NO;
        }
        else
            isHaveUser =YES;
    }
}

-(void)checkStatus:(UserObj *)obj checked:(BOOL)isChecked
{
    if (isChecked) {
        [_arrayUserChecked addObject:obj];
    }
    else
    {
        [_arrayUserChecked removeObject:obj];
    }
}

@end
