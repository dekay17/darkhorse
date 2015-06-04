//
//  HuntPhotosModel.h
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PhotosModel.h"

@interface HuntPhotosModel : PhotosModel {
    NSNumber *_huntId;
    CLLocationCoordinate2D _coordinate;
    CLLocationCoordinate2D _centerCoordinate;
    NSInteger _zoomLevel;
}

- (id)initWithHuntId:(NSNumber *)huntId;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate huntId:(NSNumber *)huntId;

@property (nonatomic, readonly) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, readonly) NSInteger zoomLevel;

@end