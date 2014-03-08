//
//  HighlightText.h
//  TestTextfield
//
//  Created by HP on 9/16/13.
//  Copyright (c) 2013 Mobioneer HV 02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighlightText : NSObject
@property(nonatomic,assign) int beginLocation;
@property(nonatomic,assign) int endLocation;
@property(nonatomic,strong) NSString* text;
@property(nonatomic,assign) BOOL isInsert;
@property(nonatomic,assign) id userObj;
@end
