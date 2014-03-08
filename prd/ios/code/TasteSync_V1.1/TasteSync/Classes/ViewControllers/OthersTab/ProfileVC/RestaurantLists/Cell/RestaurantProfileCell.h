//
//  RestaurantProfileCell.h
//  TasteSync
//
//  Created by Victor on 3/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserObj.h"
#import "RestaurantObj.h"

@interface RestaurantProfileCell : UITableViewCell
{
    __weak IBOutlet UILabel *lbRestaurantName, *lbRestaurantDetail;
    __weak IBOutlet UILabel *lbRecommendations;
    __weak IBOutlet UIImageView *ivAvatar;
    __weak IBOutlet UIButton *btFavs;
    
}

- (void) initForCell:(RestaurantObj *)aRestaurantObj Rec:(BOOL)isRec Sav:(BOOL)isSav Tip:(BOOL)isTip Fav:(BOOL)isFav;

- (IBAction)actionAvatar:(id)sender;
- (IBAction)actionFavs:(id)sender;

@end
