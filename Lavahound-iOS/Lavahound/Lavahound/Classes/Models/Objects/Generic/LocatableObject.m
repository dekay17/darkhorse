//
//  LocatableObject.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObject.h"
#import "Three20/Three20+Additions.h"

@implementation LocatableObject

@synthesize latitude = _latitude, longitude = _longitude;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _latitude = nil;
        _longitude = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_latitude);
    TT_RELEASE_SAFELY(_longitude);
    [super dealloc];
}

- (NSUInteger)hash {
    return [_latitude hash] * [_longitude hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@, %@)", [self class], _latitude, _longitude];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToLocatableObject:other];
}

#pragma mark -
#pragma mark LocatableObject

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
}

- (BOOL)isEqualToLocatableObject:(LocatableObject *)locatableObject {
    if (self == locatableObject)
        return YES;
    return [_latitude isEqual:locatableObject.latitude] && [_longitude isEqual:locatableObject.longitude];
}

@end