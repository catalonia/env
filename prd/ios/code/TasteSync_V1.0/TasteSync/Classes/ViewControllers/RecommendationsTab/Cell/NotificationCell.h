//
//  NotificationCell.h
//  TasteSync
//
//  Created by Victor on 12/26/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationObj.h"
#import "RestaurantObj.h"

@interface NotificationCell : UITableViewCell

- (void) initForView:(NotificationObj *)obj;

@end
