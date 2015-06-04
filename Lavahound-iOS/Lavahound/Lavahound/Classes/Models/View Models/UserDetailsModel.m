//
//  UserDetailsModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UserDetailsModel.h"

@implementation UserDetailsModel

@synthesize user = _user;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _user = nil;
        _userId = nil;
    }
    
    return self;
}

- (id)initWithUserId:(NSNumber *)userId {
    if((self = [super init])) {
        _user = nil;
        _userId = [userId retain];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_userId);
    TT_RELEASE_SAFELY(_user);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (NSDictionary *)parameters {
    return _userId
        ? [NSDictionary dictionaryWithObject:_userId forKey:@"user_id"]
        : [NSDictionary dictionary];
}

- (NSString *)relativeUrl {
    return @"/users/show";
}

- (void)processResponse:(NSDictionary *)json {
    TT_RELEASE_SAFELY(_user);
    _user = [[User userFromJson:json] retain];
}

@end