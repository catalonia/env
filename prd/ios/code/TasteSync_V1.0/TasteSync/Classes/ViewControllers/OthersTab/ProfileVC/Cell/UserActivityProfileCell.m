//
//  UserActivityProfileCell.m
//  TasteSync
//
//  Created by Victor on 3/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "UserActivityProfileCell.h"

@interface UserActivityProfileCell ()
{
    UserActivityObj *activityObj;
}

@end

@implementation UserActivityProfileCell

- (void) initCell:(UserActivityObj *) anObj
{
    activityObj = anObj;
    if (anObj) {
        ivAvatar.image = anObj.user.avatar;
        lbContent.text = @"Victor N recommendations ...";
    }
    
}

- (IBAction)actionAvatar:(id)sender
{
    
}


@end
