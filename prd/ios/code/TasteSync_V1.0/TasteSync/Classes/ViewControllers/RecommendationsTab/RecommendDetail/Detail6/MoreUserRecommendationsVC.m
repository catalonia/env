//
//  MoreUserRecommendationsVC.m
//  TasteSync
//
//  Created by Victor on 3/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "MoreUserRecommendationsVC.h"
#import "CommonHelpers.h"
#import "RecommendationCell.h"

@interface MoreUserRecommendationsVC ()
{
    RestaurantObj* _restaurantObj;
}
@end

@implementation MoreUserRecommendationsVC

@synthesize arrData=_arrData;
-(id)initWithRestaurantObj:(RestaurantObj*)restaurantObj
{
    self = [super initWithNibName:@"MoreUserRecommendationsVC" bundle:nil];
    if (self) {
        _restaurantObj = restaurantObj;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForView:self.view];
    self.arrData = _restaurantObj.recommendArray;
    
    
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
    static NSString *CellIndentifier = @"RecommendationCell";
    
    RecommendationCell *cell = (RecommendationCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        NSLog(@"cell is nil");
        cell =(RecommendationCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RecommendationCell" owner:self options:nil] objectAtIndex:0];
        
        
    }
    
    [cell setUI:[_arrData objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"RecommendationCell";
    
    RecommendationCell *cell = (RecommendationCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        NSLog(@"cell is nil");
        cell =(RecommendationCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RecommendationCell" owner:self options:nil] objectAtIndex:0];
    }
    
    return cell.frame.size.height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[[[CommonHelpers appDelegate] tabbarBaseVC ] actionProfile:[_arrData objectAtIndex:indexPath.row]];

}
@end
