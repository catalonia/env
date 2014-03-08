//
//  ConfigProfileVC.m
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ConfigProfileVC.h"
#import "FriendFilterCell.h"
#import "CommonHelpers.h"
#import "JSONKit.h"
#import "TSGlobalObj.h"

#define viewInfoHeigh 52

@interface ConfigProfileVC ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UserDefault *userDefault;
    int textFieldSelected ;
    BOOL keypadShown;
    
    //NSString* restaurantVariable;
    
    CGPoint offset;
    
    CGFloat TBV_POINT_Y ;
    
    UserObj* inviteUserObj;
    TSGlobalObj* cuisineObj;
    
    NSMutableArray* arrayRestaurant1;
    NSMutableArray* arrayRestaurant2;
    NSMutableArray* arrayRestaurant3;
    
    NSMutableArray* variableRestaurant;
}


typedef enum _TextFieldSelect
{
    TextFieldFriend  = 6,
    TextFieldCusine     =   7,
    TextFieldRestaurant1 =   1,
    TextFieldRestaurant2 =   2,
    TextFieldRestaurant3 =   3,
    TextFieldRestaurant4 =   4,
    TextFieldRestaurant5 =   5
    
} TextFieldSelect;

@end



@implementation ConfigProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableArray* arrayUser = [[NSMutableArray alloc] initWithArray:[CommonHelpers appDelegate].arrDataFBFriends];
    
    if (arrayUser.count == 0) {
        //imageProfile.frame = CGRectMake(imageProfile.frame.origin.x, imageProfile.frame.origin.y, imageProfile.frame.size.width, viewInfoHeigh);
        [lbInfo removeFromSuperview];
        viewUserInfo.frame = CGRectMake(viewUserInfo.frame.origin.x, viewUserInfo.frame.origin.y, viewUserInfo.frame.size.width, viewInfoHeigh);
        viewMain.frame = CGRectMake(viewMain.frame.origin.x, viewMain.frame.origin.y - 48, viewMain.frame.size.width, viewMain.frame.size.height);
        
    }
    else if (arrayUser.count > 3) {
        UserObj* obj1 = [arrayUser objectAtIndex:0];
        UserObj* obj2 = [arrayUser objectAtIndex:1];
        UserObj* obj3 = [arrayUser objectAtIndex:2];
        
        
        lbInfo.text = [NSString stringWithFormat:@"%@, %@, %@ and %d other friends already use TasteSync", obj1.name, obj2.name, obj3.name, [arrayUser count] - 3];
    }
    else
    {
        int i = 0;
        NSString* list;
        for (UserObj* obj in arrayUser) {
            if (i == 0)
                list = obj.name;
            else
                list = [list stringByAppendingString:[NSString stringWithFormat:@", %@",obj.name]];
            i++;
        }
        lbInfo.text = [NSString stringWithFormat:@"%@ already use TasteSync", list];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CommonHelpers setBackgroudImageForView:self.view];

    [self initUI];
   
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI

{
    [scrollViewMain setContentSize:CGSizeMake(320, 800)];
    
    ivAvatarFriend.image = nil;
  
}
- (void) initData
{
    
    arrayRestaurant1 = [[NSMutableArray alloc]init];
    arrayRestaurant2 = [[NSMutableArray alloc]init];
    arrayRestaurant3 = [[NSMutableArray alloc]init];
    
    variableRestaurant = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"", nil];
    
    userDefault = [UserDefault userDefault];
    if (_arrData == nil) {
        self.arrData = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            TSGlobalObj* global = [[TSGlobalObj alloc]init];
            global.uid = @"";
            global.name = @"";
            [self.arrData addObject:global];
        }
        
    }
    if (_arrDataCusine == nil) {
        self.arrDataCusine = [[NSMutableArray alloc] init ];
        self.arrDataCusine = [[CommonHelpers appDelegate] arrDropdown];
    }
    
    if (_arrDataFriends == nil) {
        self.arrDataFriends = [[NSMutableArray alloc] init ];
         self.arrDataFriends = [[CommonHelpers appDelegate] arrDataFBFriends];
    }
    
    if (_arrDataFilter == nil) {
        self.arrDataFilter = [[NSMutableArray alloc] init ];
    }
    
    
    UserObj *userObj = userDefault.user;
    if (userObj != nil) {
        lbName.text = [NSString stringWithFormat:@"%@ %@", userObj.firstname, userObj.lastname];
        ivAvatar.image = userObj.avatar;

    }
    if ((userDefault.city != nil) && (userDefault.state != nil)) {
        lbLocation.text = [NSString stringWithFormat:@"%@, %@",userObj.hometown_location, userObj.location];
    }
    
   
    
    debug(@"ConfigProfile -> arrDataFriends -> count = %d", _arrDataFriends.count);
    
}
    
