//
//  AddressAnnotation.m
//  ShareLocation
//
//  Created by Victor NGO on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation

@synthesize name,details,coordinate;

-(NSString *) title
{
    return name;
}
-(NSString *) subtitle
{
    return details;
}

-(id) initWithName: (NSString *) _newname details : (NSString *) _newdetails coordinate : (CLLocationCoordinate2D ) _newcoordinate2D 
{
    self = [super init];
    if (self) {
        self.name = _newname;
        self.details = _newdetails;
        self.coordinate = _newcoordinate2D;
    }
    
    return self;
}


@end
