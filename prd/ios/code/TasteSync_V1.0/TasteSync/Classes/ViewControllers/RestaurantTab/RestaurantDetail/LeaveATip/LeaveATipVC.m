//
//  LeaveATipVC.m
//  TasteSync
//
//  Created by Victor on 2/22/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "LeaveATipVC.h"
#import "CommonHelpers.h"
#import "ResQuestionVC.h"
#import "RateCustom.h"


@interface LeaveATipVC ()<ResShareViewDelegate>
{
    BOOL facebookSelected, twitterSelected;
    __weak IBOutlet UILabel* lbTimeOpen;
}
@end

@implementation LeaveATipVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRestaurantObj:(RestaurantObj*)restaurantObj
{
    self = [super initWithNibName:@"LeaveATipVC" bundle:nil];
    if (self) {
        self.restaurantObj = restaurantObj;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* link = [NSString stringWithFormat:@"aptips?userid=%@", [UserDefault userDefault].userID];
    CRequest* request = [[CRequest alloc]initWithURL:link RQType:RequestTypeGet  RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:1 WithView:self.view];
    request.delegate = self;
    [request startFormRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CommonHelpers setBackgroudImageForView:self.view];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    lbRestaurantDetail.text = [CommonHelpers getInformationRestaurant:self.restaurantObj];
   
    RateCustom *rateCustom = [[RateCustom alloc] initWithFrame:CGRectMake(18, 103, 30, 4)];
    if (_restaurantObj.rates != 0) {
        [rateCustom setRateMedium:_restaurantObj.rates];
        [self.view addSubview:rateCustom];
        rateCustom.allowedRate = NO;
    }
    if (_restaurantObj.isOpenNow)
        lbTimeOpen.text = @"Open Now";
    else
        lbTimeOpen.text = @"Closed Now";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_restaurantObj.isSaved) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btSave];
        
    }else
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved.png"] forButton:btSave];
        
    }
    
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_leavetip_on.png"] forButton:btLeaveATip];
    btTipView.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initUI
{
    if (_restaurantObj) {
        lbRestaurantName.text = _restaurantObj.name;
        if (_restaurantObj.isSaved) {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saverestaurants.png"] forButton:btSave];
            
        }else
        {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_saverestaurants_off.png"] forButton:btSave];
            
        }

    }
}

# pragma mark- IBAction's define

- (IBAction)actionSave:(id)sender
{
    
    if (!_restaurantObj.isSaved) {
        if ([UserDefault userDefault].loginStatus == NotLogin) {
            [[CommonHelpers appDelegate] showLoginDialog];
        }
        else
        {
            //            [CommonHelpers saveRestaurantAlert:tvNote andDelegate:self];
            if (!_restaurantObj.isSaved) {
                
                [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btSave];
                _restaurantObj.isSaved = YES;
                
                
            }
            
        }
        
    }
}
- (IBAction)actionAsk:(id)sender
{
    ResQuestionVC *vc = [[ResQuestionVC alloc] initWithNibName:@"ResQuestionVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)actionShareFacebook:(id)sender
{
    if (facebookSelected) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"facebook_off.png"] forButton:btFacebook];
        facebookSelected = NO;
    }
    else
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"facebook.png"] forButton:btFacebook];
        facebookSelected = YES;
    }
}
- (IBAction)actionShareTwitter:(id)sender
{
    if (twitterSelected) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"twitter_off.png"] forButton:btTwitter];
        twitterSelected = NO;
    }
    else
    {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"twitter.png"] forButton:btTwitter];
        twitterSelected = YES;
    }
}
- (IBAction)actionLeaveATip:(id)sender
{
    if ([UserDefault userDefault].loginStatus == NotLogin) {
        [[CommonHelpers appDelegate] showLoginDialog];
    }
    else
    {
        if ([tvTip.text isEqualToString:@""]) {
            [CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:@"Please enter your tip!" delegate:nil tag:0];
        }
        else
        {
            NSString* facebookFlag;
            if (facebookSelected)
                facebookFlag = @"1";
            else
                facebookFlag = @"0";
            
            NSString* twitterFlag;
            if (twitterSelected)
                twitterFlag = @"1";
            else
                twitterFlag = @"0";
            
            CRequest* request = [[CRequest alloc]initWithURL:@"savetips" RQType:RequestTypePost RQData:RequestDataRestaurant RQCategory:ApplicationForm withKey:2 WithView:self.view];
            request.delegate = self;
            [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userid"];
            [request setFormPostValue:_restaurantObj.uid forKey:@"restaurantid"];
            [request setFormPostValue:tvTip.text forKey:@"tiptext"];
            [request setFormPostValue:facebookFlag forKey:@"shareonfacebook"];
            [request setFormPostValue:twitterFlag forKey:@"shareontwitter"];
            [request startFormRequest];
            
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_leavetip_on.png"] forButton:btLeaveATip];
            btTipView.backgroundColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
        }
    }
}
- (IBAction)actionNewsfeed:(id)sender
{
    [CommonHelpers showShareView:self andObj:_restaurantObj];
}
- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    lbTvTip.hidden = YES;
    [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_leavetip.png"] forButton:btLeaveATip];
    btTipView.backgroundColor = [UIColor colorWithRed:108.0/255.0 green:108.0/255.0 blue:108.0/255.0 alpha:1.0];
//    textView.text = @"";
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         self.view.frame=CGRectMake(self.view.frame.origin.x,-100,self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         lbTvTip.hidden = YES;
                        
                         
                     }];
    return YES;

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

#pragma mark - Others

- (void) hideKeyboard
{
    [tvTip resignFirstResponder];
    if ([tvTip.text isEqualToString:@""]) {
        lbTvTip.hidden = NO;
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

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    if (key == 1) {
        NSString* response = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSArray* array = [response objectFromJSONString];
        if ([array count] > 0) {
            for (NSDictionary* dic in array) {
                NSString* name = [dic objectForKey:@"apSettingType"];
                NSString* flag = [dic objectForKey:@"autoPublishingSetting"];
                if ([flag isEqualToString:@"1"]) {
                    if ([name isEqualToString:@"FACEBOOK"]) {
                            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"facebook.png"] forButton:btFacebook];
                            facebookSelected = YES;
                        }
                        else
                        {
                            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"twitter.png"] forButton:btTwitter];
                            twitterSelected = YES;
                        }
                }
                else
                {
                    if ([name isEqualToString:@"FACEBOOK"]) {
                        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"facebook_off.png"] forButton:btFacebook];
                        facebookSelected = NO;
                    }
                    else
                    {
                        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"twitter_off.png"] forButton:btTwitter];
                        twitterSelected = NO;
                    }
                }
            }
        }
    }
    if (key == 2) {
        if (data != nil) {
            tvTip.text = @"";
            lbTvTip.hidden = NO;
            [CommonHelpers showInfoAlertWithTitle:@"TasteSync" message:@"Success!" delegate:nil tag:0];
        }
    }
}
@end
