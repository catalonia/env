//
//  Step3VC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "Step3VC.h"
#import "GlobalVariables.h"
#import "NaviBar1.h"
#import "SpotCell.h"
#import "SpotObj.h"
#import "CommonHelpers.h"
#import "CPickerView.h"
#import "AddSpotCell.h"

@interface Step3VC ()<UITableViewDataSource,UITableViewDelegate,CPickerViewDelegate,SpotCellDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *tbvSpots,*tbvFilter;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName,*lbLocation;
    __weak IBOutlet UIButton *btStep2,*btDone;
    CPickerView *cPickerView;
    int index;
    float offset;
    NSMutableArray *arrTextField;
    BOOL keypadShown;
}

- (IBAction)actionAddSpot:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionDone:(id)sender;
@end

@implementation Step3VC
@synthesize userObj=_userObj;

@synthesize arrData = _arrData,arrDataSpot=_arrDataSpot,
arrMealData=_arrMealData,arrDataFilter=_arrDataFilter;

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
    arrTextField = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    SpotObj *obj = [[SpotObj alloc] initWithName:@"" defaultMeal:@"Breakfast"];
    self.arrData = [[NSMutableArray alloc] initWithObjects:obj, nil ];
    self.arrDataSpot =[[NSMutableArray alloc] init];
    for (int i=0; i<10; i++) {
        if (i%2==0) {
            SpotObj *spotObj = [[SpotObj alloc] initWithName:@"Viet Foods" defaultMeal:@"Breakfast"];
            [self.arrDataSpot addObject:spotObj];
        }
        else
        {
            SpotObj *spotObj = [[SpotObj alloc] initWithName:@"Chinese" defaultMeal:@"Breakfast"];
            [self.arrDataSpot addObject:spotObj];
        }
        
        
    }
    
    
    
    self.arrMealData = [[NSMutableArray alloc] initWithObjects:@"Breakfast",@"Coffee",@"Lunch",@"Drinks",@"Dinner", nil];
    
    
    [self initDataForView];

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

#pragma mark -IBAction define

