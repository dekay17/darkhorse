//
//  MapViewController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "MapViewController.h"
#import "PhotoMapAnnotationView.h"
#import "TTModelViewController+Lavahound.h"
#import "LocatableObjectAnnotation.h"
#import "NearbyLocationsModel.h"
#import "Constants.h"
#import "Location.h"
#import "Photo.h"

static NSInteger const kDefaultZoomLevel = 14;

@implementation MapViewController

@synthesize mapView = _mapView;

#pragma mark -
#pragma mark NSObject

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _mapView = nil;
        _annotations = [[NSMutableArray alloc] init];
        _previousBoundingCoordinates = [[BoundingCoordinates alloc] initWithSouthWestCoordinate:kCLLocationCoordinate2DInvalid
                                                                            northEastCoordinate:kCLLocationCoordinate2DInvalid];
        [[LocationTracker sharedInstance] addDelegate:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiDataChangedNotification:) 
                                                     name:kLavahoundApiDataChangedNotification
                                                   object:nil];          
    }
    
    return self;
}

- (void)dealloc {
    TTDPRINT(@"Dealloc");    
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [[LocationTracker sharedInstance] removeDelegate:self];    
    _mapView.delegate = nil;    
    TT_RELEASE_SAFELY(_mapView);
    TT_RELEASE_SAFELY(_annotations);
    TT_RELEASE_SAFELY(_previousBoundingCoordinates);    
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];     
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;        
    [self.view addSubview:_mapView];
    
    UIImage *yourLocationButtonImage = TTIMAGE(@"bundle://buttonLocate.png");
    
    UIButton *yourLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[yourLocationButton setImage:yourLocationButtonImage forState:UIControlStateNormal];
    // TODO: calculate this for real instead of using "100" hardcoded slop.
    // Setting to self.view.height - yourLocationButtonImage.size.height - 10 and using UIViewAutoresizingFlexibleBottomMargin wasn't working for me,
    // no time to dig into why...probably something simple.
	yourLocationButton.frame = CGRectMake(self.view.width - 8 - yourLocationButtonImage.size.width, self.view.height - yourLocationButtonImage.size.height - 100 + self.yourLocationButtonTopOffset, yourLocationButtonImage.size.width, yourLocationButtonImage.size.height);
    [yourLocationButton addTarget:self
                           action:@selector(didTouchUpInYourLocationButton)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yourLocationButton];  
    
    if(self.initiallyCenterOnCurrentLocation) {    
        // Center the map on your current location if it's available.
        // Otherwise center on the US.
        CLLocation *location = [LocationTracker sharedInstance].location;    
        if(location)
            [_mapView setCenterCoordinate:location.coordinate zoomLevel:kDefaultZoomLevel animated:YES];        
    }
}

- (void)viewDidUnload {
    _mapView.delegate = nil;        
    [_mapView removeFromSuperview];
    TT_RELEASE_SAFELY(_mapView);
    [_annotations removeAllObjects];
    TT_RELEASE_SAFELY(_previousBoundingCoordinates);
    _previousBoundingCoordinates = [[BoundingCoordinates alloc] initWithSouthWestCoordinate:kCLLocationCoordinate2DInvalid
                                                                        northEastCoordinate:kCLLocationCoordinate2DInvalid];        
    [super viewDidUnload];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[NearbyLocationsModel alloc] initWithBoundingCoordinates:_mapView.boundingCoordinates] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {    
    id<ListableModel> model = (id<ListableModel>)self.model;
    
//    TTDPRINT(@"Map data updated. Showing %d annotations.", [model.items count]);    
    
    // Diff the current set of map pins with the new ones returned from the server.
    // We don't want to blow away and re-add any existing pins that are still visible since
    // that causes an ugly pin view flash, but we do want to deallocate any existing pins
    // that are not in the set of pins returned from the server.
    NSMutableArray *annotationsToRemove = [NSMutableArray array];
    NSMutableArray *annotationsToAdd = [NSMutableArray array];
    NSMutableArray *newAnnotations = [NSMutableArray array];    
    
    for(id item in model.items) {
        id<MKAnnotation> newAnnotation = [self createAnnotationForModelObject:item];     
        [newAnnotations addObject:newAnnotation];
        
        if(![_annotations containsObject:newAnnotation]) {
            //TTDPRINT(@"Adding %@", newAnnotation);
            [annotationsToAdd addObject:newAnnotation];
        }
    }
    
    for(id<MKAnnotation> existingAnnotation in _annotations) {
        BOOL shouldRemove = YES;
        
        for(id<MKAnnotation> newAnnotation in newAnnotations) {
            if([newAnnotation isEqual:existingAnnotation]) {
                shouldRemove = NO;
                break;
            }
        }
        
        if(shouldRemove) {
            //TTDPRINT(@"Removing existing %@", existingAnnotation);
            [annotationsToRemove addObject:existingAnnotation];
        }
    }
    
    // Have to retain our own copy of annotations in the _annotations instance variable
    // in addition to in _mapView because addAnnotations: does NOT retain the annotations you send it.
    // If we didn't retain our own copy, we would see random crashes.
    
    [_mapView removeAnnotations:annotationsToRemove];
    [_annotations removeObjectsInArray:annotationsToRemove];    
    
    [_mapView addAnnotations:annotationsToAdd];    
    [_annotations addObjectsFromArray:annotationsToAdd];       
}

