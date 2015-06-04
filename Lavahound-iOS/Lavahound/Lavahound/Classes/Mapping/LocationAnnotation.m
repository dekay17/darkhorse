//
//  LocationAnnotation.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocationAnnotation.h"
#import "Location.h"

@implementation LocationAnnotation

#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
    Location *location = (Location *)self.locatableObject;
    return location.locationType == LocationTypePlace ? location.placeName : @"Photo";     
}

- (NSString *)subtitle {
    Location *location = (Location *)self.locatableObject;
    return location.locationType == LocationTypePlace ? [NSString stringWithFormat:@"%@ %@", location.huntCount, [location.huntCount intValue] == 1 ? @"Hunt" : @"Hunts"] : nil; 
}

@end