#pragma mark - IBAction's define

- (IBAction)actionDone:(id)sender
{
    
    NSMutableDictionary *nameElements = [NSMutableDictionary dictionary];
    [nameElements setObject:[UserDefault userDefault].userID forKey:@"userId"];

    if (inviteUserObj != nil) {
        [nameElements setObject:inviteUserObj.uid forKey:@"facebookFriendId"];
        NSLog(@"userName: %@, userID: %@", inviteUserObj.name, inviteUserObj.uid);
    }
    if (cuisineObj != nil) {
        [nameElements setObject:cuisineObj.uid forKey:@"cuisineId"];
        NSLog(@"cuisinName: %@, cuisinID: %@", cuisineObj.name, cuisineObj.uid);
    }
    
    NSMutableArray* arrayRest = [[NSMutableArray alloc]init];
    for (TSGlobalObj* global in _arrData) {
        if (![global.uid isEqualToString:@""]) {
            [arrayRest addObject:global.uid];
            NSLog(@"globalName: %@, globalID: %@", global.name, global.uid);
        }
        
    }
    [nameElements setObject:arrayRest forKey:@"restaurandId"];
    
    
    NSString* jsonString = [nameElements JSONString];
    NSLog(@"%@",jsonString);
    
    
    if (cuisineObj != nil && arrayRest.count >= 3 ) {
        CRequest* request = [[CRequest alloc]initWithURL:@"submitSignupDetail" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationJson withKey:10  WithView:self.view];
        [request setHeader:HeaderTypeJSON];
        request.delegate = self;
        [request setJSON:jsonString];
        [request startRequest];
    }
    else
    {
        if (cuisineObj == nil && arrayRest.count == 0) {
            [CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:@"You forgot to enter the cuisine and favorite restaurants" delegate:nil tag:0];
        }
        else if (cuisineObj == nil) {
            [CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:@"You forgot to enter the cuisine" delegate:nil tag:0];
        }
        else {
            [CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:@"You forgot to enter the favorite restaurants" delegate:nil tag:0];
        }
    }
    
}

- (IBAction)actionInvite:(id)sender;
{
    
    [btInvite setTitle:@"Invited" forState:UIControlStateNormal];
    btInvite.enabled = NO;
    
}

- (IBAction)actionHideKeyPad:(id)sender
{
    [self hideKeyBoard];
}



