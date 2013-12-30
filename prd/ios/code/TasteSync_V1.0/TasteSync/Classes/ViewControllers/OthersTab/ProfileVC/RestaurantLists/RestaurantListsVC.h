//
//  RestaurantListsVC.h
//  TasteSync
//
//  Created by Victor on 3/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import "RestaurantProfileCell.h"
#import "JSONKit.h"
#import "CRequest.h"

@interface RestaurantListsVC : UIViewController<UITableViewDataSource,UITableViewDelegate, RequestDelegate>
{
    __weak IBOutlet UIView *viewMain, *viewFilter, *viewFilterExtends;
    __weak IBOutlet UIScrollView *scrollViewMain;
    __weak IBOutlet  UILabel *lbTitle;
    __weak IBOutlet UIButton *btRecommended, *btFavs, *btTips, *btSaved;
    __weak IBOutlet UITableView *tbvRestaurant;
}

- (IBAction)actionBack:(id)sender;
- (IBAction)actionNewsfeed:(id)sender;
- (IBAction)actionFilter:(id)sender;
- (IBAction)actionChooseFilter:(id)sender;

@property (nonatomic, strong) UserObj *userObj;

@property (nonatomic, strong) NSMutableArray *arrDataRestaurant;


@end
