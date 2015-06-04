//
//  PhotoPositioningController.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoPositioningController.h"
#import "MKMapView+Lavahound.h"
#import "UIViewController+Lavahound.h"
#import "LocationTracker.h"
#import "LocalStorage.h"

static NSInteger const kDefaultZoomLevel = 17;

@implementation PhotoPositioningController

#pragma mark -
#pragma mark NSObject

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _mapView = nil;
        _photoAnnotation = nil;
        [self initializeLavahoundNavigationBarWithTitle:@"hide a shot"];
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(didTouchUpInCancelButton)] autorelease];            
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(didTouchUpInDoneButton)] autorelease];           
    }
    
    return self;
}

- (void)dealloc {
    _mapView.delegate = nil;    
    TT_RELEASE_SAFELY(_mapView);
    TT_RELEASE_SAFELY(_photoAnnotation);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;         
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeHybrid;    
    [self.view addSubview:_mapView];
}

- (void)viewDidUnload {
    _mapView.delegate = nil;        
    [_mapView removeFromSuperview];
    TT_RELEASE_SAFELY(_mapView);
    TT_RELEASE_SAFELY(_photoAnnotation);        
    [super viewDidUnload];    
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {    
    // If this is the blue current location dot, replace it with our own version that does not pop up "Current Location" when touched
    if (annotation == mapView.userLocation) {        
        MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithFrame:CGRectZero] autorelease];
        annotationView.image = TTIMAGE(@"bundle://blueDot.png");        
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    
    MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)] autorelease];
    annotationView.image = TTIMAGE(@"bundle://mapPin.png");
    annotationView.draggable = YES;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Show the callout immediately
    [_mapView selectAnnotation:_photoAnnotation animated:YES];    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation  {
    // Don't do this more than once.
    if(_photoAnnotation)
        return;
    
    CLLocation *location = userLocation.location;   
    
    if(location) {    
        Photo *photo = [[[Photo alloc] init] autorelease];
        photo.photoId = [NSNumber numberWithInt:-1];
        photo.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        photo.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        _originalCoordinate = location.coordinate;
        _originalAccuracy = location.horizontalAccuracy;
        
        TT_RELEASE_SAFELY(_photoAnnotation);
        _photoAnnotation = [[PhotoAnnotation alloc] init];
        _photoAnnotation.photo = photo;
        _photoAnnotation.title = @"Is this where you are?";
        _photoAnnotation.subtitle = @"Tap and drag pin if incorrect.";        
        [_mapView addAnnotation:_photoAnnotation];           
        [_mapView setCenterCoordinate:photo.coordinate zoomLevel:kDefaultZoomLevel animated:YES];      
    } else {
        TTAlert(@"You must enable location services to use hide a photo.");
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    TTAlert(@"You must enable location services to use hide a photo.");
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark -
#pragma mark LavahoundSavePhotoApiDelegate

- (void)lavahoundSavePhotoApi:(LavahoundSavePhotoApi *)lavahoundSavePhotoApi didSavePhotoId:(NSNumber *)photoId {
    NSString *url = [NSString stringWithFormat:@"lavahound://saved/%@", photoId];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];
}

#pragma mark -
#pragma mark PhotoPositioningController

- (void)didTouchUpInCancelButton {
    [self dismissModalViewControllerAnimated:YES];    
}

- (void)didTouchUpInDoneButton {
    NSData *mostRecentlyPickedImageData = [LocalStorage sharedInstance].mostRecentlyPickedImageData;
    
    // This should never happen but handle just in case
    if(!mostRecentlyPickedImageData) {
        [self dismissModalViewControllerAnimated:YES];
        TTAlert(@"Sorry, an error occurred and we weren't able to save your photo.");
        return;
    }
            
    LavahoundSavePhotoApi *lavahoundSavePhotoApi = [[[LavahoundSavePhotoApi alloc] init] autorelease];
    lavahoundSavePhotoApi.delegate = self;
    [lavahoundSavePhotoApi savePhoto:mostRecentlyPickedImageData
                          coordinate:_photoAnnotation.coordinate
                  originalCoordinate:_originalCoordinate
                    originalAccuracy:_originalAccuracy];
}

@end