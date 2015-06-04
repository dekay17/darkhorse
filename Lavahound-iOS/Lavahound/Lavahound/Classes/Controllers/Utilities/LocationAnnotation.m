//
//  LocationAnnotation.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocationAnnotation.h"

@implementation LocationAnnotation

@synthesize location = _location;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init]))
        _location = nil;
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_location);   
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToLocationAnnotation:other];
}

- (NSUInteger)hash {
    return [_location hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LocationAnnotation(%@)", [_location description]];
}

#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
    NSUInteger photosCount = [_location.photos count];    
    return photosCount == 1 ? @"1 Photo" : [NSString stringWithFormat:@"%d Photos", photosCount];
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([_location.latitude doubleValue], [_location.longitude doubleValue]);
}

#pragma mark -
#pragma mark LocationAnnotation

- (BOOL)isEqualToLocationAnnotation:(LocationAnnotation *)locationAnnotation {
    if (self == locationAnnotation)
        return YES;
    return [_location isEqual:locationAnnotation.location];
}

@end