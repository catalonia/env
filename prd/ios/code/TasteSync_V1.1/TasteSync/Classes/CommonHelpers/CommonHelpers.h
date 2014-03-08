//
//  CommonHelpers.h
//  Pizza
//
//  Created by Victor on 12/14/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Messages.h"
//#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "UserDefault.h"
#import "ResShareView.h"
#import "TSGlobalObj.h"
//#import "ResShareFB.h"
#define heightLength 38

@interface CommonHelpers : NSObject


void debug(NSString *format, ...);

+(NSString*) trim:(NSString *)stringInput;

+(BOOL) isPhone5;

+(BOOL) isiOS6;

+(NSString*)getJSONString;
+(NSString*) checkString:(NSString*)str;
+(NSString*)getCityString;

+(void)writeDataToFile:(NSString*)data;
+ (void)writeStringToFile:(NSString*)aString;
+ (NSString*)readStringFromFile;
+ (void) setBackgroudImageForView:(UIView *)view;
+(UIImage*) generateThumbnailFromImage:(UIImage*)mainImage withSize:(CGSize)destinationSize;
+ (void) setBackgroudImageForViewRestaurant:(UIView *)view;
+(UIImage*)getImageFromName:(NSString*)name;
+ (void) showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger) tag;
+(void)setBottomValue:(NSString*)unreadCounter;
+ (void) showInfoAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;
+ (void) showInfoAlertConnectInternet;

+ (void) setBackgroundImage:(UIImage *)image forButton:(UIButton *)button;

+ (AppDelegate*) appDelegate;

+ (BOOL) validateEmail: (NSString *) email;

+ (void) clearUserDefault;

+ (void) showShareView:(id<ResShareViewDelegate>) delegate andObj:(id) obj;

+ (NSDictionary*)getJSONUserObj:(UserObj*)user;

+ (UserObj*)getUserObj:(NSDictionary*)dictionary;

+ (NSString*)commonUntilNull:(NSString*)data;

+ (NSNumber*)getBoolValue:(NSString*)value;

+ (NSString*)getStringValue:(NSNumber*)value;

+ (NSString*)getSymbolLocation:(NSString*)location;

+(NSString*)getInformationRestaurant:(RestaurantObj*)obj;

+(TSCityObj*)setDefaultCityObj;

+(TSGlobalObj*)getDefaultCityObj;
+ (void)segmentedControChangeColor:(UISegmentedControl*)sender;
+(void)implementFlurry:(NSDictionary*)dic forKey:(NSString*)key isBegin:(BOOL)status;
+(NSString*)getFilterString:(NSString*)cityid cuisinetier1ID:(NSString*)cuisinetier1idlist  cuisinetier2ID:(NSString*)cuisinetier2idlist neighborhoodid:(NSString*)neighborhoodid occasionidlist:(NSString*)occasionidlist priceidlist:(NSString*)priceidlist themeidlist:(NSString*)themeidlist typeofrestaurantidList:(NSString*)typeofrestaurantidList whoareyouwithidlist:(NSString*)whoareyouwithidlist openNow:(NSString*)openNowFlag FavedFlag:(NSString*)favflag SavedFlag:(NSString*)savedFlag ChainFlag:(NSString*)chainFlag Rate:(NSString*)rate;
@end
