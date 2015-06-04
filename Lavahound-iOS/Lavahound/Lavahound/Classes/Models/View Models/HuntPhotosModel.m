//
//  HuntPhotosModel.m
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntPhotosModel.h"
#import "Photo.h"

static CGFloat const MaximumZoomLevel = 22;
static CGFloat const MinimumZoomLevel = 1;
static CGFloat const DefaultZoomLevel = 14;

@implementation HuntPhotosModel

@synthesize centerCoordinate = _centerCoordinate;

#pragma mark -
#pragma mark NSObject

- (id)initWithHuntId:(NSNumber *)huntId {
    return [self initWithCoordinate:CLLocationCoordinate2DMake(INT_MAX, INT_MAX) huntId:huntId];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate huntId:(NSNumber *)huntId {
    if((self = [super init])) {
        _zoomLevel = 0;
        _huntId = [huntId retain];
        _coordinate = coordinate;
        _centerCoordinate = CLLocationCoordinate2DMake(INT_MAX, INT_MAX);        
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_huntId);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (NSDictionary *)parameters {
    if(!CLLocationCoordinate2DIsValid(_coordinate))
        return [super parameters];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:_coordinate.latitude], @"lat",
            [NSNumber numberWithDouble:_coordinate.longitude], @"lng",
            nil];
}

- (NSString *)relativeUrl {
	return [NSString stringWithFormat:@"/hunts/%@/photos", _huntId];
}

- (void)processResponse:(NSDictionary *)json {	
    [_photos removeAllObjects];
    
    for (NSDictionary *photoJson in [json objectForKey:@"photos"])
        [_photos addObject:[Photo photoFromJson:photoJson]];
    
    _centerCoordinate = CLLocationCoordinate2DMake([[json objectForKey:@"latitude"] doubleValue], [[json objectForKey:@"longitude"] doubleValue]);  
    _zoomLevel = [[json objectForKey:@"zoom_level"] intValue];
}

- (NSInteger)zoomLevel {
    return _zoomLevel < MinimumZoomLevel || _zoomLevel > MaximumZoomLevel ? DefaultZoomLevel : _zoomLevel;        
}

@end