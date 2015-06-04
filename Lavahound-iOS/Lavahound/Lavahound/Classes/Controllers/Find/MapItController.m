//
//  MapItController.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "MapItController.h"
#import "PhotoDetailsModel.h"
#import "UIViewController+Lavahound.h"
#import "NSString+Lavahound.h"
#import "PhotoMapAnnotationView.h"

static NSInteger const kDefaultZoomLevel = 14;

@implementation MapItController

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _mapView = nil;
        _photoAnnotation = nil;
        _photoId = [photoId retain];
        [self addPointsButtonToNavigationBar];        
    }
    
    return self;
}

- (void)dealloc {
    _mapView.delegate = nil;
    TT_RELEASE_SAFELY(_mapView);
    TT_RELEASE_SAFELY(_photoAnnotation);
    TT_RELEASE_SAFELY(_photoId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MKMapView alloc] initWithFrame:_modelView.frame];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;        
    [_modelView addSubview:_mapView];
}

- (void)viewDidUnload {
    _mapView.delegate = nil;
    [_mapView removeFromSuperview];    
    TT_RELEASE_SAFELY(_mapView);    
    TT_RELEASE_SAFELY(_photoAnnotation);    
    [super viewDidUnload];
}

- (void) EventFoundItSelected
{
    LavahoundMarkPhotoFoundApi *lavahoundMarkPhotoFoundApi = [[[LavahoundMarkPhotoFoundApi alloc] init] autorelease];
    lavahoundMarkPhotoFoundApi.delegate = self;
    [lavahoundMarkPhotoFoundApi markFoundWithPhotoId:_photoId];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[PhotoDetailsModel alloc] initWithPhotoId:_photoId] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;

    [self setTitleWithLavahoundFont: photo.owner ? @"your photo" : (photo.found ? @"you found this!" : @"find this!")];
    
    PhotoAnnotation *photoAnnotation = [[PhotoAnnotation alloc] init];
    photoAnnotation.photo = photo;
    photoAnnotation.title = @"Photo";
    
    TT_RELEASE_SAFELY(_photoAnnotation);
    _photoAnnotation = photoAnnotation;
    
    [_mapView addAnnotation:photoAnnotation];                
    [_mapView setCenterCoordinate:photo.coordinate zoomLevel:kDefaultZoomLevel animated:YES];  
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {    
    // If this is the blue current location dot, don't customize it
    if (annotation == mapView.userLocation)
        return nil;
    
    PhotoAnnotation *photoAnnotation = (PhotoAnnotation *)annotation;
    
	MKAnnotationView *annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];    
    annotationView.canShowCallout = NO;
//    annotationView.canShowCallout = YES;

    
    if(!photoAnnotation.photo.owner && !photoAnnotation.photo.found) {
//        UIButton *foundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [foundButton setTitle:@"Found!" forState:UIControlStateNormal];
//        [foundButton addTarget:self
//                        action:@selector(didTouchUpInFoundButton)
//              forControlEvents:UIControlEventTouchUpInside];
//        foundButton.frame = CGRectMake(10, 20, 80, 24);     
//                
//        annotationView.rightCalloutAccessoryView = foundButton;
        
        annotationView.image = TTIMAGE(@"bundle://mapPin.png");
    }
    else
    {
        annotationView.image = [UIImage imageNamed:@"mapPinFound.png"];
        
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Show the callout immediately
    [_mapView selectAnnotation:_photoAnnotation animated:YES];    
}

#pragma mark -
#pragma mark LavahoundMarkPhotoFoundApiDelegate

- (void)lavahoundMarkPhotoFoundApi:(LavahoundMarkPhotoFoundApi *)lavahoundMarkPhotoFoundApi didMarkFoundWithMessage:(NSString *)message points:(NSNumber *)points {
    TabBarController * TabController = nil;
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;    
    NSString *url = [NSString stringWithFormat:@"lavahound://found/%@/%@/%@", photo.photoId, [message urlEncode], points];    
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];
    
    if (!(photo.found || photo.owner))
    {
    }
    else
    {
        TabController = (TabBarController*) self.tabBarController;
        [TabController setFoundItButtonVisibility:FALSE animated:TRUE];
    }
}

#pragma mark -
#pragma mark MapItController

- (void)didTouchUpInFoundButton {
    LavahoundMarkPhotoFoundApi *lavahoundMarkPhotoFoundApi = [[[LavahoundMarkPhotoFoundApi alloc] init] autorelease];
    lavahoundMarkPhotoFoundApi.delegate = self;
    [lavahoundMarkPhotoFoundApi markFoundWithPhotoId:_photoId];    
}

@end