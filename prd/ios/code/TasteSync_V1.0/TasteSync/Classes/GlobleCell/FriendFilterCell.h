//
//  FriendFilterCell.h
//  TasteSync
//
//  Created by Victor on 1/7/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"

@interface FriendFilterCell : UITableViewCell

- (void) initForCell:(UserObj *) user;

- (void) initWithName:(NSString *) aName;



@end
