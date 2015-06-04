//
//  MapViewController.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Three20/Three20+Additions.h"
#import "MKMapView+Lavahound.h"
#import "LocationTracker.h"
#import "LocatableObjectAnnotation.h"
#import "SelectableView.h"
#import "HuntPhotoAnnotation.h"

@interface MapViewController : TTModelViewController<MKMapViewDelegate, LocationTrackerDelegate, SelectableViewDelegate> {
    MKMapView *_mapView;
    BoundingCoordinates *_previousBoundingCoordinates;
    
    // It appears to be undocumented, but MKMapView's addAnnotations: does NOT retain the annotations sent to it.
    // This can cause crashes in some situations.
    // We work around this by holding onto annotations ourselves as an instance variable.
    NSMutableArray *_annotations;
}

- (LocatableObjectAnnotation *)createAnnotationForModelObject:(id)object;
- (NSString *)imageUrlForAnnotation:(LocatableObjectAnnotation *)annotation;
- (void)didTouchUpInAnnotationViewDetailsButton;
- (NSString *)reuseIdentifierForAnnotation:(LocatableObjectAnnotation *)annotation;
- (UIImage *)mapPinImageForAnnotation:(LocatableObjectAnnotation *)annotation;

@property (nonatomic, readonly) MKMapView *mapView;
@property (nonatomic, readonly) id<MKAnnotation> currentlySelectedAnnotation;
@property (nonatomic, readonly) CGFloat yourLocationButtonTopOffset;
@property (nonatomic, readonly) BOOL initiallyCenterOnCurrentLocation;

@end