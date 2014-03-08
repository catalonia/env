//
//  EditAboutMeVC.h
//  TasteSync
//
//  Created by Victor on 2/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "CRequest.h"
@protocol EditAboutMeDelegate
-(void)getAboutText:(NSString*)text;
@end

@interface EditAboutMeVC : UIViewController<RequestDelegate>

// if isYourProfile allow edit
// else don't allow

@property (nonatomic, assign) BOOL isYourProfile;
@property (nonatomic, assign) NSString* aboutText;
@property (nonatomic, assign) id<EditAboutMeDelegate> delegate;
- (IBAction)actionEdit:(id)sender;
-(id)initWithAboutText:(NSString*)text;
@end
