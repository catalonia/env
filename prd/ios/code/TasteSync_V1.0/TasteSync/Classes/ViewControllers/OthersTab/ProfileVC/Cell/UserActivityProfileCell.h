//
//  UserActivityProfileCell.h
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserActivityObj.h"

@interface UserActivityProfileCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbContent;
    __weak IBOutlet UIImageView *ivAvatar;
    
}

- (void) initCell:(UserActivityObj *) anObj;

- (IBAction)actionAvatar:(id)sender;

@end
