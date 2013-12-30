//
//  NSObject_GlobalVariables.h
//  TasteSync
//
//  Created by Victor on 12/18/12.
//  Copyright (c) 2012 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefault.h"

@interface NSObject ()

#define IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define APP_NAME    @"TasteSync"

#define BG_IMAGE    @"appBackground.jpg"
#define BG_IMAGE_5  @"appBackground_568h.jpg"

#define BG_RESTAURANT_IMAGE    @"appBackground.jpg"
#define BG_RESTAURANT_IMAGE_5  @"appBackground_568h.jpg"

#define SEGNMENT_COLOR  [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]

#define SEGNMENT_COLOR_ON  [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]


// define key
#define kUserDefault    @"kUserDefault"
// define url
#define reserveURL  @"http://www.tastesync.com"
#define TASTESYNC_URL   @"http://www.tastesync.com"

#define INSETS_DEFAULT UIEdgeInsetsMake(0, boundsSize.width, 0, boundsSize.width)
#define INSETS_LEFT UIEdgeInsetsMake(0, boundsSize.width, 0, 0)
#define INSETS_RIGHT UIEdgeInsetsMake(0, 0, 0, boundsSize.width)
#define OFFSET_DEFAULT CGPointMake(0, 0)

@end
