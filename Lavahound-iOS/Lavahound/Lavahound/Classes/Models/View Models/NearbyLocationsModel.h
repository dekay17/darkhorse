//
//  NearbyLocationsModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "BoundingCoordinates.h"

@interface NearbyLocationsModel : LavahoundModel<ListableModel> {
    BoundingCoordinates *_boundingCoordinates;
    NSMutableArray *_locations;
}

- (id)initWithBoundingCoordinates:(BoundingCoordinates *)boundingCoordinates;

@property(nonatomic, readonly) NSArray *locations;

@end