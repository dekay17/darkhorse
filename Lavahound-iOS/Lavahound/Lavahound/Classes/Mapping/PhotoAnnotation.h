//
//  PhotoAnnotation.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Three20/Three20+Additions.h"
#import "Photo.h"

@interface PhotoAnnotation : NSObject<MKAnnotation> {
    Photo *_photo;
    NSString *_title;
    NSString *_subtitle;    
    CLLocationCoordinate2D _coordinate;    
}

@property(nonatomic, retain) Photo *photo;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end