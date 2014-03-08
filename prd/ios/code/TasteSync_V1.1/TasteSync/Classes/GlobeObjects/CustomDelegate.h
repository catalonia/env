//
//  CustomDelegate.h
//  TasteSync
//
//  Created by Phu Phan on 12/1/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol RecomendationDelegate <NSObject>

-(void)reloadRecomendation;

@end

@interface CustomDelegate : NSObject

@property(nonatomic,assign) id<RecomendationDelegate> recomendationDelegate;

@end
