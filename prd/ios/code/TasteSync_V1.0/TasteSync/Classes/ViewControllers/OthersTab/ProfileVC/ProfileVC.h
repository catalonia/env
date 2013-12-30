//
//  ProfileVC.h
//  TasteSync
//
//  Created by Victor on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "CRequest.h"
#import "JSONKit.h"
#import "TextView.h"
@interface ProfileVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UITextViewDelegate, RequestDelegate,TextviewDelegate>
{
    __weak IBOutlet UIView *viewReportUser, *viewSendMsg;
    __weak IBOutlet UITextView *tvReportUser, *tvSendMsg;
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITableView *tbvUserActionRecently;
    __weak IBOutlet UILabel *lbName, *lbDetail,*lbAboutTitle,*lbAboutDetail, *lbYouFollow, *lbRestaurant1, *lbRestaurant2, *lbRestaurant3;
    __weak IBOutlet UIImageView *ivAvatar;
    
    __weak IBOutlet UILabel *lbTrust, *lbReport, *lbFollow, *lbSend, *lbHoverReport, *lbHoverSendMsg;
    
    __weak IBOutlet UIView* recentlyView;
    
    __weak IBOutlet UILabel *lbFollowing, *lbFollowers, *lbFriends, *lbPoints;
    __weak IBOutlet UIButton* btRestaurant1, *btRestaurant2, *btRestaurant3;
}

@property (nonatomic, strong) UserObj *user;
@property (nonatomic, strong) NSString *userID;



- (IBAction)actionReportUser:(id)sender;
- (IBAction)actionCancel:(id)sender;
- (IBAction)actionTrusted:(id)sender;
- (IBAction)actionReport:(id)sender;
- (IBAction)actionUnfollow:(id)sender;
- (IBAction)actionSend:(id)sender;
- (IBAction)actionFollowing:(id)sender;
- (IBAction)actionFollowers:(id)sender;
- (IBAction)actionFriends:(id)sender;
- (IBAction)actionRestaurant:(id)sender;
- (IBAction)actionMoreRestaurant:(id)sender;


@end
