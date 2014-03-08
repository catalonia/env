//
//  CommonHelpers.m
//  Pizza
//
//  Created by Victor on 12/14/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import "CommonHelpers.h"
#import "Flurry.h"
#import "AskObject.h"

@implementation CommonHelpers



void debug(NSString *format, ...)
{
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    NSLog(@"%@", msg);
    va_end(args);
#endif
    
}

+(BOOL) isPhone5{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height > 500){
#ifdef DEBUG
        NSLog(@"Height of s : %f",[[UIScreen mainScreen] bounds].size.height);
#endif
        return YES;
    }
    return NO;
}

+(BOOL) isiOS6{
    float currentVersion = 6.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        return TRUE;
    }
    return  FALSE;
    
}

+(NSString*) checkString:(NSString*)str{
    if([str isKindOfClass:([NSNull class])] || str == nil)
        return @"";
    else
        return str;
}

+(NSString *)getJSONString
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CuisineData" ofType:@"txt"];
    NSString *userAgreement = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return userAgreement;
}
+(NSString*)getCityString
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"txt"];
    NSString *userAgreement = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return userAgreement;
}

+(void)writeDataToFile:(NSString*)data
{
    NSString* empty = @"";
    [empty writeToFile:@"UserFriend.txt"
           atomically:NO
             encoding:NSUTF8StringEncoding
                error:nil];
    [data writeToFile:@"UserFriend.txt"
              atomically:NO
                encoding:NSUTF8StringEncoding
                   error:nil];
}
+ (void)writeStringToFile:(NSString*)aString {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"UserFriend.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}
+(UIImage*) generateThumbnailFromImage:(UIImage*)mainImage withSize:(CGSize)destinationSize
{
    UIImage * thumbnail;
    
    
    UIGraphicsBeginImageContext(destinationSize);
    [mainImage drawInRect:CGRectMake(0,0,destinationSize.width, destinationSize.height)];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}
+ (NSString*)readStringFromFile {
    
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"UserFriend.txt";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    // The main act...
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
}
+(NSString *) trim:(NSString *)stringInput{
    NSString *stringOutput = [stringInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return stringOutput;
}

+(void) setBackgroudImageForView:(UIView *)view
{
    
    CGRect frame ;
    if (IS_IPHONE_5) {
        frame = CGRectMake(0, 0, 320, 568);
    }else
    {
        frame = CGRectMake(0, 0, 320, 480);
    }
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:frame] ;
    imgview.image=(![ CommonHelpers isPhone5]) ? [CommonHelpers getImageFromName: BG_IMAGE_5] : [CommonHelpers getImageFromName: BG_IMAGE] ;
    [view addSubview:imgview];
    [view sendSubviewToBack: imgview];
    view.backgroundColor = [UIColor clearColor];
}
+(void)setBottomValue:(NSString*)unreadCounter
{
    if (![unreadCounter isKindOfClass:[NSNull class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [unreadCounter intValue];
        [[[CommonHelpers appDelegate].cTabbar.items objectAtIndex:1] setBadgeValue:unreadCounter];
    }
}
+(UIImage*)getImageFromName:(NSString*)name
{
    NSString *fileName1 = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    return [UIImage imageWithContentsOfFile:fileName1];
}

+ (void) setBackgroudImageForViewRestaurant:(UIView *)view
{
    CGRect frame ;
    if (IS_IPHONE_5) {
        frame = CGRectMake(0, 0, 320, 568);
    }else
    {
        frame = CGRectMake(0, 0, 320, 480);
    }
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:frame] ;
    imgview.image=(![ CommonHelpers isPhone5]) ? [CommonHelpers getImageFromName: BG_RESTAURANT_IMAGE_5] : [CommonHelpers getImageFromName: BG_RESTAURANT_IMAGE] ;
    [view addSubview:imgview];
    [view sendSubviewToBack: imgview];
    view.backgroundColor = [UIColor clearColor];
}

+ (void) showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = tag;
    [alert show];
    alert =nil;
}

+ (void) showInfoAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag
{
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alrt.tag = tag;
    [alrt show];
    //alrt = nil;
}
+ (void) showInfoAlertConnectInternet
{
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"TasteSync" message:@"It appears that you are not connected to the internet. Please connect to the internet and try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alrt.tag = 0;
    [alrt show];
}
+(TSCityObj*)setDefaultCityObj
{
    TSCityObj* cityObj = [[TSCityObj alloc]init];
    cityObj.neighbourhoodID = @"";
    cityObj.uid = @"11756";
    cityObj.country = @"us";
    cityObj.stateName = @"NY";
    cityObj.cityName = @"New York";
    return cityObj;
}

+(TSGlobalObj*)getDefaultCityObj
{
    TSGlobalObj* globalObj = [[TSGlobalObj alloc]init];
    globalObj.name = @"New York, NY";
    TSCityObj* cityObj = [[TSCityObj alloc]init];
    cityObj.neighbourhoodID = @"";
    cityObj.uid = @"11756";
    cityObj.country = @"us";
    cityObj.stateName = @"NY";
    cityObj.cityName = @"New York";
    globalObj.cityObj = cityObj;
    return globalObj;
}

+ (void) setBackgroundImage:(UIImage *)image forButton:(UIButton *)button
{
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
}

+ (AppDelegate*) appDelegate
{
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    return appDelegate;
}

+ (BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

+ (void)clearUserDefault
{
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:kUserDefault];
    //    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:UPDATED_USER];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    UserDefault *user = [UserDefault userDefault];
    user.user = nil;
    user.loginStatus = 0;
    [UserDefault update];
}



+ (void) showShareView:(id<ResShareViewDelegate>) delegate andObj:(id) obj;
{
    ResShareView *shareView = [[ResShareView alloc] initWithFrame:CGRectZero];
    [shareView shareRestaurant:obj andDelegate:delegate];
}

+ (NSDictionary*)getJSONUserObj:(UserObj*)user
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:user.uid  forKey:@"id"];
    [dic setValue:[CommonHelpers commonUntilNull:user.firstname]            forKey:@"firstName"];
    [dic setValue:[CommonHelpers commonUntilNull:user.lastname]             forKey:@"lastName"];
    [dic setValue:[CommonHelpers commonUntilNull:user.email]                forKey:@"email"];
    [dic setValue:[CommonHelpers commonUntilNull:user.avatarUrl]            forKey:@"picture"];
    [dic setValue:[CommonHelpers commonUntilNull:[NSString stringWithFormat:@"%d", user.gender]]         forKey:@"gender"];
    
    [dic setValue:[CommonHelpers commonUntilNull:user.name]                 forKey:@"name"];
    [dic setValue:[CommonHelpers commonUntilNull:user.middle_name]          forKey:@"middleName"];
    [dic setValue:[CommonHelpers commonUntilNull:user.username]             forKey:@"userName"];
    [dic setValue:[CommonHelpers commonUntilNull:user.birthday_date]        forKey:@"birthday"];
    [dic setValue:[CommonHelpers commonUntilNull:user.third_party_id]       forKey:@"thirdPartyId"];
    [dic setValue:[CommonHelpers commonUntilNull:user.install_type]         forKey:@"installed"];
    [dic setValue:[CommonHelpers commonUntilNull:user.relationship_status]  forKey:@"relationshipStatus"];
    [dic setValue:[CommonHelpers commonUntilNull:user.locate]               forKey:@"locale"];
    [dic setValue:[CommonHelpers commonUntilNull:user.link]                 forKey:@"link"];
    [dic setValue:[CommonHelpers commonUntilNull:user.age_range]            forKey:@"ageRange"];
    [dic setValue:[CommonHelpers commonUntilNull:user.device]               forKey:@"devices"];
    [dic setValue:[CommonHelpers commonUntilNull:user.hometown_location]    forKey:@"hometown"];
    [dic setValue:[CommonHelpers commonUntilNull:user.location]             forKey:@"location"];
    [dic setValue:[CommonHelpers commonUntilNull:user.checkIn]              forKey:@"checkins"];
    [dic setValue:[CommonHelpers commonUntilNull:user.friends]              forKey:@"friends"];
    [dic setValue:[CommonHelpers commonUntilNull:user.permission]           forKey:@"permissions"];
