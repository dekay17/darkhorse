//
//  PhotoGalleryDataSource.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Three20/Three20+Additions.h"
#import "PhotosModel.h"

@interface PhotoGalleryDataSource : TTListDataSource {
    PhotosModel *_photosModel;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate huntId:(NSNumber *)huntId;

@end