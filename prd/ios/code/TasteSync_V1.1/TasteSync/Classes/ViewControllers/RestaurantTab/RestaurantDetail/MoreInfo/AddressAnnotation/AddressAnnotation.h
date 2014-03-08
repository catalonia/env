//
//  AddressAnnotation.h
//  ShareLocation
//
//  Created by Victor NGO on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *name, *details;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

-(NSString *) title;
-(NSString *) subtitle;

-(id) initWithName: (NSString *) _newname details : (NSString *) _newdetails coordinate: (CLLocationCoordinate2D ) _newcoordinate2D ;

@end
