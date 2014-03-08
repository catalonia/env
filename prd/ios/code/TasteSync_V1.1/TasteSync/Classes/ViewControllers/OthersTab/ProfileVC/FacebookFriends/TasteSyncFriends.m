//
//  TasteSyncFriends.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/24/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "TasteSyncFriends.h"
#import "CommonHelpers.h"
#import "ProfileVC.h"
#import "FriendFilterCell.h"
#import "FriendProfileCell.h"

@interface TasteSyncFriends ()
{
}
@end

@implementation TasteSyncFriends

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
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view from its nib.

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CRequest* request = [[CRequest alloc]initWithURL:@"showProfileFriends" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
    request.delegate = self;
    [request setFormPostValue:self.userID forKey:@"userId"];
    [request startFormRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    if (self.user != nil) {
        lbTitle.text = [NSString stringWithFormat:@"Friends on TasteSync"];
    }
}

- (void) initData
{
    self.arrData = [[NSMutableArray alloc] init ];
    
//    self.arrDataFriends = [[NSMutableArray alloc] init];
//    if ([[CommonHelpers appDelegate] arrDataFBFriends].count > 0) {
//        self.arrDataFriends = [[CommonHelpers appDelegate] arrDataFBFriends];
//    }
    
    self.arrDataFilter = [[NSMutableArray alloc] init];
}

#pragma mark- IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareProfile
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    if (tableView == tbvFilter) { // table friend TasteSync and facebook
        
       return _arrDataFilter.count;
    }
    else if (tbvResult == tableView)
    {
      
            return _arrData.count;

    }

    return 0;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // table search
    if (tableView == tbvFilter) { // table search
        static NSString *CellIndentifier = @"friend_filter_cell";
        
        FriendFilterCell *cell = (FriendFilterCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(FriendFilterCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendFilterCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        [cell initForCell:[_arrDataFilter objectAtIndex:indexPath.row]];
        
        
        return cell;
    }
    else if(tbvResult == tableView)
    {
        static NSString *CellIndentifier = @"friend_profile_cell";
        
        FriendProfileCell *cell = (FriendProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(FriendProfileCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendProfileCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        UserObj *obj= [_arrData objectAtIndex:indexPath.row];
              
        [cell initCell:obj];
        
        return cell;
    }
    else
    {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (tableView == tbvFilter) {
      
            tbvFilter.hidden = YES;
            [self hideKeyBoard];
            [[[CommonHelpers appDelegate ] tabbarBaseVC] actionProfile:[_arrDataFilter objectAtIndex:indexPath.row]];
        
    }
    else
    {
        [[[CommonHelpers appDelegate ] tabbarBaseVC] actionProfile:[_arrData objectAtIndex:indexPath.row]];

    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        
        [[CommonHelpers appDelegate] showLoginDialog];
        return NO;
    }
    else
    {
        textField.text = @"";

    }
    
    
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyBoard];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
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


- (void) searchLocal:(NSString *)txt
{
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    if (txt.length == 0) {
        return;
        
    }
    for (UserObj *userObj in self.arrData) {
        NSString *firstName = [userObj.firstname uppercaseString];
        NSString *uTxt = [txt uppercaseString];
        int diff = strncmp([firstName UTF8String], [uTxt UTF8String], uTxt.length);
        
        if (diff == 0) {
            
            [self.arrDataFilter addObject:userObj];
        }
        
    }
    
    for (UserObj *userObj in self.arrData) {
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
    
    [tfSearch resignFirstResponder];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
      tbvFilter.hidden = YES;
    [self hideKeyBoard];
}

- (void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    self.arrData = [[NSMutableArray alloc] init ];
    
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",response);
    NSDictionary* dic = [response objectFromJSONString];
    NSArray* arrayFriend = [dic objectForKey:@"friendTasteSync"];
    
    for (NSDictionary* dic in arrayFriend) {
        UserObj* userObject = [[UserObj alloc]init];
        userObject.uid = [dic objectForKey:@"userId"];
        userObject.name = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"tsFirstName"], [dic objectForKey:@"tsLastName"]];
        userObject.avatarUrl = [dic objectForKey:@"photo"];
        [self.arrData addObject:userObject];
    }
    
    
    [tbvResult reloadData];
}


@end
