//
//  ResMoreInfoVC.h
//  TasteSync
//
//  Created by Victor on 1/5/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantObj.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressAnnotation.h"
#import "CRequest.h"
#import "JSONKit.h"

@interface ResMoreInfoVC : UIViewController<RequestDelegate>

@property (nonatomic, strong) RestaurantObj *restaurantObj;

- (id)initWithRestaurantObj:(RestaurantObj*)restaurantObj;
@end
