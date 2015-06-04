//
//  HuntsModel.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntsModel.h"
#import "Hunt.h"

@implementation HuntsModel

@synthesize place = _place, hunts = _hunts;

#pragma mark -
#pragma mark NSObject

- (id)initWithPlaceId:(NSNumber *)placeId {
    if((self = [super init])) {
        _place = nil;
        _hunts = [[NSMutableArray alloc] init];
        _placeId = [placeId retain];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_placeId);
    TT_RELEASE_SAFELY(_place);
    TT_RELEASE_SAFELY(_hunts);    
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (NSDictionary *)parameters {
    return [NSDictionary dictionaryWithObject:_placeId forKey:@"place_id"];
}

- (NSString *)relativeUrl {
	return @"/hunts";
}

- (void)processResponse:(NSDictionary *)json {	
    TT_RELEASE_SAFELY(_place);
    [_hunts removeAllObjects];
    
    NSDictionary *placeJson = [json objectForKey:@"place"];
    _place = [[Place placeFromJson:placeJson] retain];    
    
    for (NSDictionary *huntJson in [json objectForKey:@"hunts"])
        [_hunts addObject:[Hunt huntFromJson:huntJson]];
}

@end