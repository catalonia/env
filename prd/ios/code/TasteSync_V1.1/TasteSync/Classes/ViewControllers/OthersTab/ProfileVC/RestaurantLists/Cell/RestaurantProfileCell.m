//
//  RestaurantProfileCell.m
//  TasteSync
//
//  Created by Victor on 3/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import "RestaurantProfileCell.h"
#import "CommonHelpers.h"

@interface RestaurantProfileCell ()
{
    UserObj *userObj ;
    RestaurantObj *restaurantObj;
}

@end

@implementation RestaurantProfileCell

- (void) initForCell:(RestaurantObj *)aRestaurantObj Rec:(BOOL)isRec Sav:(BOOL)isSav Tip:(BOOL)isTip Fav:(BOOL)isFav;
{
    restaurantObj = aRestaurantObj;
    userObj = [[UserObj alloc] init];
    userObj.firstname = @"Rorie";
    userObj.lastname = @"Stephan";
    userObj.avatar = [CommonHelpers getImageFromName:@"avatar.png"];
    if (aRestaurantObj != nil) {
        lbRestaurantName.text = aRestaurantObj.name;
        lbRestaurantDetail.text = [CommonHelpers getInformationRestaurant:aRestaurantObj];
        lbRecommendations.text = @"Rorie S. wrote: xyz";
        
        if (restaurantObj.isFavs && isFav) {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_favs_on.png"] forButton:btFavs];
        }
        if (restaurantObj.isSaved && isSav)
        {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_saved_on.png"] forButton:btFavs];

        }
        if (restaurantObj.isReco && isRec) {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"icon_recommend.png"] forButton:btFavs];
         }
        if (restaurantObj.isTipFlag && isTip) {
            [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_bt_levaveatip.png"] forButton:btFavs];
        }
    }
}

- (IBAction)actionAvatar:(id)sender
{
    [[[CommonHelpers appDelegate ] tabbarBaseVC] actionProfile:userObj];
}
- (IBAction)actionFavs:(id)sender
{
    if (!restaurantObj.isFavs) {
        [CommonHelpers setBackgroundImage:[CommonHelpers getImageFromName:@"ic_favs_on.png"] forButton:btFavs];
        restaurantObj.isFavs = TRUE;
    }
}

@end
