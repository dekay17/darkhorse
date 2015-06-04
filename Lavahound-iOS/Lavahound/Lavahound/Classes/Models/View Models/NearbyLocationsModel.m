//
//  NearbyLocationsModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyLocationsModel.h"
#import "Location.h"

@implementation NearbyLocationsModel

@synthesize locations = _locations;

#pragma mark -
#pragma mark NSObject

- (id)initWithBoundingCoordinates:(BoundingCoordinates *)boundingCoordinates {
    if((self = [super init])) {
        _locations = [[NSMutableArray alloc] init];
        _boundingCoordinates = [boundingCoordinates retain];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_boundingCoordinates);
    TT_RELEASE_SAFELY(_locations);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (TTURLRequestCachePolicy)cachePolicy {
    return TTURLRequestCachePolicyNone;
}

- (NSDictionary *)parameters {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:_boundingCoordinates.northEastCoordinate.latitude], @"ne_lat",
            [NSNumber numberWithDouble:_boundingCoordinates.northEastCoordinate.longitude], @"ne_lng",
            [NSNumber numberWithDouble:_boundingCoordinates.southWestCoordinate.latitude], @"sw_lat",
            [NSNumber numberWithDouble:_boundingCoordinates.southWestCoordinate.longitude], @"sw_lng",
            nil];
}

- (NSString *)relativeUrl {
	return @"/locations/nearby";
}

- (void)processResponse:(NSDictionary *)json {
    [_locations removeAllObjects];
    for (NSDictionary *locationJson in [json objectForKey:@"locations"])
        [_locations addObject:[Location locationFromJson:locationJson]];
}

#pragma mark -
#pragma mark ListableModel

- (NSArray *)items {
    return _locations;
}

@end