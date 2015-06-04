//
//  BoundingCoordinates.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "BoundingCoordinates.h"

@implementation BoundingCoordinates

@synthesize southWestCoordinate = _southWestCoordinate, northEastCoordinate = _northEastCoordinate;

- (id)initWithSouthWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate {
    if((self = [super init])) {
        _southWestCoordinate = southWestCoordinate;
        _northEastCoordinate = northEastCoordinate;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Southwest coordinate: lat %f, lng %f, Northeast coordinate: lat %f, lng %f",
            _southWestCoordinate.latitude, _southWestCoordinate.longitude, _northEastCoordinate.latitude, _northEastCoordinate.longitude];
}

@end