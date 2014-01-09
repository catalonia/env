//
//  AskRecommendationsVC.h
//  TasteSync
//
//  Created by Victor on 2/20/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSGlobalObj.h"
#import "CRequest.h"
#import "AskContactVC.h"

@interface AskRecommendationsVC : UIViewController<UITableViewDataSource, UITableViewDelegate, RequestDelegate,AskContactDelegate>
{
    __weak IBOutlet UIView *viewWaiting, *viewMain , *viewNotLogin, *viewLogin, *viewfacebook , *viewFriends;
    __weak IBOutlet UITableView *tbvResult, *tbvFilter;
    __weak IBOutlet UIButton *btPostOnFb, *btNewsfeed, *btSkipThis, *btGotIt,*btRecommend;
    __weak IBOutlet UILabel *lbWaiting;
    __weak IBOutlet UIImageView *imv_frame;
    __weak IBOutlet UITextField *tfAsk;
    __weak IBOutlet UIButton* _submitButton;
    __weak IBOutlet UIButton* _submitButtonImage;
    __weak IBOutlet UIView* _viewAction;
    __weak IBOutlet UIView* _viewProgress;
}

@property(nonatomic, strong) NSMutableArray *arrData, *arrDataFilter, *arrDataFriends;
@property (nonatomic, strong) NSString *askSentences;

- (IBAction)actionOthersTab:(id)sender;
- (IBAction)actionNewsfeedTab:(id)sender;
- (IBAction)actionSkipThis:(id)sender;
- (IBAction)actionPostOnFb:(id)sender;
- (IBAction)actionRecommendations:(id)sender;
- (IBAction)actionGotIt:(id)sender;
- (IBAction)actionNoThanks:(id)sender;
- (IBAction)actionSentEmail:(id)sender;

// action view not login

- (IBAction)actionConnectWithFacebook:(id)sender;
- (IBAction)actionSkipAhead:(id)sender;

-(id)initWithArrayData:(NSMutableArray*)array atLocation:(TSGlobalObj*)location Reco_RequestID:(NSString*)recorequestID;
@end
