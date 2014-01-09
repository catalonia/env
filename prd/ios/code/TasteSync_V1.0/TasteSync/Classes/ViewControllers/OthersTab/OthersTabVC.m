//
//  OthersTabVC.m
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "OthersTabVC.h"
#import "CommonHelpers.h"
#import "ProfileVC.h"
#import "UsersVC.h"
#import "SettingVC.h"

@interface OthersTabVC ()

@end

@implementation OthersTabVC

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
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    
    [CommonHelpers setBackgroudImageForView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction's Define

- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}
- (IBAction)actionProfile:(id)sender
{
    ProfileVC *vc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionUsersSection:(id)sender
{
    UsersVC *vc = [[UsersVC alloc] initWithNibName:@"UsersVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionSetting:(id)sender
{
    SettingVC *vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
