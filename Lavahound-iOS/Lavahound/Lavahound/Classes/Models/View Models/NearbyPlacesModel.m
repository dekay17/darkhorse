//
//  NearbyPlacesModel.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyPlacesModel.h"
#import "Place.h"

@implementation NearbyPlacesModel

@synthesize places = _places;

#pragma mark -
#pragma mark NSObject

- (id)initWithBoundingCoordinates:(BoundingCoordinates *)boundingCoordinates {
    if((self = [super init])) {
        _places = [[NSMutableArray alloc] init];
        _boundingCoordinates = [boundingCoordinates retain];
        _coordinate = CLLocationCoordinate2DMake(0, 0);
    }
    
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if((self = [super init])) {
        _boundingCoordinates = nil;
        _coordinate = coordinate;        
        _places = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_places);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (TTURLRequestCachePolicy)cachePolicy {
    //DEK
    return _boundingCoordinates ? TTURLRequestCachePolicyNone : [super cachePolicy];
}

- (NSDictionary *)parameters {
    if(_boundingCoordinates)
        return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithDouble:_boundingCoordinates.northEastCoordinate.latitude], @"ne_lat",
                [NSNumber numberWithDouble:_boundingCoordinates.northEastCoordinate.longitude], @"ne_lng",
                [NSNumber numberWithDouble:_boundingCoordinates.southWestCoordinate.latitude], @"sw_lat",
                [NSNumber numberWithDouble:_boundingCoordinates.southWestCoordinate.longitude], @"sw_lng",
                nil];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:_coordinate.latitude], @"lat",
            [NSNumber numberWithDouble:_coordinate.longitude], @"lng",
            nil];
}

- (NSString *)relativeUrl {
	return @"/places/nearby";
}

- (void)processResponse:(NSDictionary *)json {	
    [_places removeAllObjects];
    
    for (NSDictionary *placeJson in [json objectForKey:@"places"]){
        NSLog(@"placeJson: %@", [placeJson class]);
        [_places addObject:[Place placeFromJson:placeJson]];
    }
}

#pragma mark -
#pragma mark ListableModel

- (NSArray *)items {
    return _places;
}

@end