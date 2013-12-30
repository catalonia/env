//
//  Step2VC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "Step2VC.h"
#import "RestaurantCell.h"
#import "Step3VC.h"
#import "GlobalVariables.h"
#import "NaviBar1.h"
#import "CPickerView.h"
#import "CommonHelpers.h"

@interface Step2VC ()<UITableViewDataSource,UITableViewDelegate,CPickerViewDelegate,RestaurantCellDelegate>
{
    __weak IBOutlet UITableView *tbvNative,*tbvOther;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName,*lbLocation,*lbNativeCusine,*lbTitle;
    __weak IBOutlet UIButton *btStep1,*btStep3,*btDone;
    CPickerView *cPickerView;
    NaviBar1 *naviBar1;
    BOOL isNativePicker;
}

- (IBAction)actionChooseNativeCusine:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionStep3:(id)sender;

- (IBAction)actionDone:(id)sender;

@end

@implementation Step2VC
@synthesize arrData=_arrData,arrOtherData=_arrOtherData,arrDataNatives=_arrDataNatives,
userObj=_userObj,
IS_EDIT_PROFILE=_IS_EDIT_PROFILE;


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
    self.arrData = [[NSMutableArray alloc] initWithObjects:@"American",@"Chinese",@"Italian",@"Vietnam", nil];
    self.arrOtherData = [[NSMutableArray alloc] initWithObjects:@"", nil ];
    self.arrDataNatives = [[NSMutableArray alloc] initWithObjects:@"America", nil];
    // Do any additional setup after loading the view from its nib.
    [self initDataForView];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   naviBar1  = [[NaviBar1 alloc] initWithFrame:self.navigationController.navigationBar.frame];
    naviBar1.btnSkip.hidden= YES;
    [[self.navigationController.navigationBar superview ] addSubview:naviBar1];
  
    if (_IS_EDIT_PROFILE) {
        btStep1.hidden = YES;
        btStep3.hidden = YES;
        btDone.hidden = NO;
        lbTitle.hidden = YES;
        naviBar1.btBack.hidden = NO;
        [naviBar1.btBack addTarget:self action:@selector(actionBack:) forControlEvents:UIControlEventTouchUpInside];
//        
//        CGRect frame = self.view.frame;
//        frame.size.height += 44;
//        [self.view setFrame:frame];
        
        [[[[CommonHelpers appDelegate] tabbarBaseVC] tabBar] setHidden:YES];
    }
   
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

#pragma mark - IBAction

- (IBAction)actionChooseNativeCusine:(id)sender
{
#ifdef DEBUG
    NSLog(@"actionChooseNativeCusine");
#endif
  
    cPickerView = [[CPickerView alloc] initWithTitle:APP_NAME arrData:self.arrData delegate:self];
    cPickerView.tag =1;
    [cPickerView show];
    
}

- (IBAction)actionBack:(id)sender
{
    debug(@"actionBack");
    [naviBar1 removeFromSuperview];
    naviBar1.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)actionStep3:(id)sender
{
    debug(@"actionStep3");
    Step3VC *step3VC = [[Step3VC alloc] initWithNibName:@"Step3VC" bundle:nil] ;
    step3VC.userObj = self.userObj;
    [self.navigationController pushViewController:step3VC animated:YES];

}

