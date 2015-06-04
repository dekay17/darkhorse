//
//  LocatableObjectAnnotation.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocatableObjectAnnotation.h"

@implementation LocatableObjectAnnotation

@synthesize locatableObject = _locatableObject;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init]))
        _locatableObject = nil;
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_locatableObject);   
    [super dealloc];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToLocatableObjectAnnotation:other];
}

- (NSUInteger)hash {
    return [_locatableObject hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LocatableObjectAnnotation(%@)", [_locatableObject description]];
}

#pragma mark -
#pragma mark MKAnnotation

- (NSString *)title {
    return @"TODO";
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([_locatableObject.latitude doubleValue], [_locatableObject.longitude doubleValue]);
}

#pragma mark -
#pragma mark LocatableObjectAnnotation

- (BOOL)isEqualToLocatableObjectAnnotation:(LocatableObjectAnnotation *)locatableObjectAnnotation {
    if (self == locatableObjectAnnotation)
        return YES;
    return [_locatableObject isEqual:locatableObjectAnnotation.locatableObject];
}

@end