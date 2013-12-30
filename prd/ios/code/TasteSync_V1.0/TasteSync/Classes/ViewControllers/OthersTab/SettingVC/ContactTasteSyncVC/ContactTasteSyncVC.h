//
//  ContactTasteSyncVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "JSONKit.h"


@interface ContactTasteSyncVC : UIViewController <UITextViewDelegate,RequestDelegate>
{
    __weak IBOutlet UIView *viewMain;
    __weak IBOutlet UIButton *btReportBugs, *btFeedback, *btRestaurantData, *btRequestBlogger;
    
    __weak IBOutlet UITextView *tvContent;
    __weak IBOutlet UIImageView *ivBgReport;
    
    
}

- (IBAction)actionReportBugs:(id)sender;
- (IBAction)actionFeedback:(id)sender;
- (IBAction)actionRestaurantData:(id)sender;
- (IBAction)actionRequestBlogger:(id)sender;
- (IBAction)actionSubmit:(id)sender;



@end
