//
//  RestaurantObj.h
//  TasteSync
//
//  Created by Victor on 2/19/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCityObj.h"

typedef enum
{
    RestaurantTypeNone = 0,
    RestaurantTypeFavorated = 1,
    RestaurantTypeRecomodation = 2,
    RestaurantTypeSaved = 3,
    RestaurantTypeTips = 4
}RestaurantType;

@interface RestaurantObj : NSObject

@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString *name,*nation;
@property (nonatomic, assign) float longtitude,lattitude;
@property (nonatomic, assign) float rates;
@property (nonatomic, assign) BOOL isSelected; 
@property (nonatomic, assign) BOOL isDeal;
@property (nonatomic, assign) RestaurantType type;

@property(nonatomic, strong) NSString* deal;
@property (nonatomic, assign) BOOL isOpenNow;
@property (nonatomic, assign) BOOL isMoreInfo;
@property (nonatomic, assign) BOOL isMenuFlag;
@property (nonatomic, assign) BOOL isTipFlag;

@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, assign) BOOL isFavs;
@property (nonatomic, assign) BOOL isReco;
@property (nonatomic, assign) BOOL isCheckin;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) BOOL userSavedFlag;
@property (nonatomic, assign) BOOL userFavFlag;
@property (nonatomic, assign) BOOL userRecommendedFlag;
@property (nonatomic, assign) BOOL userTipFlag;
@property (nonatomic, assign) int allowSize;
@property (nonatomic, assign) BOOL liked;

@property(nonatomic,strong)  NSString* factualId, *factualRating, *priceRange, *restaurantHours, *sumVoteCount, *sumVoteValue, *tbdOpenTableId, *address;

@property(nonatomic,strong) NSString* cuisineTier2;
@property(nonatomic,strong) NSMutableArray* cuisineTier2Array;
@property (nonatomic, strong) NSString* price;

@property(nonatomic,strong) TSCityObj* cityObj;
@property(nonatomic,strong) NSMutableArray* recommendArray;

@property(nonatomic,strong) NSString* website;
@property(nonatomic,assign) BOOL healthyOptionsFlag;
@property(nonatomic,assign) BOOL wifiFlag;
@property(nonatomic,assign) BOOL payCashonlyFlag;
@property(nonatomic,assign) BOOL reservationsFlag;
@property(nonatomic,assign) BOOL open24HoursFlag;
@property(nonatomic,assign) BOOL parkingFlag;
@property(nonatomic,assign) BOOL parkingValetFlag;
@property(nonatomic,assign) BOOL parkingFreeFlag;
@property(nonatomic,assign) BOOL parkingGarageFlag;
@property(nonatomic,assign) BOOL parkingLotFlag;
@property(nonatomic,assign) BOOL parkingStreetFlag;
@property(nonatomic,assign) BOOL parkingValidatedFlag;
@property(nonatomic,assign) BOOL smokingFlag;
@property(nonatomic,assign) BOOL accessibleWheelchairFlag;
@property(nonatomic,assign) BOOL alcoholFlag;
@property(nonatomic,assign) BOOL alcoholBarFlag;
@property(nonatomic,assign) BOOL alcoholBeerWineFlag;
@property(nonatomic,assign) BOOL alcoholByobFlag;
@property(nonatomic,assign) BOOL groupsGoodForFlag;
@property(nonatomic,assign) BOOL kidsGoodForFlag;
@property(nonatomic,assign) BOOL kidsMenuFlag;
@property(nonatomic,assign) BOOL mealBreakfastFlag;
@property(nonatomic,assign) BOOL mealCaterFlag;
@property(nonatomic,assign) BOOL mealDeliverFlag;
@property(nonatomic,assign) BOOL mealDinnerFlag;
@property(nonatomic,assign) BOOL mealLunchFlag;
@property(nonatomic,assign) BOOL mealTakeoutFlag;
@property(nonatomic,assign) BOOL optionsGlutenfreeFlag;
@property(nonatomic,assign) BOOL optionsLowfatFlag;
@property(nonatomic,assign) BOOL optionsOrganicFlag;
@property(nonatomic,assign) BOOL optionsVeganFlag;
@property(nonatomic,assign) BOOL optionsVegetarianFlag;
@property(nonatomic,assign) BOOL roomPrivateFlag;
@property(nonatomic,assign) BOOL seatingOutdoorFlag;
@end
