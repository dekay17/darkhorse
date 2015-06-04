//
//  NearbyPlacesModel.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "BoundingCoordinates.h"

@interface NearbyPlacesModel : LavahoundModel<ListableModel> {
    BoundingCoordinates *_boundingCoordinates;
    CLLocationCoordinate2D _coordinate;
    NSMutableArray *_places;
}

// Can take either a lat/long bounding box or a single lat/long
- (id)initWithBoundingCoordinates:(BoundingCoordinates *)boundingCoordinates;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property(nonatomic, readonly) NSArray *places;

@end