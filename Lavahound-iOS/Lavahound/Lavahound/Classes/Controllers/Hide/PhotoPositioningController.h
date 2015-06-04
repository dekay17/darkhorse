//
//  PhotoPositioningController.h
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Three20/Three20+Additions.h"
#import "PhotoAnnotation.h"
#import "LavahoundSavePhotoApi.h"

@interface PhotoPositioningController : TTViewController<MKMapViewDelegate, LavahoundSavePhotoApiDelegate> {
    MKMapView *_mapView;
    PhotoAnnotation *_photoAnnotation;
    CLLocationCoordinate2D _originalCoordinate;    
    CLLocationAccuracy _originalAccuracy;
}

@end