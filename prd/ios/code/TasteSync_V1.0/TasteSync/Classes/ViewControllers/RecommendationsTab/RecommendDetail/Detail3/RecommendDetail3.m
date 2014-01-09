//
//  RecommendDetail3.m
//  TasteSync
//
//  Created by Victor on 12/27/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//


#import "RecommendDetail1.h"
#import "RecommendDetail2.h"
#import "RecommendDetail3.h"
#import "RecommendDetail4.h"
#import "CommonHelpers.h"
#import "RestaurantRecommendations2.h"
#import "GlobalNotification.h"

@interface RecommendDetail3 ()<UIAlertViewDelegate>
{
    __weak IBOutlet UIView *view1,*view2;
    __weak IBOutlet UILabel *lbNotification,*lbName,*lbPoint;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UITextView *tvLongMsg;
    GlobalNotification *glNotif ;
    NotificationObj *currentNotif;

}
- (IBAction)actionBack:(id)sender;

- (IBAction)actionNewsfeedTab:(id)sender;

- (IBAction)actionOk:(id)sender;

- (IBAction)actionAvatar:(id)sender;


@end

@implementation RecommendDetail3

@synthesize notificationObj=_notificationObj,
indexOfNotification=_indexOfNotification,
totalNotification=_totalNotification;

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
    
    _notificationObj.unread = NO;
    
    glNotif = [[GlobalNotification alloc]initWithALlType];
    
    if (glNotif.isSend) {
        view1.hidden = NO;
    }
    else
    {
        view1.hidden = YES;
        [view2 setFrame:CGRectMake(0, view2.frame.origin.y-60, view2.frame.size.width, view2.frame.size.height)];
    }

    if (_notificationObj) {
        ivAvatar.image = _notificationObj.user.avatar;
        NSString *firstCh = [_notificationObj.user.lastname substringToIndex:1];
       
            lbName.text = [NSString stringWithFormat:@"%@ %@. %@",_notificationObj.user.firstname,firstCh,NO_TITLE_5];
      
        tvLongMsg.text = _notificationObj.description;
        lbNotification.text = [NSString stringWithFormat:@"NOTIFICATION %d of %d",_indexOfNotification,_totalNotification];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Others

- (void) gotoDetailNotification:(NotificationObj *) obj atIndex:(int) index;
{
    debug(@"gotoDetailNotification");
    
    if (obj == nil) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return ;
    }
    
    glNotif.index = index;
    index++;
    
    currentNotif = obj;
    
    if (obj.type==TYPE_1) {
        RecommendDetail1 *vc = [[RecommendDetail1 alloc] initWithNibName:@"RecommendDetail1" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (obj.type == TYPE_2)
    {
        debug(@"type 2");
        RestaurantRecommendations2 *vc = [[RestaurantRecommendations2 alloc] initWithNibName:@"RestaurantRecommendations2" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if (obj.type== TYPE_3||obj.type==TYPE_4)
    {
        RecommendDetail2 *vc = [[RecommendDetail2 alloc] initWithNibName:@"RecommendDetail2" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (obj.type==TYPE_5)
    {
        RecommendDetail3 *vc = [[RecommendDetail3 alloc] initWithNibName:@"RecommendDetail3" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (obj.type==TYPE_6)
    {
        RecommendDetail4 *vc = [[RecommendDetail4 alloc] initWithNibName:@"RecommendDetail4" bundle:nil];
        vc.notificationObj = obj;
        vc.indexOfNotification=index;
        vc.totalNotification= glNotif.unread;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(obj.type == TYPE_7)
    {
        debug(@"type 7");
        NSString *msg = [NSString stringWithFormat:@"Are you sure to see this detail restaurant?"];
        [CommonHelpers showConfirmAlertWithTitle:APP_NAME message:msg delegate:self tag:1];
    }
    else
    {
        
    }
}


# pragma mark - IBAction define

- (IBAction)actionBack:(id)sender
{
    [self.global.recomendationDelegate reloadRecomendation];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)actionNewsfeedTab:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (IBAction)actionOk:(id)sender
{
    debug(@"actionOk");
    _notificationObj.read = TRUE;
    [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
}

- (IBAction)actionAvatar:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionProfile:_notificationObj.user];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        currentNotif.read = TRUE;
        RestaurantObj *obj = [[RestaurantObj alloc] init];
        obj.name = @"Nanking";
        obj.nation = @"American";
        obj.rates = 4;
        
        [[[CommonHelpers appDelegate] tabbarBaseVC] actionSelectRestaurant:obj selectedIndex:1];

    }
    else
    {
        [self gotoDetailNotification:[glNotif gotoNextNotification] atIndex:glNotif.index];
    }
    
}

@end
