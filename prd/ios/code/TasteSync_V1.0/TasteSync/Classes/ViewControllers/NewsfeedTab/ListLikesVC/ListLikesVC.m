//
//  ListLikesVC.m
//  TasteSync
//
//  Created by Victor on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "ListLikesVC.h"
#import "UserCell.h"
#import "CommonHelpers.h"

@interface ListLikesVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
- (IBAction)actionBack:(id)sender;


@end

@implementation ListLikesVC

@synthesize arrData=_arrData,
numberOfLikes=_numberOfLikes;

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

    
    self.arrData = [[NSMutableArray alloc] init ];
    for (int i=0; i<_numberOfLikes; i++) {
        UserObj *user = [[UserObj alloc] init];
        user.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
        user.firstname = @"Victor" ;
        user.lastname = @"NGO";
        
        [self.arrData addObject:user];
    }

    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_arrData) {
        return _arrData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"user_cell";
    
    UserCell *cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        NSLog(@"cell is nil");
        cell =(UserCell *) [[[NSBundle mainBundle ] loadNibNamed:@"UserCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    
    [cell initForView:[_arrData objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[CommonHelpers appDelegate] tabbarBaseVC ] actionProfile:[_arrData objectAtIndex:indexPath.row]];
}

@end
