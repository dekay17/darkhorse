//
//  NearbyPhotoMapController.m
//  Lavahound
//
//  Created by Mark Allen on 4/28/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyLocationsMapController.h"
#import "NearbyLocationsModel.h"
#import "Location.h"
#import "LocationAnnotation.h"
#import "Photo.h"

@implementation NearbyLocationsMapController

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[NearbyLocationsModel alloc] initWithBoundingCoordinates:self.mapView.boundingCoordinates] autorelease];  
}

#pragma mark -
#pragma mark MapViewController

- (NSString *)reuseIdentifierForAnnotation:(LocatableObjectAnnotation *)annotation {
    Location *location = (Location *)annotation.locatableObject;
    return location.locationType == LocationTypePlace ? @"PlaceReuseIdentifer" : @"PhotoReuseIdentifier";
}

- (LocatableObjectAnnotation *)createAnnotationForModelObject:(id)object {
    Location *location = object;
    LocationAnnotation *annotation = [[[LocationAnnotation alloc] init] autorelease];
    annotation.locatableObject = location;
    return annotation;
}

- (void)didTouchUpInAnnotationViewDetailsButton {    
    LocatableObjectAnnotation *annotation = (LocatableObjectAnnotation *)self.currentlySelectedAnnotation;
    Location *location = (Location *)annotation.locatableObject;
    NSString *url = nil;    
    
    if(location.locationType == LocationTypePlace)
        url = [NSString stringWithFormat:@"lavahound://hunts/%@", location.locationId];
    else
        url = [NSString stringWithFormat:@"lavahound://photo-details/%@", location.locationId];
        
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];            
}

- (NSString *)imageUrlForAnnotation:(LocatableObjectAnnotation *)annotation {
    Location *location = (Location *)annotation.locatableObject;
    return location.imageUrl;
}

- (UIImage *)mapPinImageForAnnotation:(LocatableObjectAnnotation *)annotation {
    Location *location = (Location *)annotation.locatableObject;    
    return location.locationType == LocationTypePlace ? TTIMAGE(@"bundle://mapPinHunts.png") : TTIMAGE(@"bundle://mapPin.png");
}

@end