//
//  TSPhotoRestaurantObj.h
//  TasteSync
//
//  Created by HP on 8/13/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSPhotoRestaurantObj : NSObject
@property(nonatomic,strong) NSString* uid;
@property(nonatomic,strong) NSString* photoId;
@property(nonatomic,strong) NSString* prefix;
@property(nonatomic,strong) NSString* suffix;
@property(nonatomic,assign) int width;
@property(nonatomic,assign) int height;
@property(nonatomic,strong) NSString* ultimateSourceName;
@property(nonatomic,strong) NSString* ultimateSourceUrl;
@property(nonatomic,strong) NSString* photoSource;
@property(nonatomic,strong) NSString* photoURL;
@property(nonatomic,strong) UIImage* image;
@end
