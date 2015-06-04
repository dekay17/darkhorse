//
//  BoundingCoordinates.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface BoundingCoordinates : NSObject {
    CLLocationCoordinate2D _southWestCoordinate;
    CLLocationCoordinate2D _northEastCoordinate;
}

- (id)initWithSouthWestCoordinate:(CLLocationCoordinate2D)southWestCoordinate northEastCoordinate:(CLLocationCoordinate2D)northEastCoordinate;

@property(nonatomic, assign) CLLocationCoordinate2D southWestCoordinate;
@property(nonatomic, assign) CLLocationCoordinate2D northEastCoordinate;

@end