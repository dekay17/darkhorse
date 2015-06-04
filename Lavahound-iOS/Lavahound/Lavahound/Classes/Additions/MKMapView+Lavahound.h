//
//  MKMapView+Lavahound.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BoundingCoordinates.h"

@interface MKMapView(Lavahound)

// This code is provided by https://github.com/jdp-global/MKMapViewZoom

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

-(MKCoordinateRegion)coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                    andZoomLevel:(NSUInteger)zoomLevel;

@property(nonatomic, readonly) NSUInteger zoomLevel;

// This code is provided by http://stackoverflow.com/questions/2081753/getting-the-bounds-of-an-mkmapview

@property(nonatomic, readonly) BoundingCoordinates *boundingCoordinates;

@end