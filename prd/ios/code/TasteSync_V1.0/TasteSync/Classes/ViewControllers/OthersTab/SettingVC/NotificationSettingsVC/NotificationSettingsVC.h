//
//  NotificationSettingsVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"

@interface NotificationSettingsVC : UIViewController<RequestDelegate>


@property (nonatomic, weak) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) NSMutableArray *listCheckStateNotificationSettings;

- (IBAction)buttonCheckTapper:(UIButton *)button;
- (void)setStateForbuttonsCheck:(NSMutableArray *)arrayState;
- (void)savelistCheckStateOfAll;

@end