- (IBAction)actionDone:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    naviBar1.hidden = YES;
    [naviBar1 removeFromSuperview];
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
    
    debug(@"numberOfRowsInSection");
    if (tableView == tbvOther) {
        if (_arrOtherData) {
            return _arrOtherData.count;
        }

    }else
    {
        if (_arrDataNatives) {
            if (_arrDataNatives.count >MAX_NATIVE_CUSINE) {
                return MAX_NATIVE_CUSINE;
            }
            return _arrDataNatives.count;
        }
        
    }
    
    NSLog(@"return number row 0");
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath");
        
    static NSString *CellIndentifier = @"restaurant_cell";
    
    RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil) {
        NSLog(@"cell is nil");
        cell =(RestaurantCell *) [[[NSBundle mainBundle ] loadNibNamed:@"RestaurantCell" owner:self options:nil] objectAtIndex:0];
        
       
    }
    
    NSString *restaurant;
    
    if (tableView == tbvOther) {
        restaurant = [self.arrOtherData objectAtIndex:indexPath.row];
        if (indexPath.row<self.arrOtherData.count-1) {            
            cell.btAdd.hidden = YES;
            cell.btRemove.hidden = NO;
        }
        else
        {            
            cell.btAdd.hidden = NO;
            cell.btRemove.hidden = YES;
        }
        cell.lbRestaurant.text = restaurant;

        cell.isNative = FALSE;

    }
    else
    {
        restaurant = [self.arrDataNatives objectAtIndex:indexPath.row];
        if (indexPath.row<self.arrDataNatives.count-1 || indexPath.row ==1) {
            cell.btAdd.hidden = YES;
            cell.btRemove.hidden = NO;
        }
        else
        {            
            cell.btAdd.hidden = NO;
            cell.btRemove.hidden = YES;
        }
        cell.lbRestaurant.text = restaurant;
        cell.isNative = TRUE;

    }
    
    cell.tag = indexPath.row;
       cell.delegate = self;
    
    return cell;
}

/*
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==tbvNative) {
        if (_arrDataNatives.count>1) {
            [self.arrDataNatives removeObjectAtIndex:indexPath.row];
            [tbvNative reloadData];
        }
       
        
    }
    else
    {
        if (_arrOtherData.count>1) {
            [self.arrOtherData removeObjectAtIndex:indexPath.row];
            [tbvOther reloadData];
        }
       

    }
}
 
 */

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
    
    if (isNativePicker) {
        [self.arrDataNatives replaceObjectAtIndex:tag withObject:obj];
        [tbvNative reloadData];
    }
    else{
        [self.arrOtherData replaceObjectAtIndex:tag withObject:obj];
        [tbvOther reloadData];
        
    }

}

#pragma mark - RestaurantCellDelegate

- (void) didActionWithTag:(int)Tag atIndex:(int)index
{
    switch (Tag) {
        case RestaurantCellActionTagChooseNative:
        {
            cPickerView = [[CPickerView alloc] initWithTitle:APP_NAME arrData:self.arrData delegate:self];
            isNativePicker = YES;
            cPickerView.tag =index;
            [cPickerView show];
        }
            break;
            
        case RestaurantCellActionTagChooseOther:
        {
            cPickerView = [[CPickerView alloc] initWithTitle:APP_NAME arrData:self.arrData delegate:self];
            isNativePicker = NO;
            cPickerView.tag =index;
            [cPickerView show];
        }
            break;
            
        case RestaurantCellActionTagAddNative:
        {
            NSString *lastObj = [_arrDataNatives objectAtIndex:(_arrDataNatives.count-1)];
            if ([lastObj isEqualToString:@""]) {
                debug(@"don't add new box");
            }
            else
            {
                debug(@"add new box");
                if (_arrDataNatives.count < MAX_NATIVE_CUSINE) {
                    [self.arrDataNatives addObject:@""];
                    [tbvNative reloadData];
                }
               

            }
        }
            break;
            
        case RestaurantCellActionTagAddOther:
        {
            {
                NSString *lastObj = [_arrOtherData objectAtIndex:(_arrOtherData.count-1)];
                if ([lastObj isEqualToString:@""]) {
                    debug(@"don't add new box");
                }
                else
                {
                    debug(@"add new box");
                    [self.arrOtherData addObject:@""];
                    [tbvOther reloadData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_arrOtherData.count-1) inSection:0];
                    [tbvOther scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:YES];
                }
            }
        }
            break;
            
        case RestaurantCellActionTagRemoveNative:
        {
            if (_arrDataNatives.count>index) {
                [self.arrDataNatives removeObjectAtIndex:index];
                [tbvNative reloadData];
            }
        }
            break;
            
        case RestaurantCellActionTagRemoveOther:
        {
           
            if (_arrOtherData.count>index) {
                [self.arrOtherData removeObjectAtIndex:index];
                [tbvOther reloadData];
            }
        
        }
            break;
            
        default:
            break;
    }
   
}

@end
