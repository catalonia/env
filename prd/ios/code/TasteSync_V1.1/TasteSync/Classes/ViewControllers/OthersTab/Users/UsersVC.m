//
//  UsersVC.m
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "UsersVC.h"
#import "UserCell2.h"
#import "ProfileVC.h"
#import "UserDefault.h"
#import "FriendFilterCell.h"
#import "CommonHelpers.h"

@interface UsersVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIView *actionView,*headView;
    __weak IBOutlet UITableView *tbvResult,*tbvFilter;
    __weak IBOutlet UITextField *tfSearch;
    UserDefault *userDefault;
}

- (IBAction)actionBack:(id)sender;

- (IBAction)actionNewsfeed:(id)sender;

- (IBAction)actionMyFollowers:(id)sender;

- (IBAction)actionFriends:(id)sender;

- (IBAction)actionPeopleIFollow:(id)sender;

@end

@implementation UsersVC

@synthesize arrData=_arrData,
arrDataFilter=_arrDataFilter,
arrDataFriends=_arrDataFriends;

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

    userDefault = [UserDefault userDefault];
    // Do any additional setup after loading the view from its nib.
    
    self.arrData = [[NSMutableArray alloc] init ];
    self.arrDataFriends = [[NSMutableArray alloc] init ];

    for (int i=0; i<10; i++) {
        UserObj *user = [[UserObj alloc] init];
        user.firstname = @"James";
        user.lastname = @"Ponds";
        user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
        if (userDefault.loginStatus == NotLogin) {
            user.status = 0;
            [self.arrData addObject:user];
        }
        else
        {
            user.status = i%3+1;
        }
            
        [self.arrDataFriends addObject:user];
        
        
    }
    
    self.arrDataFilter = [[NSMutableArray alloc] init];
    
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

# pragma mark - IBAction define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}


- (IBAction)actionMyFollowers:(id)sender
{
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Create your own community where you can Share Awesome Recommendations and meet\n Please Sign-up to add friends/follow people/allow" delegate:self tag:1];
    }
    else
    {
        for (UserObj *obj in _arrDataFriends) {
            obj.status = UserStatusFollower;
            [_arrData addObject:obj];
        }
        [tbvResult reloadData];
    }
   
}

- (IBAction)actionFriends:(id)sender
{
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Create your own community where you can Share Awesome Recommendations and meet\n Please Sign-up to add friends/follow people/allow" delegate:self tag:1];
    }
    else
    {
        for (UserObj *obj in _arrDataFriends) {
            obj.status = UserStatusFriend;
            [_arrData addObject:obj];
        }
        [tbvResult reloadData];
    }

}

- (IBAction)actionPeopleIFollow:(id)sender
{
    if (userDefault.loginStatus == NotLogin) {
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:@"Create your own community where you can Share Awesome Recommendations and meet\n Please Sign-up to add friends/follow people/allow" delegate:self tag:1];
    }
    else
    {
        for (UserObj *obj in _arrDataFriends) {
            obj.status = UserStatusFollow;
            [_arrData addObject:obj];
        }
        [tbvResult reloadData];
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
        static NSString *CellIndentifier = @"user_cell2";
        
        UserCell2 *cell = (UserCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            cell =(UserCell2 *) [[[NSBundle mainBundle ] loadNibNamed:@"UserCell2" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        [cell initForView:[_arrData objectAtIndex:indexPath.row]];
        cell.tag = indexPath.row;
        
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
        
        
        return cell;    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvFilter) {
        UserObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        if (userDefault.loginStatus == NotLogin) {
            obj.status = 0;
        }
        [self.arrData addObject:obj];
        [tbvResult reloadData];
        tbvFilter.hidden= YES;
        tfSearch.text = nil;
        [self.arrDataFilter removeAllObjects];
        [self hideKeyBoard];
        
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    textField.text = @"";

    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x,-50,self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
//                         [self searchLocal:@""];

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


- (void) searchLocal:(NSString *)txt
{
    NSString *str = [NSString stringWithFormat:@"firstname MATCHES[cd] '%@.*'", [CommonHelpers trim:txt]];
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    NSArray *array = [self.arrDataFriends filteredArrayUsingPredicate:predicate];
    if(array)
    {
        self.arrDataFilter = [NSMutableArray arrayWithArray:array];
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
    [self hideKeyBoard];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
}



@end
