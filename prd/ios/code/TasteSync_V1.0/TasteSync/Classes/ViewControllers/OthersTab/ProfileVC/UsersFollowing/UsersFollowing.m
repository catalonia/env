//
//  UsersFollowing.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/15/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "UsersFollowing.h"
#import "ProfileVC.h"
#import "CommonHelpers.h"
#import "FriendFilterCell.h"
#import "UserProfileCell.h"
#import "JSONKit.h"

@interface UsersFollowing ()<UserProfileCellDelegate>
{
}
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
@end

@implementation UsersFollowing

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
    // Do any additional setup after loading the view from its nib.
    [CommonHelpers setBackgroudImageForView:self.view];
    
}

- (void) initUI
{
    if (_viewFollowing) {
        viewSearch.hidden = NO;
        if (_user) {
            lbTitle.text = [NSString stringWithFormat:@"%@ is following",_user.name];
            lbSwipe.hidden = YES;
        }
        else
        {
            lbTitle.text = @"You are following";
            lbSwipe.hidden = NO;
        }
        
        CRequest* request = [[CRequest alloc]initWithURL:@"showProfileFollowing" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:_user.uid forKey:@"userId"];
        [request startFormRequest];
        
    }else
    {
        viewSearch.hidden = YES;
        [tbvResult setFrame:CGRectMake(tbvResult.frame.origin.x, tbvResult.frame.origin.y, tbvResult.frame.size.width, tbvResult.frame.size.height+100)];
        lbSwipe.hidden = YES;
        if (_user) {
            lbTitle.text = [NSString stringWithFormat:@"Users are following %@",_user.name];
        }
        else
        {
            lbTitle.text = @"Your followers";
        }
        
        CRequest* request = [[CRequest alloc]initWithURL:@"showProfileFollowers" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:1 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:_user.uid forKey:@"userId"];
        [request startFormRequest];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initUI];
}

- (void) initData:(NSArray*)array
{
    self.arrData = [[NSMutableArray alloc] init];
    self.arrDataFilter = [[NSMutableArray alloc] init];
    self.arrDataUser = [[NSMutableArray alloc] init];
    self.arrDataUser = [[CommonHelpers appDelegate] arrDataFBFriends];
    for (NSDictionary* dic in array) {
        UserObj *obj = [[UserObj alloc]init];
        obj.uid = [dic objectForKey:@"userId"];
        obj.name = [dic objectForKey:@"name"];
        obj.avatarUrl = [dic objectForKey:@"photo"];
        [self.arrData addObject:obj];
    }
    [tbvResult reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}


- (void)shareProfile
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Tumblr",@"Email", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    //  [actionSheet showInView:self.view];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tbvResult== tableView) {
        return  _arrData.count;
    }
    else
    {
        return _arrDataFilter.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbvResult) {
        static NSString *identifier = @"user_profile_cell";
        UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            if (cell==nil) {
                NSLog(@"cell is nil");
                cell =(UserProfileCell *) [[[NSBundle mainBundle ] loadNibNamed:@"UserProfileCell" owner:self options:nil] objectAtIndex:0];
                
                
            }
        }
        UserObj *obj = [_arrData objectAtIndex: indexPath.row];
        [cell initCell:obj];
        if (!_user && _viewFollowing) {
            cell.allowUnfollow = YES;
        }
        
        cell.delegate = self;
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
        
        int count = 0;
        for (UserObj* userObj in self.arrData) {
            NSString* str1 = [NSString stringWithFormat:@"%@",userObj.uid];
            NSString* str2 = [NSString stringWithFormat:@"%@",obj.uid];
            if (![str1 isEqualToString:str2]) {
                count++;
            }
        }
        if (count == self.arrData.count) {
            CRequest* request = [[CRequest alloc]initWithURL:@"submitFollowUserStatusChange" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm withKey:4 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:[UserDefault userDefault].userID forKey:@"followerUserId"];
            [request setFormPostValue:obj.uid forKey:@"followeeUserId"];
            [request setFormPostValue:@"1" forKey:@"statusFlag"];
            [request startFormRequest];
            [self.arrData addObject:obj];
            [tbvResult reloadData];
        }
        tbvFilter.hidden= YES;
        tfSearch.text = nil;
        [self.arrDataFilter removeAllObjects];
        [self hideKeyBoard];
        
    }
    else
    {
        debug(@"select rown at index path");
        UserObj *obj = [_arrData objectAtIndex:indexPath.row];
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:obj];
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

        
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^{
                             self.view.frame=CGRectMake(self.view.frame.origin.x,-200,self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             debug(@"move done");
                             
                             
                         }];
    }
    
    
    
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
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    
    if (txt.length == 0) {
        return;
        
    }
    else
    {
        CRequest* request = [[CRequest alloc]initWithURL:@"usersearchterms" RQType:RequestTypePost RQData:RequestPopulate RQCategory:ApplicationForm withKey:2 WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request setFormPostValue:txt forKey:@"key"];
        [request setFormPostValue:@"1" forKey:@"excludefollowees"];
        [request startFormRequest];
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
   
    tbvFilter.hidden = YES;
    [self hideKeyBoard];
}

#pragma mark - UserProfileCellDelegate

- (void) userProfileCell:(UserProfileCell *) userProfileCell action:(id) anObj
{
    debug(@"UsersProfileCell - > userProfileCell -> action ");
    NSIndexPath *indexpath = [tbvResult indexPathForCell:userProfileCell];    
    [self.arrData removeObjectAtIndex:indexpath.row];    
    [tbvResult reloadData];
    
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    if (key == 1) {
        if (response != NULL) {
            NSArray* array = [response objectFromJSONString];
            [self initData:array];
        }
    }
    if (key == 2) {
        NSArray* array = [response objectFromJSONString];
        for (NSDictionary* dic in array) {
            UserObj* obj = [[UserObj alloc]init];
            obj.name = [dic objectForKey:@"name"];
            obj.uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
            obj.avatarUrl = [dic objectForKey:@"photo"];
            if (![obj.uid isEqualToString:[NSString stringWithFormat:@"%@",self.user.uid]]) {
                [self.arrDataFilter addObject:obj];
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
    
}
@end




