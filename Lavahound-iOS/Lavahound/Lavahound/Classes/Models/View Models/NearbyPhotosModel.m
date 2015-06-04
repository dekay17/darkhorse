//
//  NearbyPhotosModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyPhotosModel.h"
#import "Photo.h"

@implementation NearbyPhotosModel

#pragma mark -
#pragma mark NSObject

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if((self = [super init]))
        _coordinate = coordinate;        
    
    return self;
}

#pragma mark -
#pragma mark LavahoundModel

- (TTURLRequestCachePolicy)cachePolicy {
    // DEK
//    return TTURLRequestCachePolicyNoCache;
        return TTURLRequestCachePolicyNone;
}

- (NSDictionary *)parameters {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:_coordinate.latitude], @"lat",
            [NSNumber numberWithDouble:_coordinate.longitude], @"lng",
            nil];
}

- (NSString *)relativeUrl {
	return @"/photos/nearby";
}

- (void)processResponse:(NSDictionary *)json {	
    [_photos removeAllObjects];
    
    for (NSDictionary *photoJson in [json objectForKey:@"photos"])
        [_photos addObject:[Photo photoFromJson:photoJson]];
}

@end