#pragma mark - UITableView


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
    if (textFieldSelected != TextFieldFriend) {
        static NSString *CellIndentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        UserObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        
        cell.textLabel.text = obj.name;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        //        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
        cell.backgroundColor = [UIColor blackColor];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     debug(@"tableView -> didSelectRowAtIndexPath -> TextFieldSelected = %d", textFieldSelected);
    
    switch (textFieldSelected) {
        case TextFieldFriend:
        {
           
            UserObj *userObj = [_arrDataFilter objectAtIndex:indexPath.row];
            ivAvatarFriend.image = userObj.avatar;
            inviteUserObj = userObj;
            //check here
            
            if (2 % 2) {
                btInvite.hidden = NO;
                btCheck.hidden = YES;
                
                [btInvite setTitle:@"Invite" forState:UIControlStateNormal];
                btInvite.enabled = YES;
            }
            else
            {
                btInvite.hidden = YES;
                btCheck.hidden = NO;

            }
            [self hideKeyBoard];
            
        }
            break;
            
        case TextFieldCusine:
        {
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];            
            tfCusine.text = global.name;
            cuisineObj = global;
            [tfCusine endEditing:YES];
            [self hideKeyBoard];
        }
            break;
            
        case TextFieldRestaurant1:
        {
            
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];
            tfRestaurant1.text = global.name;
            [self.arrData replaceObjectAtIndex:0 withObject:global];
            [tfRestaurant1 endEditing:YES];
            [self hideKeyBoard];
        }
            break;
        case TextFieldRestaurant2:
        {
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];
            tfRestaurant2.text = global.name;
            [self.arrData replaceObjectAtIndex:1 withObject:global];
            [tfRestaurant2 endEditing:YES];
            [self hideKeyBoard];
        }
            break;
        case TextFieldRestaurant3:
        {
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];
            tfRestaurant3.text = global.name;
            [self.arrData replaceObjectAtIndex:2 withObject:global];
            [tfRestaurant3 endEditing:YES];
            [self hideKeyBoard];
        }
            break;
        case TextFieldRestaurant4:
        {
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];
            [self.arrData replaceObjectAtIndex:3 withObject:global];
            [self hideKeyBoard];
        }
            break;
        case TextFieldRestaurant5:
        {
            TSGlobalObj *global = [_arrDataFilter objectAtIndex:indexPath.row];
            [self.arrData replaceObjectAtIndex:4 withObject:global];
            [self hideKeyBoard];
        }
            break;
        default:
            break;
    }
    
    tbvFilter.hidden = YES;
//    [self hideKeyBoard];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = @"";
    ivAvatarFriend.image = nil;
    btInvite.hidden = YES;
    btCheck.hidden = YES;
    tbvFilter.hidden = YES;
    
    keypadShown = TRUE;
    
    if (textField == tfCusine)
    {
        textFieldSelected = TextFieldCusine;
        TBV_POINT_Y = 250;
        cuisineObj = nil;

    }
    else if (textField == tfRestaurant1)
    {
        textFieldSelected = TextFieldRestaurant1;
        TBV_POINT_Y = 340;
        
        TSGlobalObj* global = [[TSGlobalObj alloc]init];
        global.uid = @"";
        global.name = @"";
        [self.arrData replaceObjectAtIndex:0 withObject:global];
        [variableRestaurant replaceObjectAtIndex:0 withObject:@""];
    }
    else if (textField == tfRestaurant2)
    {
        textFieldSelected = TextFieldRestaurant2;
        TBV_POINT_Y = 400;
        
        TSGlobalObj* global = [[TSGlobalObj alloc]init];
        global.uid = @"";
        global.name = @"";
        [self.arrData replaceObjectAtIndex:1 withObject:global];
        [variableRestaurant replaceObjectAtIndex:1 withObject:@""];
    }
    else if (textField == tfRestaurant3)
    {
        textFieldSelected = TextFieldRestaurant3;
        TBV_POINT_Y = 460;
        
        TSGlobalObj* global = [[TSGlobalObj alloc]init];
        global.uid = @"";
        global.name = @"";
        [self.arrData replaceObjectAtIndex:2 withObject:global];
        [variableRestaurant replaceObjectAtIndex:2 withObject:@""];
    }
   
    else
    {
        
    }
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,-TBV_POINT_Y + 30 + 130,viewMain.frame.size.width, viewMain.frame.size.height);
                         viewUserInfo.frame = CGRectMake(viewUserInfo.frame.origin.x,- TBV_POINT_Y + 30 - 119,viewUserInfo.frame.size.width, viewUserInfo.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
//                         [self searchLocal:@""];
                         
                     }];
    
    [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x,TBV_POINT_Y - 130, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    //    [self onClickLookup:nil];
    [self hideKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    
    NSString* searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    double delayInSeconds = TIMER_DELAY;
    dispatch_time_t popTimer = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC);
    dispatch_after(popTimer, dispatch_get_main_queue(), ^(void){
        NSString* text;
        if (textField == tfCusine) {
            text = tfCusine.text;
        }
        if (textField == tfRestaurant1) {
            text = tfRestaurant1.text;
        }
        if (textField == tfRestaurant2) {
            text = tfRestaurant2.text;
        }
        if (textField == tfRestaurant3) {
            text = tfRestaurant3.text;
        }
        if ([searchText isEqualToString:text]) {
            [self searchLocal:searchText];
        }
        //[NSThread detachNewThreadSelector:@selector(thread:) toTarget:self withObject:searchText];
    });
        
    return TRUE;
    
}

