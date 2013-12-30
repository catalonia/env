//
//  AskContactVC.h
//  TasteSync
//
//  Created by Phu Phan on 11/9/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "JSONKit.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
@protocol AskContactDelegate<NSObject>
-(void)sendRequestData;
@end
@interface AskContactVC : UIViewController<UITableViewDataSource, UITableViewDelegate,RequestDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property(nonatomic,assign) id<AskContactDelegate> delegate;
-(id)initWithAsk:(NSString*)askString WithRecoID:(NSString*)recoID;

@end
