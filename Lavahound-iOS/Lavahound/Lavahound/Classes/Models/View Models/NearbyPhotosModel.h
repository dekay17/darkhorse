//
//  NearbyPhotosModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PhotosModel.h"

@interface NearbyPhotosModel : PhotosModel {
    CLLocationCoordinate2D _coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end