# pragma mark - Others


- (void) searchLocal:(NSString *)txt
{
    
    
    tbvFilter.hidden = YES;
    btInvite.hidden = YES;
    //[self.arrDataFilter removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    
    NSMutableArray *arrTmp = [[NSMutableArray alloc] init];

    
    switch (textFieldSelected) {
        case TextFieldFriend:
        {
                        
            for (UserObj *userObj in self.arrDataFriends) {
                NSString *firstName = [userObj.firstname uppercaseString];
                NSString *uTxt = [txt uppercaseString];
                int diff = strncmp([firstName UTF8String], [uTxt UTF8String], uTxt.length);              
                
                if (diff == 0) {
                    debug(@"TextFieldCusine added");
                    
                    [arrTmp addObject:userObj];
                }
                
            }
            
            for (UserObj *userObj in self.arrDataFriends) {
                NSString *lastName = [userObj.lastname uppercaseString];
                NSString *uTxt = [txt uppercaseString];
                int diff = strncmp([lastName UTF8String], [uTxt UTF8String], uTxt.length);
                
                if (diff == 0) {
                    debug(@"TextFieldCusine added");
                    if (![arrTmp containsObject:userObj]) {
                        [arrTmp addObject:userObj];

                    }
                }
                
            }
            
        }
            break;
        case TextFieldCusine:
        {
            for (TSGlobalObj *globalObj in _arrDataCusine) {
                
                NSString* strObj = globalObj.name;
                NSString  *ustrObj =  [strObj uppercaseString];
                NSString *utxt =   [txt uppercaseString];
                
                debug(@"ustrObj -  utxt  -> %@ - %@ ",ustrObj,utxt);
                
                int diff = strncmp([ustrObj UTF8String], [utxt UTF8String], utxt.length);
                                
                
                if (/*p!=NULL*/ diff == 0) {
                    debug(@"TextFieldCusine added");

                    [arrTmp addObject:globalObj];
                }
            }
        }
            break;
        case 0:
        {
            // is default
        }
            
        default:
        {
            // case restaurant
            
            NSMutableArray* arrayRestaurant;
            
            if (textFieldSelected == TextFieldRestaurant1) {
                arrayRestaurant = [[NSMutableArray alloc]initWithArray:arrayRestaurant1];
            }
            if (textFieldSelected == TextFieldRestaurant2) {
                arrayRestaurant = [[NSMutableArray alloc]initWithArray:arrayRestaurant2];
            }
            if (textFieldSelected == TextFieldRestaurant3) {
                arrayRestaurant = [[NSMutableArray alloc]initWithArray:arrayRestaurant3];
            }
            NSLog(@"%@",txt);
            // && ![[txt uppercaseString] isEqualToString:[variableRestaurant objectAtIndex:(textFieldSelected - 1)]]
            if (txt.length >= 1) {
                //if (txt.length == 1) {
                        
//                        CRequest* request = [[CRequest alloc]initWithURL:@"showRestaurantSuggestion" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:textFieldSelected];
//                        request.delegate = self;
//                        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
//                        [request setFormPostValue:[txt uppercaseString] forKey:@"key"];
//                        [request startFormRequest];

                        TSGlobalObj* region = [CommonHelpers getDefaultCityObj];
                        
                        CRequest* request = [[CRequest alloc]initWithURL:@"suggestrestaurantnames" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:textFieldSelected WithView:self.view];
                        request.delegate = self;
                        [request setFormPostValue:txt forKey:@"key"];
                        [request setFormPostValue:region.cityObj.uid forKey:@"cityid"];
                        [request startFormRequest];
                        
                        NSLog(@"request here Value: %@ of Index: %d", [txt uppercaseString], textFieldSelected);
                        [variableRestaurant replaceObjectAtIndex:(textFieldSelected - 1) withObject:[txt uppercaseString]];
                }
                else
                {
                    for (TSGlobalObj *restObj in arrayRestaurant) {
                        
                        NSString* strObj = restObj.name;
                        
                        NSString  *ustrObj =  [strObj uppercaseString];
                        NSString *utxt =   [txt uppercaseString];
                        
                        int diff = strncmp([ustrObj UTF8String], [utxt UTF8String], utxt.length);
                        
                        debug(@"ustrObj -  utxt restaurent  -> %@ - %@ ",ustrObj,utxt);
                        
                        if ( diff == 0 ) {
                            debug(@"added");
                            [arrTmp addObject:restObj];
                        }
                    }
                    debug(@"%d",arrayRestaurant.count);
//                    NSMutableArray* arrayStore = [[NSMutableArray alloc]init];
//                    for (TSGlobalObj *global in _arrData) {
//                        for (int i = 0; i < arrTmp.count; i++) {
//                            TSGlobalObj* gl = [arrTmp objectAtIndex:i];
//                            if ([gl.name isEqualToString:global.name]) {
//                                [arrayStore addObject:gl];
//                            }
//                        }
//                    }
//                    for (TSGlobalObj* global in arrayStore) {
//                        [arrTmp removeObject:global];
//                    }
                    
                    self.arrDataFilter = [[NSMutableArray alloc]initWithArray:arrTmp];
                    tbvFilter.hidden = NO;
                    [tbvFilter reloadData];
                }
            }
            
        
        break;
    }
   
    if (textFieldSelected == TextFieldCusine || textFieldSelected == TextFieldFriend) {
        self.arrDataFilter = [[NSMutableArray alloc]initWithArray:arrTmp];
        
        if (self.arrDataFilter.count>0) {
            tbvFilter.hidden = NO;
            CGRect frame = tbvFilter.frame;
            if (self.arrDataFilter.count>5) {
                frame.size.height = 5*44;
                
            }
            else{
                frame.size.height = (_arrDataFilter.count) *44;
                
            }
            [tbvFilter setFrame:frame];
            [tbvFilter reloadData];
        }
    }
    
    
    
}


