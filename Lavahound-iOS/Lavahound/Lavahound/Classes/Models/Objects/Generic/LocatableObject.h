//
//  LocatableObject.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LocatableObject : NSObject {
    NSNumber *_latitude;
    NSNumber *_longitude;
}

- (BOOL)isEqualToLocatableObject:(LocatableObject *)locatableObject;

@property(nonatomic, retain) NSNumber *latitude;
@property(nonatomic, retain) NSNumber *longitude;

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end