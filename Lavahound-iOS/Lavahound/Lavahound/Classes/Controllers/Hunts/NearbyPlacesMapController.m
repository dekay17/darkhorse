//
//  NearbyPlacesMapController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyPlacesMapController.h"
#import "NearbyPlacesModel.h"
#import "PlaceAnnotation.h"
#import "Place.h"

@implementation NearbyPlacesMapController

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[NearbyPlacesModel alloc] initWithBoundingCoordinates:self.mapView.boundingCoordinates] autorelease];  
}

#pragma mark -
#pragma mark MapViewController

- (LocatableObjectAnnotation *)createAnnotationForModelObject:(id)object {
    Place *place = object;
    PlaceAnnotation *annotation = [[[PlaceAnnotation alloc] init] autorelease];
    annotation.locatableObject = place;
    return annotation;
}

- (void)didTouchUpInAnnotationViewDetailsButton {         
    LocatableObjectAnnotation *annotation = (LocatableObjectAnnotation *) self.currentlySelectedAnnotation;
    Place *place = (Place *)annotation.locatableObject;
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[place URLValueWithName:@"hunts"]] applyAnimated:YES]];
}

- (NSString *)imageUrlForAnnotation:(LocatableObjectAnnotation *)annotation {
    Place *place = (Place *)annotation.locatableObject;
    return place.imageUrl;
}

- (UIImage *)mapPinImageForAnnotation:(LocatableObjectAnnotation *)annotation {
    return TTIMAGE(@"bundle://mapPinHunts.png");
}

@end