//
//  ContactTasteSyncVC.m
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//
//
#import "ContactTasteSyncVC.h"
#import "CommonHelpers.h"

@interface ContactTasteSyncVC ()
{
    int ContactSessionStatus;
}

typedef enum _ContactSession
{
    ContactSessionReportBugs    =   1,
    ContactSessionFeedback  =   2,
    ContactSessionRestaurantData    =   3,
    ContactSessionRequestBlogger    =   4
} ContactSession ;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;

@end

@implementation ContactTasteSyncVC

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
    ContactSessionStatus = ContactSessionReportBugs;
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- IBAction's Define

- (IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionNewsfeed:(id)sender
{
    [[[CommonHelpers appDelegate] tabbarBaseVC] actionNewsfeed];
}

- (IBAction)actionReportBugs:(id)sender
{
    ContactSessionStatus = ContactSessionReportBugs;
    
    [self setUIAfterChooseSession];

}
- (IBAction)actionFeedback:(id)sender
{
    ContactSessionStatus = ContactSessionFeedback;

    [self setUIAfterChooseSession];

}
- (IBAction)actionRestaurantData:(id)sender
{
    ContactSessionStatus = ContactSessionRestaurantData;

    [self setUIAfterChooseSession];

}
- (IBAction)actionRequestBlogger:(id)sender
{
    ContactSessionStatus = ContactSessionRequestBlogger;

    [self setUIAfterChooseSession];

}
- (IBAction)actionSubmit:(id)sender
{
    if ([tvContent.text isEqualToString:@"Input some text here"] || (tvContent.text.length == 0)) {
        
        [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Text content is required." delegate:nil tag:0];
        
        [tvContent becomeFirstResponder];
    }
    else
    {
        NSLog(@"Send: %@ in %d", tvContent.text, ContactSessionStatus);
        CRequest* request = [[CRequest alloc]initWithURL:@"submitSettingsContactUs" RQType:RequestTypePost RQData:RequestDataUser RQCategory:ApplicationForm WithView:self.view];
        request.delegate = self;
        [request setFormPostValue:[UserDefault userDefault].userID forKey:@"userId"];
        [request setFormPostValue:[NSString stringWithFormat:@"%d",ContactSessionStatus] forKey:@"Contact_Order"];
        [request setFormPostValue:tvContent.text forKey:@"Contact_Desc"];
        [request startFormRequest];
        [self hideKeyboard];
    }
    
    
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text = @"";
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,-50,viewMain.frame.size.width, viewMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         
                         
                     }];

    
       return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
       return YES;
}

#pragma mark- Others

- (void) setUIAfterChooseSession
{
   
    
    switch (ContactSessionStatus) {
        case ContactSessionReportBugs:
        {
            
            ivBgReport.image = [CommonHelpers getImageFromName:@"bg_report1.png"];
        }
            break;
        case ContactSessionFeedback:
        {
            ivBgReport.image = [CommonHelpers getImageFromName:@"bg_report2.png"];
        

        }
            break;
        case ContactSessionRestaurantData:
        {
            ivBgReport.image = [CommonHelpers getImageFromName:@"bg_report3.png"];
        
        }
            break;
        case ContactSessionRequestBlogger:
        {
            ivBgReport.image = [CommonHelpers getImageFromName:@"bg_report4.png"];
        }
            break;
            
        default:
            break;
    }
}
- (void) hideKeyboard
{
    [tvContent resignFirstResponder];
    [UIView animateWithDuration:0.4
                          delay:0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         viewMain.frame=CGRectMake(viewMain.frame.origin.x,0,viewMain.frame.size.width, viewMain.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         debug(@"move done");
                         
                         
                     }];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(void)responseData:(NSData *)data WithKey:(int)key UserData:(id)userData
{
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response: %@", response);
    
    if (response != NULL) {
        
        NSDictionary* dic = [response objectFromJSONString];
        NSString* successStr = [dic objectForKey:@"successMsg"];
        if (successStr != NULL) {
            [CommonHelpers showInfoAlertWithTitle:APP_NAME message:@"Send contact TasteSync finished." delegate:nil tag:0];
        }
        
    }
    
    tvContent.text = @"";
}

@end
