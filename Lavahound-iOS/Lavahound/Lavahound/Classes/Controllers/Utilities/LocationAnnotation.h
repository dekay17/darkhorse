//
//  LocationAnnotation.h
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Three20/Three20+Additions.h"
#import "Location.h"

@interface LocationAnnotation : NSObject<MKAnnotation> {
    Location *_location;    
}

- (BOOL)isEqualToLocationAnnotation:(LocationAnnotation *)locationAnnotation;

@property(nonatomic, retain) Location *location;

@end