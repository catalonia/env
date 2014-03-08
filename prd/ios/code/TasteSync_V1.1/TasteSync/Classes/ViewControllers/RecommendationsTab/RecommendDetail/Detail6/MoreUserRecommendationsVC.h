//
//  MoreUserRecommendationsVC.h
//  TasteSync
//
//  Created by Victor on 3/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"

@interface MoreUserRecommendationsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbv;
}

@property (nonatomic, strong) NSMutableArray *arrData;

-(id)initWithRestaurantObj:(RestaurantObj*)restaurantObj;

@end
