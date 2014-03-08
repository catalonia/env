//
//  Step1VC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "Step1VC.h"
#import "User.h"
#import "FriendsCell.h"
#import "Step2VC.h"
#import "GlobalVariables.h"
#import "NaviBar1.h"
#import "UserDefault.h"
#import "CommonHelpers.h"
#import "FriendFilterCell.h"
#import "CFacebook.h"


@interface Step1VC ()<UITableViewDataSource,UITableViewDelegate,CFacebookDelegate>
{
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName,*lbLocation,*lbSub;
    __weak IBOutlet UITableView *tbvResult,*tbvFilter;
    __weak IBOutlet UIButton *btStep2;
    __weak IBOutlet UITextField *tfSearch;
    __weak IBOutlet UIView *viewFilter;
    CFacebook *facebook;
    UserDefault *userDefault;
    BOOL keypadShown;

}

- (IBAction)actionStep2:(id)sender;


@end

@implementation Step1VC
@synthesize arrData =_arrData,
arrDataFilter=_arrDataFilter,
arrDataFriends=_arrDataFriends,
userObj=_userObj;

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
    [CommonHelpers setBackgroudImageForView:self.view];    
    facebook = [[CFacebook alloc] init];
    userDefault = [UserDefault userDefault];
    self.arrData = [[NSMutableArray alloc] init];
    self.arrDataFriends = [[NSMutableArray alloc] init ];
    self.arrDataFilter = [[NSMutableArray alloc] init];
    

    
    if (userDefault.loginStatus == LoginViaFacebook) {
               
        [self getFBFriends];


        
    }else if(userDefault.loginStatus == LoginViaEmailId)
    {
        [self getEmailContacts];
    }
    else
    {
        
    }
    if (_userObj==nil) {
        CFacebook *cfacebook = [[CFacebook alloc] init];
        [cfacebook getUserInfo:self tagAction:CFacebookTagActionGetUserInfo];
    }else
    {
        [self initDataForView];

    }

    debug(@"_arrData.count -> %d",_arrData.count);
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NaviBar1 *naviBar1 = [[NaviBar1 alloc] initWithFrame:self.navigationController.navigationBar.frame];
    naviBar1.btnSkip.hidden= YES;
    [[self.navigationController.navigationBar superview ] addSubview:naviBar1];  
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Define

- (IBAction)actionStep2:(id)sender
{
    NSLog(@"actionStep2");
    Step2VC *step2VC = [[Step2VC alloc] initWithNibName:@"Step2VC" bundle:nil];
    step2VC.userObj = self.userObj;
    [self.navigationController pushViewController:step2VC animated:YES];
}

- (IBAction)actionInvite:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    NSLog(@"actionInvite with tag -> %d",btn.tag );

}

#pragma mark - Others

- (void) initDataForView
{
        
    lbName.text = [NSString stringWithFormat:@"%@ %@",self.userObj.firstname,self.userObj.lastname];
    if (self.userObj.city != nil && self.userObj.states !=nil) {
        lbLocation.text = [NSString stringWithFormat:@"%@, %@",self.userObj.city,self.userObj.states];
    }
    ivAvatar.image = self.userObj.avatar;
    if (userDefault.loginStatus == LoginViaFacebook) {
        lbSub.text = @"Paul G., Ron C., and 5 other friends";

    }

}

#pragma mark - UITableView


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
        static NSString *CellIndentifier = @"friends_cell";
        
        FriendsCell *cell = (FriendsCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            debug(@"cell is nil");
            cell =(FriendsCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendsCell" owner:self options:nil] objectAtIndex:0];
            
            //        cell = [[FriendsCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        User  *userObj = [self.arrData objectAtIndex:indexPath.row];
        
        [cell initForCell:userObj];
        
        return cell;
    }
    else
    {
        static NSString *CellIndentifier = @"friend_filter_cell";
        
        FriendFilterCell *cell = (FriendFilterCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            debug(@"cell is nil");
            cell =(FriendFilterCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendFilterCell" owner:self options:nil] objectAtIndex:0];
                        
        }
        
        [cell initForCell:[_arrDataFilter objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvFilter) {
        User *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        [self.arrData addObject:obj];
        [tbvResult reloadData];
        tbvFilter.hidden= YES;
//        tfSearch.text = nil;
        [self.arrDataFilter removeAllObjects];
        [self hideKeyBoard];

    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbvResult) {
        [self.arrData removeObject:[_arrData objectAtIndex:indexPath.row]];
        [tbvResult reloadData];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    keypadShown = TRUE;
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x,-100,self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         [self searchLocal:@""];
                         
                     }];
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    //    [self onClickLookup:nil];
    [self hideKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //    [tbvSearch reloadData];
    if (textField==tfSearch) {
        tbvFilter.hidden = YES;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfSearch) {
        [self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        
    }
    
    return TRUE;
    
}

# pragma mark - Others

- (void) getFBFriends
{
    debug(@"step1VC ->getFBFriends");
    [facebook getUserFriends:self tagAction:CFacebookTagActionGetFriendsInfo];
    
    
}

- (void) getEmailContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *arrContacts = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for (CFIndex i =0; i< CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef contacts = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j< ABMultiValueGetCount(contacts); j++) {
            NSString *email = (__bridge NSString *) ABMultiValueCopyValueAtIndex(contacts, j);
            User *user = [[User alloc] init];
            user.email = email;
            [arrContacts addObject:user];
            
            debug(@"email -> %@",email);
        }
      
        CFRelease(contacts);
        
    }

    debug(@"arrContacts -> count : %d", arrContacts.count);
    
    self.arrDataFriends = arrContacts;
    arrContacts = nil;



}

- (void) searchLocal:(NSString *)txt
{
    
    NSString *str;

    if (userDefault.loginStatus == LoginViaFacebook) {
        str = [NSString stringWithFormat:@"firstname MATCHES[cd] '.*%@.*'", [CommonHelpers trim:txt]];
    }
    else
    {
        str = [NSString stringWithFormat:@"email MATCHES[cd] '.*%@.*'", [CommonHelpers trim:txt]];

    }
    
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    NSArray *array = [self.arrDataFriends filteredArrayUsingPredicate:predicate];
    if(array)
    {
        self.arrDataFilter = [NSMutableArray arrayWithArray:array];
    }
    
    for (User *obj in _arrData) {
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
    keypadShown = false;
    
    [tfSearch resignFirstResponder];
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         
                     }];
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (keypadShown) {
        [self hideKeyBoard];
    }
    else
    {
        tbvFilter.hidden= YES;

    }
}

#pragma mark - Other



#pragma mark - CFacebookDelegate

- (void)cFacebook:(CFacebook *)aCFacebook didFinish:(id)anObj tagAction:(int)aTag
{
    debug(@"Step1VC -> cFacebookDidFinish with Tag -> %d",aTag);
    switch (aTag) {
            
        case CFacebookTagActionError:
        {
            debug(@"Step1 -> CFacebookTagActionError");
            
        }
            break;
        case CFacebookTagActionGetUserInfo:
        {
            userDefault.user = anObj;
            [UserDefault update];
            self.userObj = anObj;
            [self initDataForView];
            
        }
            break;
            
        case CFacebookTagActionGetFriendsInfo:
        {
            if ([anObj isKindOfClass:([NSMutableArray class])]) {
                self.arrDataFriends = anObj;
            }
            
        }
            break;
            
        default:
            break;
    }

}



@end