- (IBAction)actionBack:(id)sender
{
    NSLog(@"actionBack");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender
{
    debug(@"actionDone");
    [[CommonHelpers appDelegate] gotoMainVC];
}

- (IBAction)actionAddSpot:(id)sender
{
    debug(@"actionAddSpot");
    SpotObj *obj = [_arrData lastObject];
    if (![obj.name isEqualToString:@""]) {
        [self.arrData addObject:[[SpotObj alloc] initWithName:@"" defaultMeal:@"Breakfast"]];
        [tbvSpots reloadData];
    }
}


#pragma mark - Others

- (void) initDataForView
{
    
    lbName.text = [NSString stringWithFormat:@"%@ %@",self.userObj.firstname,self.userObj.lastname];
    if (self.userObj.city != nil && self.userObj.states !=nil) {
        lbLocation.text = [NSString stringWithFormat:@"%@, %@",self.userObj.city,self.userObj.states];
    }

    ivAvatar.image = self.userObj.avatar;
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbvSpots) {
        if (_arrData) {
            return _arrData.count +1;
        }
        
        return 1;
    }
    else {
        if (_arrDataFilter) {
            return _arrDataFilter.count;
        }
        
        return 0;
    }
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tbvSpots) {
        if (indexPath.row <_arrData.count) {
            static NSString *CellIndentifier = @"spot_cell";            
            
            SpotCell *cell = (SpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            
            if (cell==nil) {
                NSLog(@"cell is nil");
                cell =(SpotCell *) [[[NSBundle mainBundle ] loadNibNamed:@"SpotCell" owner:self options:nil] objectAtIndex:0];
                
                
            }
                        
                SpotObj *spotObj = [self.arrData objectAtIndex:indexPath.row];
            
                debug(@"spotobj -> name = %@",spotObj.name);
            UITextField *tf = [[UITextField alloc] init];
            tf.delegate = self;
            tf = cell.tfRestaurant;
            tf.tag = indexPath.row;
            [arrTextField addObject:tf];
                cell.tfRestaurant.text = spotObj.name;
                cell.lbDefaultMeal.text = spotObj.defaultMeal;
                cell.tag = indexPath.row;
                cell.delegate = self;
            
                    
            return cell;
        }    
        else {
            static NSString *CellIndentifier = @"add_spot_cell";
            
            
            AddSpotCell *cell = (AddSpotCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
            
            if (cell==nil) {
                NSLog(@"cell is nil");
                cell =(AddSpotCell *) [[[NSBundle mainBundle ] loadNibNamed:@"AddSpotCell" owner:self options:nil] objectAtIndex:0];
                
                
            }
                        
            
            return cell;
        }

    }
    else {
        static NSString *CellIndentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        }
        
        SpotObj *obj = [_arrDataFilter objectAtIndex:indexPath.row];
        cell.textLabel.text = obj.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        return cell;
        
        
    }
       
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
 
    if (tableView == tbvSpots) {
        CGRect frame = [tbvSpots rectForFooterInSection:0];
        debug(@"x -> %f, y-> %f, width -> %f, height -> %h",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
        
        offset = frame.origin.y-44;
        if (offset>132) {
            offset =132;
        }
        
        [tbvFilter setFrame:CGRectMake(tbvFilter.frame.origin.x, tbvSpots.frame.origin.y+offset, tbvFilter.frame.size.width, tbvFilter.frame.size.height)];

    }
    
    UIView *view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    debug(@"index -> %d",index);
    if (tableView==tbvFilter) {
        SpotObj *obj = [[SpotObj alloc] init];
        obj = [_arrDataFilter objectAtIndex:indexPath.row];
        [self.arrData replaceObjectAtIndex:index withObject:obj];
        [tbvSpots reloadData];
        tbvFilter.hidden= YES;
        [self hideKeyBoard];
        [self.arrDataFilter removeAllObjects];
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tbvSpots) {
        if (indexPath.row <_arrData.count-1) {
            [self.arrData removeObjectAtIndex:indexPath.row];
            [tbvSpots reloadData];

        }
    }
}

#pragma mark -CPickerViewDelegate

- (void) cPickerViewDidCancelWithTag:(int)tag
{
    NSLog(@"cPickerViewDidCancel");

    cPickerView = nil;
}
- (void) cPickerViewDidDoneWithObject:(id) obj andTag:(int)tag
{
    NSLog(@"cPickerViewDidDoneWithObject -> %@",obj);

    cPickerView = nil;
    SpotObj *spotObj = [self.arrData objectAtIndex:tag];
    spotObj.defaultMeal = obj;
    
    [tbvSpots reloadData];
    
    
}

#pragma mark - SpotCellDelegate

- (void) didActionChooseWithTag:(int) tag
{
    NSLog(@"tag ->%d",tag);
    cPickerView = [[CPickerView alloc] initWithTitle:APP_NAME arrData:self.arrMealData delegate:self];
    cPickerView.tag =tag;       
    [cPickerView show];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    debug(@"textField tag -> %d", textField.tag);
    
    keypadShown = TRUE;
    
    index = textField.tag;
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x,-offset-44,self.view.frame.size.width, self.view.frame.size.height);
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
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField) {
        [self searchLocal:[textField.text stringByReplacingCharactersInRange:range withString:string]];
        
    }
    
    return TRUE;
    
}

# pragma mark - Others


- (void) searchLocal:(NSString *)txt
{
    NSString *str = [NSString stringWithFormat:@"name MATCHES[cd] '.*%@.*'", [CommonHelpers trim:txt]];
    tbvFilter.hidden = YES;
    [self.arrDataFilter removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    
    NSArray *array = [self.arrDataSpot filteredArrayUsingPredicate:predicate];
    if(array)
    {
        self.arrDataFilter = [NSMutableArray arrayWithArray:array];
    }
    
    for (SpotObj *obj in _arrData) {
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
    
    for (UITextField *tf in arrTextField) {
        [tf resignFirstResponder];
    }
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
        tbvFilter.hidden = YES;
    }
}

@end
