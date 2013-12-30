//
//  TSGlobalObj.h
//  TasteSync
//
//  Created by HP on 8/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCityObj.h"
#import "RestaurantObj.h"

typedef enum GlobalDataType {
    GlobalDataCuisine_1 =  0,
    GlobalDataCuisine_2  =   1,
    GlobalDataOccasion  =   2,
    GlobalDataPrice  =   3,
    GlobalDataTheme  =   4,
    GlobalDataTypeOfRestaurant  =   5,
    GlobalDataWhoAreUWith  =   6,
    GlobalDataCity = 7,
    GlobalDataRestaurant = 8
    
} GlobalDataType;

@interface TSGlobalObj : NSObject
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) TSCityObj *cityObj;
@property (nonatomic, strong) RestaurantObj* restaurantObj;
@property (nonatomic, assign) GlobalDataType type;
@end
