//
//  Step2VC.m
//  TasteSync
//
//  Created by Victor on 12/20/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "Step2VC.h"
#import "GlobalVariables.h"
#import "CPickerView.h"
#import "CommonHelpers.h"

@interface Step2VC ()<UITableViewDataSource,UITableViewDelegate,CPickerViewDelegate>
{
    __weak IBOutlet UITableView *tbvNative,*tbvOther;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UILabel *lbName,*lbLocation,*lbNativeCusine,*lbTitle;
    __weak IBOutlet UIButton *btStep1,*btStep3,*btDone;
    CPickerView *cPickerView;
    BOOL isNativePicker;
}

- (IBAction)actionChooseNativeCusine:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)actionDone:(id)sender;

@end

@implementation Step2VC
@synthesize arrData=_arrData,arrOtherData=_arrOtherData,arrDataNatives=_arrDataNatives;



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
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     
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
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)actionDone:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Others

- (void) initUI
{
    
   
    
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
           
            return _arrDataNatives.count;
        }
        
    }
    
    NSLog(@"return number row 0");
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForRowAtIndexPath");
        
   
   
    
    return nil;
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



@end
