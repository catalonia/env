//
//  AboutTasteSyncVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellCustomAbout.h"
@interface AboutTasteSyncVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbvContent;
    __weak IBOutlet UILabel *tasteSyncVersion;
}
@property (nonatomic, strong) NSArray *arrAboutContent;

@end
