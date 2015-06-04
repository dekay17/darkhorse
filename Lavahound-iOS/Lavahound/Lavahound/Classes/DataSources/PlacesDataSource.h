//
//  PlacesDataSource.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "NearbyPlacesModel.h"

@interface PlacesDataSource : TTListDataSource {
    NearbyPlacesModel *_nearbyPlacesModel;    
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end