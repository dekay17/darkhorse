//
//  PlaceAnnotation.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "Place.h"

@implementation PlaceAnnotation

#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
    Place *place = (Place *)self.locatableObject;
    return place.name;
}

- (NSString *)subtitle {
    Place *place = (Place *)self.locatableObject;
    return [NSString stringWithFormat:@"%@ %@", place.huntCount, ([place.huntCount intValue] == 1 ? @"Hunt" : @"Hunts")];
}
            
@end