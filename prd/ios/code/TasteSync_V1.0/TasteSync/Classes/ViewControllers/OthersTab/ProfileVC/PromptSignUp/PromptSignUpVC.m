//
//  PromptSignUpVC.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 1/28/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "PromptSignUpVC.h"
#import "ProfileVC.h"
#import "UserObj.h"
#import "CommonHelpers.h"
#import "FriendProfileCell.h"

@interface PromptSignUpVC ()
{
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;

@end

@implementation PromptSignUpVC

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
    [self initData];
    
  
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

- (void) initData
{
    self.arrData = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        UserObj *obj = [[UserObj alloc] init];
        obj.firstname = @"Victor";
        obj.lastname = @"Ngo";
        obj.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
        
        [self.arrData addObject:obj];
    }
}

#pragma mark - IBAction's Define

- (IBAction)actionConnectFacebook:(id)sender

{
    [[CommonHelpers appDelegate] showLogin];

}


- (IBAction)actionBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrData) {
        if (_arrData.count %2) {
            return _arrData.count/2;
        }
        return _arrData.count/2+1;    }
    
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tbvFriends == tableView)
    {
        static NSString *CellIndentifier = @"friend_profile_cell";
        
        FriendProfileCell *cell = (FriendProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        
        if (cell==nil) {
            NSLog(@"cell is nil");
            cell =(FriendProfileCell *) [[[NSBundle mainBundle ] loadNibNamed:@"FriendProfileCell" owner:self options:nil] objectAtIndex:0];
            
            
        }
        
        UserObj *obj = [_arrData objectAtIndex:indexPath.row];
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
    
    UserObj *obj = [_arrData objectAtIndex:indexPath.row];
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:obj];}



@end
