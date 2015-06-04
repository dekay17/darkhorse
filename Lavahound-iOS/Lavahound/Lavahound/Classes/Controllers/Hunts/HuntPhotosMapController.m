//
//  HuntPhotosMapController.m
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntPhotosMapController.h"
#import "HuntPhotosModel.h"
#import "Photo.h"
#import "HuntPhotoAnnotation.h"

@implementation HuntPhotosMapController

#pragma mark -
#pragma mark NSObject

- (id)initWithHuntId:(NSNumber *)huntId {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _huntId = [huntId retain];
        _shouldCenterMapOnHuntCenter = YES;
    }

    return self;    
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_huntId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidUnload {
    _shouldCenterMapOnHuntCenter = YES;
    [super viewDidUnload];    
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel
{
    self.model = [[[HuntPhotosModel alloc] initWithHuntId:_huntId] autorelease];
}

- (void)showModel:(BOOL)show {
    [super showModel:show];
    
    // Only center on the hunt the first time we load.
    if(_shouldCenterMapOnHuntCenter) {
        _shouldCenterMapOnHuntCenter = NO;        
        HuntPhotosModel *huntPhotosModel = (HuntPhotosModel *)self.model;
        [_mapView setCenterCoordinate:huntPhotosModel.centerCoordinate zoomLevel:huntPhotosModel.zoomLevel animated:NO];
    }
}

#pragma mark -
#pragma mark MapViewController

- (CGFloat)yourLocationButtonTopOffset
{
    return -26;
}

- (LocatableObjectAnnotation *)createAnnotationForModelObject:(id)object {
    Photo *photo = object;
    HuntPhotoAnnotation *annotation = [[[HuntPhotoAnnotation alloc] init] autorelease];
    annotation.locatableObject = photo;
    return annotation;
}

- (void)didTouchUpInAnnotationViewDetailsButton {    
    // Pick out the selected annotation and open its photo
    LocatableObjectAnnotation *annotation = (LocatableObjectAnnotation *)self.currentlySelectedAnnotation;
    Photo *photo = (Photo *)annotation.locatableObject;
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[photo URLValueWithName:@"details"]] applyAnimated:YES]];     
}

- (UIImage *)mapPinImageForAnnotation:(LocatableObjectAnnotation *)annotation
{
    Photo * PhotoForAnno = nil;
    UIImage * PinImage = nil;
    
    PhotoForAnno = (Photo*) annotation.locatableObject;
    
    if (PhotoForAnno.found)
    {
        PinImage = [UIImage imageNamed:@"mapPinFound.png"];
    }
    else
    {
        PinImage = [super mapPinImageForAnnotation:annotation];
    }

    return PinImage;
}

- (NSString *)imageUrlForAnnotation:(LocatableObjectAnnotation *)annotation
{
    Photo *photo = (Photo *)annotation.locatableObject;
    
    return photo.imageUrl;
}

-(BOOL)initiallyCenterOnCurrentLocation
{
    return NO;
}

@end