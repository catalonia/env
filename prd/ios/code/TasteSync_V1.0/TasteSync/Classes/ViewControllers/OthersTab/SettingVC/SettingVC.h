//
//  SettingVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellCustomSetting.h"
#import "CRequest.h"

@interface SettingVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,RequestDelegate>
{
    __weak IBOutlet UITableView *tbvContent;
}

@property (nonatomic, strong) NSArray *arrSettingContent;


@end