#pragma mark - Other's function

- (void) hideKeyBoard
{
    debug(@"hidekeyBoard");
    /*
    if (!keypadShown) {
        tbvFilter.hidden = YES;
    }
*/
    
    tbvFilter.hidden = YES;
    
    keypadShown = FALSE ;
    
    [tfCusine resignFirstResponder];
    [tfRestaurant1 resignFirstResponder];
    [tfRestaurant2 resignFirstResponder];
    [tfRestaurant3 resignFirstResponder];
    
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         if (viewUserInfo.frame.size.height == viewInfoHeigh) {
                             viewMain.frame = CGRectMake(viewMain.frame.origin.x, 71 ,viewMain.frame.size.width, viewMain.frame.size.height);
                             viewUserInfo.frame = CGRectMake(viewUserInfo.frame.origin.x,11,viewUserInfo.frame.size.width, viewUserInfo.frame.size.height);
                         }
                         else
                         {
                             viewMain.frame = CGRectMake(viewMain.frame.origin.x, 119 ,viewMain.frame.size.width, viewMain.frame.size.height);
                             viewUserInfo.frame = CGRectMake(viewUserInfo.frame.origin.x,11,viewUserInfo.frame.size.width, viewUserInfo.frame.size.height);
                         }
                         
                     }
                     completion:^(BOOL finished){
                         debug(@"hideKeyBoard move done");

                         [scrollViewMain setContentOffset:offset];
                     }];
}

