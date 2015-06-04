//
//  Place.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Place.h"
#import "Three20/Three20+Additions.h"
#import "NSString+Lavahound.h"

@implementation Place

@synthesize placeId = _placeId, name = _name, description = _description, imageUrl = _imageUrl,
    proximityDescription = _proximityDescription, huntCount = _huntCount;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _placeId = nil;
        _name = nil;
        _description = nil;
        _imageUrl = nil;
        _proximityDescription = nil;
        _huntCount = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_placeId);
    TT_RELEASE_SAFELY(_name);
    TT_RELEASE_SAFELY(_description);
    TT_RELEASE_SAFELY(_imageUrl);
    TT_RELEASE_SAFELY(_proximityDescription);
    TT_RELEASE_SAFELY(_huntCount);    
    [super dealloc];
}

#pragma mark -
#pragma mark Place

+ (Place *)placeFromJson:(NSDictionary *)placeJson {
    Place *place = [[[Place alloc] init] autorelease];    
    place.name = [placeJson objectForKey:@"name"];
    place.placeId = [placeJson objectForKey:@"place_id"];
    place.description = [placeJson objectForKey:@"description"];        
    place.imageUrl = [placeJson objectForKey:@"image_url"];    
    place.latitude = [placeJson objectForKey:@"latitude"];    
    place.longitude = [placeJson objectForKey:@"longitude"];    
    place.proximityDescription = [placeJson objectForKey:@"proximity_description"];
    place.huntCount = [placeJson objectForKey:@"hunt_count"];
     
    return place;
}

@end