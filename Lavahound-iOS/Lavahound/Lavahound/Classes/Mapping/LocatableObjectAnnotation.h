//
//  LocatableObjectAnnotation.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Three20/Three20+Additions.h"
#import "LocatableObject.h"

@interface LocatableObjectAnnotation : NSObject<MKAnnotation> {
    LocatableObject *_locatableObject;
}

- (BOOL)isEqualToLocatableObjectAnnotation:(LocatableObjectAnnotation *)locatableObjectAnnotation;

@property(nonatomic, retain) LocatableObject *locatableObject;

@end