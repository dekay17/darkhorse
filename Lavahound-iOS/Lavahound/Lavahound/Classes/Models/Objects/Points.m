//
//  Points.m
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Points.h"

@implementation Points

@synthesize total = _total, finder = _finder, hider = _hider, royalties = _royalties, rank = _rank,
    rankPercentile = _rankPercentile, rankDescription = _rankDescription;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _total = nil;
        _finder = nil;  
        _hider = nil;  
        _royalties = nil;  
        _rank = nil;  
        _rankPercentile = nil;
        _rankDescription = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_total);
    TT_RELEASE_SAFELY(_finder);
    TT_RELEASE_SAFELY(_hider);
    TT_RELEASE_SAFELY(_royalties);
    TT_RELEASE_SAFELY(_rank);    
    TT_RELEASE_SAFELY(_rankPercentile);    
    TT_RELEASE_SAFELY(_rankDescription);        
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Points(total=%@, finder=%@, hider=%@, royalites=%@, rank=%@)",
            _total, _finder, _hider, _royalties, _rank];
}

#pragma mark -
#pragma mark Points

+ (Points *)pointsFromJson:(NSDictionary *)pointsJson {
    Points *points = [[[Points alloc] init] autorelease];
    points.total = [pointsJson objectForKey:@"total"];
    points.finder = [pointsJson objectForKey:@"finder"];
    points.hider = [pointsJson objectForKey:@"hider"];
    points.royalties = [pointsJson objectForKey:@"royalties"];
    points.rank = [pointsJson objectForKey:@"rank"];    
    points.rankPercentile = [pointsJson objectForKey:@"rank_percentile"];
    points.rankDescription = [pointsJson objectForKey:@"rank_description"];
    
    return points;
}

@end