#pragma mark -
#pragma mark LocationTrackerDelegate

- (void)locationTracker:(LocationTracker *)locationTracker didUpdateLocation:(CLLocation *)location {
    // TODO: find out if recentering automatically happens when you physically move around.
    // If not, we should uncomment this.
    // TTDPRINT(@"Your location changed, re-centering map...");
    // [_mapView setCenterCoordinate:location.coordinate];    
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    BoundingCoordinates *boundingCoordinates = mapView.boundingCoordinates;
    
    // The system can send out spurious notifications (i.e. the region did not really change coordinates).
    // If we find that no change occurred, don't bother hitting the server.
    if(boundingCoordinates.northEastCoordinate.latitude != _previousBoundingCoordinates.northEastCoordinate.latitude
       || boundingCoordinates.northEastCoordinate.longitude != _previousBoundingCoordinates.northEastCoordinate.longitude
       || boundingCoordinates.southWestCoordinate.latitude != _previousBoundingCoordinates.southWestCoordinate.latitude
       || boundingCoordinates.southWestCoordinate.longitude != _previousBoundingCoordinates.southWestCoordinate.longitude) {
        // TTDPRINT(@"Map region changed, TODO: load up pins from server. Bounding coordinates are: %@", boundingCoordinates);
        TT_RELEASE_SAFELY(_previousBoundingCoordinates);
        _previousBoundingCoordinates = [boundingCoordinates retain];
        
        [self invalidateModel];
    }
}

// This updates very frequently, about once a second.
// We use locationTracker:didUpdateLocation: instead since it only notifies us when significant changes occur.
// - (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {    
    // If this is the blue current location dot, don't customize it
    if (annotation == mapView.userLocation)
        return nil;
    
	NSString *reuseIdentifier = [self reuseIdentifierForAnnotation:annotation];
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if(annotationView) {
        annotationView.annotation = annotation;
    } else {
        UIImage *chevronImage = TTIMAGE(@"bundle://chevron.png");
        UIButton *photoDetailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoDetailsButton setImage:chevronImage forState:UIControlStateNormal];
        [photoDetailsButton addTarget:self
                               action:@selector(didTouchUpInAnnotationViewDetailsButton)
                     forControlEvents:UIControlEventTouchUpInside];
        photoDetailsButton.frame = CGRectMake(0, 0, chevronImage.size.width, chevronImage.size.height); 
        
        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] autorelease];
        annotationView.image = [self mapPinImageForAnnotation:annotation];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = photoDetailsButton;                         
    }
    
    LocatableObjectAnnotation *locatableObjectAnnotation = (LocatableObjectAnnotation *)annotation;        
    NSString *imageUrlForAnnotation = [self imageUrlForAnnotation:locatableObjectAnnotation];
    
    if(imageUrlForAnnotation) {
        PhotoMapAnnotationView *photoMapAnnotationView = [[[PhotoMapAnnotationView alloc] init] autorelease];
        photoMapAnnotationView.imageUrl = imageUrlForAnnotation;
        photoMapAnnotationView.delegate = self;
        annotationView.leftCalloutAccessoryView = photoMapAnnotationView;               
    } else {
        annotationView.leftCalloutAccessoryView = nil;       
    }
    
    return annotationView;
}

#pragma mark -
#pragma mark SelectableViewDelegate

- (void)didSelectView:(SelectableView *)selectableView {
    [selectableView deselectAfterDelay];
    [self didTouchUpInAnnotationViewDetailsButton];
}

#pragma mark -
#pragma mark MapViewController

- (CGFloat)yourLocationButtonTopOffset {
    return 0;
}

- (NSString *)reuseIdentifierForAnnotation:(LocatableObjectAnnotation *)annotation {
    return @"ReuseIdentifier";
}

- (void)didTouchUpInYourLocationButton {
    // Center the map on your current location if it's available.
    CLLocation *location = _mapView.userLocation.location;
    if(location)
        [_mapView setCenterCoordinate:location.coordinate zoomLevel:kDefaultZoomLevel animated:YES];
    else
        TTAlert(@"Sorry, looks like Location Services for Lavahound are disabled. You must enable them in your device's Settings application to use this feature.");    
}

- (void)didReceiveLavahoundApiDataChangedNotification:(NSNotification *)notification {
    TTDPRINT(@"Received %@, invalidating model data...", [notification name]);
    [self invalidateModelAndNetworkCache];
}

- (id<MKAnnotation>)currentlySelectedAnnotation {
    return [self.mapView.selectedAnnotations objectAtIndex:0];
}

- (LocatableObjectAnnotation *)createAnnotationForModelObject:(id)object {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];    
}

- (UIImage *)mapPinImageForAnnotation:(LocatableObjectAnnotation *)annotation
{
    return TTIMAGE(@"bundle://mapPin.png");
}

- (void)didTouchUpInAnnotationViewDetailsButton {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];       
}

- (NSString *)imageUrlForAnnotation:(LocatableObjectAnnotation *)annotation {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];   
}

-(BOOL)initiallyCenterOnCurrentLocation {
    return YES;
}

@end