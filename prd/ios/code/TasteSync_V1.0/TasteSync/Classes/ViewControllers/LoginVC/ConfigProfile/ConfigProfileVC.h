//
//  ConfigProfileVC.h
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"

@interface ConfigProfileVC : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,RequestDelegate>
{
    __weak IBOutlet UIView *viewMain, *viewUserInfo,*viewData;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet UILabel *lbName, *lbLocation, *lbInfo;
    __weak IBOutlet UITextField *tfCusine, *tfRestaurant1 , *tfRestaurant2, *tfRestaurant3;
    __weak IBOutlet UIButton *btCheck, *btInvite, *btDone;
    __weak IBOutlet UIImageView *ivAvatar, *ivAvatarFriend;
    
    __weak IBOutlet UITableView *tbvFilter;
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UIImageView* imageProfile;
}

@property (nonatomic, strong) NSMutableArray *arrDataFriends, *arrDataCusine, *arrDataFilter;//*arrDataRestaurant,
@property (nonatomic, strong) NSMutableArray *arrData ; // data of top 5 restaurant

- (IBAction)actionDone:(id)sender;
- (IBAction)actionInvite:(id)sender;
- (IBAction)actionHideKeyPad:(id)sender;



@end
