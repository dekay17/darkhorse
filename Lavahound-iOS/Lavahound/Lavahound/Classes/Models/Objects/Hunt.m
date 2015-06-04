//
//  Hunt.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Hunt.h"
#import "Three20/Three20+Additions.h"
#import "NSString+Lavahound.h"

@implementation Hunt

@synthesize huntId = _huntId, name = _name, imageUrl = _imageUrl, proximityDescription = _proximityDescription,
foundCount = _foundCount, totalCount = _totalCount;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _huntId = nil;
        _name = nil;
        _imageUrl = nil;
        _proximityDescription = nil;
        _foundCount = nil;
        _totalCount = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_huntId);
    TT_RELEASE_SAFELY(_name);
    TT_RELEASE_SAFELY(_imageUrl);
    TT_RELEASE_SAFELY(_proximityDescription);
    TT_RELEASE_SAFELY(_foundCount);    
    TT_RELEASE_SAFELY(_totalCount);        
    [super dealloc];
}

#pragma mark -
#pragma mark Hunt

+ (Hunt *)huntFromJson:(NSDictionary *)huntJson {
    Hunt *hunt = [[[Hunt alloc] init] autorelease];
    hunt.huntId = [huntJson objectForKey:@"hunt_id"];    
    hunt.name = [huntJson objectForKey:@"name"];    
    hunt.imageUrl = [huntJson objectForKey:@"image_url"];    
    hunt.latitude = [huntJson objectForKey:@"latitude"];    
    hunt.longitude = [huntJson objectForKey:@"longitude"];    
    hunt.proximityDescription = [huntJson objectForKey:@"proximity_description"];
    hunt.foundCount = [huntJson objectForKey:@"found_count"];
    hunt.totalCount = [huntJson objectForKey:@"total_count"];    
    
    return hunt;
}

- (NSString *)urlEncodedName {
    return [_name urlEncode];
}

@end