//    [dic setValue:[CommonHelpers commonUntilNull:user.city]                 forKey:@"city"];
    
    [dic setValue:[NSString stringWithFormat:@"%d", user.friend_count]         forKey:@"friendlists"];
    [dic setValue:[NSString stringWithFormat:@"%d", user.timezone]             forKey:@"timezone"];
    [dic setValue:[NSString stringWithFormat:@"%d",user.likes_count]           forKey:@"likes"];
    [dic setValue:[NSString stringWithFormat:@"%hhu",user.verified]            forKey:@"verified"];
    return dic;
}

+ (UserObj*)getUserObj:(NSDictionary*)dic
{
    UserObj* user = [[UserObj alloc]init];
    
    user.uid = [dic objectForKey:@"id"];
    user.firstname = [dic objectForKey:@"firstName"];
    user.lastname = [dic objectForKey:@"lastName"];
    user.email = [dic objectForKey:@"email"];
        NSLog(@"picture: %@", [dic objectForKey:@"picture"]);
    user.avatarUrl = [dic objectForKey:@"picture"];
    user.avatar = nil;//[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatarUrl]]];
    user.gender = [[dic objectForKey:@"gender"] intValue];
    
    user.name = [dic objectForKey:@"name"];
    user.middle_name = [dic objectForKey:@"middleName"];
    user.username = [dic objectForKey:@"userName"];
    user.birthday_date = [dic objectForKey:@"birthday"];
    user.third_party_id = [dic objectForKey:@"thirdPartyId"];
    user.install_type = [dic objectForKey:@"installed"];
    user.relationship_status = [dic objectForKey:@"relationshipStatus"];
    user.locate = [dic objectForKey:@"locale"];
    user.link = [dic objectForKey:@"link"];
    user.age_range = [dic objectForKey:@"ageRange"];
    user.device = [dic objectForKey:@"devices"];
    user.hometown_location = [dic objectForKey:@"hometown"];
    user.location = [dic objectForKey:@"location"];
    user.checkIn = [dic objectForKey:@"checkins"];
    user.friends = [dic objectForKey:@"friends"];
    user.permission = [dic objectForKey:@"permissions"];
    //    [dic setValue:[CommonHelpers commonUntilNull:user.city]                 forKey:@"city"];
    
    user.friend_count = [[dic objectForKey:@"friendlists"] intValue];
    user.timezone = [[dic objectForKey:@"timezone"] intValue];
    user.likes_count = [[dic objectForKey:@"likes"] intValue];
    user.verified = [[dic objectForKey:@"verified"] boolValue];
    return user;
}

