//
//  Location.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Location.h"
#import "Photo.h"
#import "Three20/Three20+Additions.h"

@implementation Location

@synthesize imageUrl = _imageUrl, type = _type, locationId = _locationId, huntCount = _huntCount, placeName = _placeName;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _imageUrl = nil;
        _type = nil;
        _locationId = nil;
        _huntCount = nil;
        _placeName = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_imageUrl);
    TT_RELEASE_SAFELY(_type);    
    TT_RELEASE_SAFELY(_locationId);
    TT_RELEASE_SAFELY(_huntCount);
    TT_RELEASE_SAFELY(_placeName);    
    [super dealloc];
}

#pragma mark -
#pragma mark Location

+ (Location *)locationFromJson:(NSDictionary *)locationJson {
    Location *location = [[[Location alloc] init] autorelease];
    location.imageUrl = [locationJson objectForKey:@"image_url"];
    location.latitude = [locationJson objectForKey:@"latitude"];
    location.longitude = [locationJson objectForKey:@"longitude"];
    location.locationId = [locationJson objectForKey:@"id"];    
    location.type = [locationJson objectForKey:@"type"];
    location.huntCount = [locationJson objectForKey:@"hunt_count"];
    location.placeName = [locationJson objectForKey:@"place_name"];    
    
    return location;
}

- (LocationType)locationType {
    return [_type isEqualToString:@"place"] ? LocationTypePlace : LocationTypePhoto;
}

@end