#pragma mark - UIScrollViewDelegate
/*
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    offset = scrollView.contentOffset;
    debug(@"ConfigProfile ->scrollViewDidEndScrollingAnimation with offset(%f,%f)",offset.x, offset.y);
}
 
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (keypadShown) {
        return;
    }
    offset = scrollView.contentOffset;
    debug(@"ConfigProfile ->scrollViewDidEndScrollingAnimation with offset(%f,%f)",offset.x, offset.y);

}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 15) {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
        
        for (NSDictionary* dic in arrayFriend) {
            UserObj* userObject = [[UserObj alloc]init];
            userObject.uid = [dic objectForKey:@"userId"];
            userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
            userObject.avatarUrl = [dic objectForKey:@"photo"];
            [[CommonHelpers appDelegate].arrDataFBFriends addObject:userObject];
        }
    }
    if (key == 16)
    {
        NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSString* userLogID = [dic objectForKey:@"successMsg"];
        [UserDefault userDefault].userLogID = userLogID;
        [UserDefault update];
    }
    
    if(key == 11)
    {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSDictionary* dic = [response objectFromJSONString];
        NSArray* array = [dic objectForKey:@"friendTasteSync"];
        NSMutableArray* arrayUser = [[NSMutableArray alloc]init];
        for (NSDictionary* dic in array) {
            [arrayUser addObject:[NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]]];
        }
    }
    else if (key != 10) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
        NSArray* arrayRestaurant = [response objectFromJSONString];
        if (key == TextFieldRestaurant1) {
            [arrayRestaurant1 removeAllObjects];
        }
        if (key == TextFieldRestaurant2) {
            [arrayRestaurant2 removeAllObjects];
        }
        if (key == TextFieldRestaurant3) {
            [arrayRestaurant3 removeAllObjects];
        }
        for (NSDictionary* dic in arrayRestaurant) {
            TSGlobalObj* restObj = [[TSGlobalObj alloc]init];
            restObj.uid = [dic objectForKey:@"restaurantId"];
            restObj.name = [dic objectForKey:@"restaurantName"];
            if (key == TextFieldRestaurant1) {
                [arrayRestaurant1 addObject:restObj];
            }
            if (key == TextFieldRestaurant2) {
                [arrayRestaurant2 addObject:restObj];
            }
            if (key == TextFieldRestaurant3) {
                [arrayRestaurant3 addObject:restObj];
            }
        }
        
        NSMutableArray* arrTmp = [[NSMutableArray alloc]init];
        if (key == TextFieldRestaurant1) {
            arrTmp = [[NSMutableArray alloc]initWithArray:arrayRestaurant1];
        }
        if (key == TextFieldRestaurant2) {
            arrTmp = [[NSMutableArray alloc]initWithArray:arrayRestaurant2];
        }
        if (key == TextFieldRestaurant3) {
            arrTmp = [[NSMutableArray alloc]initWithArray:arrayRestaurant3];
        }
        
        NSMutableArray* arrayStore = [[NSMutableArray alloc]init];
        for (TSGlobalObj *global in _arrData) {
            for (int i = 0; i < arrTmp.count; i++) {
                TSGlobalObj* gl = [arrTmp objectAtIndex:i];
                if ([gl.name isEqualToString:global.name]) {
                    [arrayStore addObject:gl];
                }
            }
        }
        for (TSGlobalObj* global in arrayStore) {
            [arrTmp removeObject:global];
        }
        
        self.arrDataFilter = [[NSMutableArray alloc]initWithArray:arrTmp];
        
        if (self.arrDataFilter.count>0) {
            tbvFilter.hidden = NO;
            CGRect frame = tbvFilter.frame;
            if (self.arrDataFilter.count>5) {
                frame.size.height = 5*44;
                
            }
            else{
                frame.size.height = (_arrDataFilter.count) *44;
                
            }
            [tbvFilter setFrame:frame];
            [tbvFilter reloadData];
        }
    }
    else
    {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary* dic = [response objectFromJSONString];
        if ([dic objectForKey:@"successMsg"] != nil) {
            [[CommonHelpers appDelegate] showAskTab];
        }
        else
        {
            [CommonHelpers showConfirmAlertWithTitle:@"TasteSync" message:@"Error! Your data incorrect!" delegate:nil tag:0];
        }
    }
}
@end
