//
//  MapItController.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"
#import "MKMapView+Lavahound.h"
#import "PhotoAnnotation.h"
#import "LavahoundMarkPhotoFoundApi.h"
#import "TabBarController.h"

@interface MapItController : ModelViewController<MKMapViewDelegate, LavahoundMarkPhotoFoundApiDelegate> {
    MKMapView *_mapView;
    PhotoAnnotation *_photoAnnotation;
    NSNumber *_photoId;
}

- (id)initWithPhotoId:(NSNumber *)photoId;
- (void) EventFoundItSelected;

@end