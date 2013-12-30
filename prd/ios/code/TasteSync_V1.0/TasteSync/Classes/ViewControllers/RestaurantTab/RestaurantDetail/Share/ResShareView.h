//
//  ResShareView.h
//  TasteSync
//
//  Created by Victor on 1/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import <Twitter/Twitter.h>


@protocol ResShareViewDelegate <NSObject>

@optional

- (void) resShareViewDidShareViaMessage;
- (void) resShareViewDidShareViaMail;
- (void) resShareViewDidShareViaFacebook;
- (void) resShareViewDidShareViaDirections;
- (void) resShareViewDidShareViaCall;
- (void) resShareViewDidShareViaTwitter;
- (void) resShareViewDidCancel;

@end

@interface ResShareView : UIView
{
    
}

- (IBAction)actionShareViaMessage:(id)sender;
- (IBAction)actionShareViaMail:(id)sender;
- (IBAction)actionShareViaFacebook:(id)sender;
- (IBAction)actionShareViaDirections:(id)sender;
- (IBAction)actionShareViaCall:(id)sender;
- (IBAction)actionShareViaTwitter:(id)sender;
- (IBAction)actionCancel:(id)sender;

@property (nonatomic, strong) id<ResShareViewDelegate> delegate;
@property (nonatomic, strong) RestaurantObj *restaurantObj;
@property (nonatomic, strong ) TWTweetComposeViewController *twtcontroller ;

- (void) shareRestaurant:(RestaurantObj *) resObj andDelegate:(id<ResShareViewDelegate>) i_delegate;


@end
