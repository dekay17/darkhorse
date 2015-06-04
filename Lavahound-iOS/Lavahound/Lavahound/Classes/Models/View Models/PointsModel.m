//
//  PointsModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PointsModel.h"
#import "LocalStorage.h"

@implementation PointsModel

@synthesize points = _points;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init]))
        _points = nil;
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_points);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (NSString *)relativeUrl {
	return @"/users/points";
}

- (void)processResponse:(NSDictionary *)json {
    TT_RELEASE_SAFELY(_points);
    _points = [[Points pointsFromJson:[json objectForKey:@"points"]] retain];    
    [LocalStorage sharedInstance].totalPoints = [json objectForKey:@"total_points"];
}

@end