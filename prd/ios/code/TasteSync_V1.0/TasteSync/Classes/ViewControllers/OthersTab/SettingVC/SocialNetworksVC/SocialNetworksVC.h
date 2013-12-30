//
//  SocialNetworks.h
//  TasteSync
//
//  Created by Mobioneer_TT 1 on 12/19/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRequest.h"
#import "JSONKit.h"

@interface SocialNetworksVC : UIViewController<RequestDelegate>

@property (nonatomic, strong) IBOutlet UIButton *btn_Facebook;
@property (nonatomic, strong) IBOutlet UIButton *btn_Twitter;
@property (nonatomic, strong) IBOutlet UIButton *btn_FourSquare;
@property (nonatomic, strong) IBOutlet UIButton *btn_Tumblr;

//@property (nonatomic, strong) NSMutableArray *arraylistCheckStateOfFavoriteSpot;
//@property (nonatomic, strong) NSMutableArray *arraylistCheckStateOfReviews;
//@property (nonatomic, strong) NSMutableArray *arraylistCheckStateOfRatings;
//@property (nonatomic, strong) NSMutableArray *arraylistCheckStateOfRecommendationsI;
@property (nonatomic, strong) NSMutableArray *listCheckStateOfAllConnections;
@property (nonatomic, strong) NSMutableArray *listCheckStateOfAllPublishing;

- (IBAction)buttonCheckTapper:(UIButton *)button;
- (IBAction)buttonSwitchTapper:(UIButton *)button;

- (void)setStateForSwitchs:(NSMutableArray *)arrayState;
- (void)setStateForbuttonsCheck:(NSMutableArray *)arrayState;
- (void)savelistCheckStateOfAllConnections;
- (void)savelistCheckStateOfAll;
@end