+ (NSString*)commonUntilNull:(NSString*)data
{
    if (data == NULL)
        return @"";
    else
        return data;
}

+ (NSNumber*)getBoolValue:(NSString*)value
{
    if ([value isEqualToString:@"1"]) {
        return [NSNumber numberWithBool:YES];
    }
    else
        return [NSNumber numberWithBool:NO];
}

+ (NSString*)getStringValue:(NSNumber*)value
{
    if ([value boolValue] == YES) {
        return @"1";
    }
    else
        return @"0";
}

+ (NSString*)getSymbolLocation:(NSString*)location
{
    char array[location.length + 1];
    int count = 0;
    for (int i = 0; i < location.length; i++) {
        char c = [location characterAtIndex:i];
        if (c >= 65 && c <= 90) {
            array[count] = c;
            count++;
        }
    }
    array[count] = '\0';
    return [NSString stringWithCString:array encoding:NSASCIIStringEncoding];
    
}
+(NSString*)getInformationRestaurant:(RestaurantObj*)obj
{
    NSString* retString = @"";
    NSLog(@"'City Name%@", obj.cityObj.cityName);
    //    if (![obj.cuisineTier2 isKindOfClass:[NSNull class]]  && ![obj.cuisineTier2 isEqualToString:@""]) {
    //        retString = obj.cuisineTier2;
    //        if (![obj.cityObj.cityName isKindOfClass:[NSNull class]] && ![obj.cityObj.cityName isEqualToString:@""]) {
    //            retString = [retString stringByAppendingFormat:@", %@", obj.cityObj.cityName];
    //        }
    //    }
    //    else
    //    {
    //        if (![obj.cityObj.cityName isKindOfClass:[NSNull class]]  && ![obj.cityObj.cityName isEqualToString:@""])
    //            retString = obj.cityObj.cityName;
    //    }
    NSString* priceValue= @"";
    int price = [obj.price integerValue];
    switch (price) {
        case 1:
            priceValue = @"$";
            break;
        case 2:
            priceValue = @"$$";
            break;
        case 3:
            priceValue = @"$$$";
            break;
        case 4:
            priceValue = @"$$$$";
            break;
        case 5:
            priceValue = @"$$$$$";
            break;
    }
    if (price > 0) {
        retString = [retString stringByAppendingFormat:@"%@", priceValue];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:obj.lattitude longitude:obj.longtitude];
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];
        CLLocationDistance dist = [loc1 distanceFromLocation:locationManager.location];
        float distanceMiles = (dist / 1609.344);
        if (price != 0) {
            retString = [retString stringByAppendingFormat:@", %.1f mi",distanceMiles];
        }
        else
        {
            retString = [retString stringByAppendingFormat:@"%.1f mi",distanceMiles];
        }
        NSLog(@"%f,%f",locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    }
    
    if ([retString isEqualToString:@""]) {
        
    }
    
    return retString;
}

