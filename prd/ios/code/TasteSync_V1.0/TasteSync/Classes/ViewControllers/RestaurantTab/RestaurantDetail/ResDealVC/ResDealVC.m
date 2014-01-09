//
//  ResDealVC.m
//  TasteSync
//
//  Created by Victor on 1/10/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "ResDealVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "ResReserveVC.h"

@interface ResDealVC ()
{
    __weak IBOutlet UILabel *lbResName,*lbResDetail;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionShare:(id)sender;
- (IBAction)actionQuestion:(id)sender;
- (IBAction)actionBuy:(id)sender;


@end

@implementation ResDealVC
@synthesize restaurantObj=_restaurantObj;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionShare:(id)sender
{
    [CommonHelpers showShareView:nil andObj:_restaurantObj];
}

- (IBAction)actionQuestion:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    vc.restaurantObj = _restaurantObj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionBuy:(id)sender
{
    //
    ResReserveVC *vc = [[ResReserveVC alloc] initWithNibName:@"ResReserveVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
