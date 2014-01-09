//
//  SelfProfileVC.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/24/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "EditAboutMeVC.h"

@interface SelfProfileVC : UIViewController <UITableViewDataSource,
UITableViewDelegate, UIActionSheetDelegate, RequestDelegate, EditAboutMeDelegate>
{
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UITableView *tbvUsersRecommendations;
    __weak IBOutlet UILabel *lbUserName, *lbUserDetail, *lbAboutTitle, *lbAboutDetail, *lbFollowing, *lbFollowers, *lbFriends, *lbPoints, *lbRestaurant1, *lbRestaurant2, *lbRestaurant3;
    __weak IBOutlet UIView *viewRecentActivity;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UIButton* btRestaurant1, *btRestaurant2, *btRestaurant3;
}

- (IBAction)actionSettings:(id)sender;
- (IBAction)actionEdit:(id)sender;
- (IBAction)actionFollowing:(id)sender;
- (IBAction)actionFollowers:(id)sender;
- (IBAction)actionFriends:(id)sender;
- (IBAction)actionRestaurant:(id)sender;
- (IBAction)actionMoreRestaurant:(id)sender;
- (IBAction)actionFacebook:(id)sender;
- (IBAction)actionTwitter:(id)sender;
- (IBAction)actionBlog:(id)sender;

@end