+ (void)segmentedControChangeColor:(UISegmentedControl*)sender
{
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[sender.subviews objectAtIndex:i]isSelected])
        {
            [[sender.subviews objectAtIndex:i] setTintColor:[UIColor whiteColor]];
        }
        if ([[sender.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && ![[sender.subviews objectAtIndex:i] isSelected])
        {
            [[sender.subviews objectAtIndex:i] setTintColor:[UIColor blackColor]];
        }
    }
}

+(void)implementFlurry:(NSDictionary*)dic forKey:(NSString*)key isBegin:(BOOL)status
{
    if (status) {
        [Flurry logEvent:key withParameters:dic timed:YES];
    }
    else
    {
        [Flurry logEvent:key withParameters:dic timed:YES];
        [Flurry endTimedEvent:key withParameters:dic];
    }
}


+(NSString*)getFilterString:(NSString*)cityid cuisinetier1ID:(NSString*)cuisinetier1idlist  cuisinetier2ID:(NSString*)cuisinetier2idlist neighborhoodid:(NSString*)neighborhoodid occasionidlist:(NSString*)occasionidlist priceidlist:(NSString*)priceidlist themeidlist:(NSString*)themeidlist typeofrestaurantidList:(NSString*)typeofrestaurantidList whoareyouwithidlist:(NSString*)whoareyouwithidlist openNow:(NSString*)openNowFlag FavedFlag:(NSString*)favflag SavedFlag:(NSString*)savedFlag ChainFlag:(NSString*)chainFlag Rate:(NSString*)rate
{
    
    
    NSString* filterString = @"";
    
    
    if (![rate isKindOfClass:[NSNull class]]) {
        if (rate.length > 0) {
            if ([rate intValue] < 5) {
                filterString = [NSString stringWithFormat:@"%@+",rate];
            }
            else
                filterString = rate;
        }
    }
    
    if (![openNowFlag isKindOfClass:[NSNull class]]) {
        if ([[NSString stringWithFormat:@"%@",openNowFlag] isEqualToString:@"1"]) {
            if (filterString.length != 0) {
                filterString = [filterString stringByAppendingString:@", "];
            }
            filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@"Open Now"]];
        }
    }
    
    if (![favflag isKindOfClass:[NSNull class]]) {
        if ([[NSString stringWithFormat:@"%@",favflag] isEqualToString:@"1"]) {
            if (filterString.length != 0) {
                filterString = [filterString stringByAppendingString:@", "];
            }
            filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@"Favs"]];
        }
    }
    
    if (![savedFlag isKindOfClass:[NSNull class]]) {
        if ([[NSString stringWithFormat:@"%@",savedFlag] isEqualToString:@"1"]) {
            if (filterString.length != 0) {
                filterString = [filterString stringByAppendingString:@", "];
            }
            filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@"Saved"]];
        }
    }
    
    if (![chainFlag isKindOfClass:[NSNull class]]) {
        
        if ([[NSString stringWithFormat:@"%@",chainFlag] isEqualToString:@"1"]) {
            if (filterString.length != 0) {
                filterString = [filterString stringByAppendingString:@", "];
            }
            filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@"Include Chains"]];
        }
    }
    
    NSMutableArray* arrayCuisine = [[NSMutableArray alloc]init];
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrCuisine) {
        [arrayCuisine addObject:global];
    }
    
    for (TSGlobalObj* global in [CommonHelpers appDelegate].arrDropdown) {
        int i = 0;
        for (TSGlobalObj* globalCuisine1 in [CommonHelpers appDelegate].arrCuisine) {
            NSString* str1 = [NSString stringWithFormat:@"%@", global.name];
            NSString* str2 = [NSString stringWithFormat:@"%@", globalCuisine1.name];
            i++;
            if ([str1 isEqualToString:str2]) {
                break;
            }
        }
        if (i == [CommonHelpers appDelegate].arrCuisine.count) {
            [arrayCuisine addObject:global];
        }
    }
    
    if (![cuisinetier1idlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [cuisinetier1idlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in arrayCuisine) {
                if ([global.uid isEqualToString:str]) {
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@"%@", global.name]];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![cuisinetier2idlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [cuisinetier2idlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in arrayCuisine) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![occasionidlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [occasionidlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in [CommonHelpers appDelegate].arrOccasion) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![priceidlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [priceidlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in [CommonHelpers appDelegate].arrPrice) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![themeidlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [themeidlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in [CommonHelpers appDelegate].arrTheme) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![typeofrestaurantidList isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [typeofrestaurantidList componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in [CommonHelpers appDelegate].arrTypeOfRestaurant) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![whoareyouwithidlist isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [whoareyouwithidlist componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (TSGlobalObj* global in [CommonHelpers appDelegate].arrWhoAreUWith) {
                if ([global.uid isEqualToString:str]) {
                    
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.name]];
                    }
                    i++;
                }
            }
        }
    }
    
    if (![neighborhoodid isEqualToString:@""]) {
        if (filterString.length != 0) {
            filterString = [filterString stringByAppendingString:@", "];
        }
        int i = 0;
        NSArray* array = [neighborhoodid componentsSeparatedByString:@","];
        for (NSString* str in array) {
            for (AskObject* global in [CommonHelpers appDelegate].arrayNeighberhood) {
                if ([global.object.uid isEqualToString:str]) {
                    if (i == 0) {
                        filterString = [filterString stringByAppendingString:global.object.name];
                    }
                    else
                    {
                        filterString = [filterString stringByAppendingString:[NSString stringWithFormat:@", %@", global.object.name]];
                    }
                    i++;
                    
                }
            }
        }
    }
    
    if (filterString.length != 0) {
        if (![neighborhoodid isEqualToString:@""]) {
            filterString = [filterString stringByAppendingString:@" - NYC"];
        }
        else
            filterString = [filterString stringByAppendingString:@", NYC"];
    }
    else
        filterString = [filterString stringByAppendingString:@"NYC"];
    
    return filterString;
    
}
@end