//
//  ContactObject.h
//  TasteSync
//
//  Created by Phu Phan on 11/9/13.
//  Copyright (c) 2013 Mobioneer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactObject : NSObject
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSMutableArray* phone;
@property(nonatomic,strong) NSMutableArray* email;
@property(nonatomic,strong) NSString* tasteSyncID;
@property(nonatomic,assign) BOOL isTasteSyncUser;

@property(nonatomic,assign) BOOL isSendEmail;
@property(nonatomic,assign) BOOL isSendPhone;
@property(nonatomic,assign) BOOL isSendTasteSync;

@end
