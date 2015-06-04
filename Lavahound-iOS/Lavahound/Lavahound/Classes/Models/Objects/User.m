//
//  User.m
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId, emailAddress = _emailAddress, displayName = _displayName, imageUrl = _imageUrl,
    photosHidden = _photosHidden, timesFound = _timesFound, rank = _rank;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _userId = nil;
        _emailAddress = nil;
        _displayName = nil;
        _imageUrl = nil;
        _photosHidden = nil;
        _timesFound = nil;
        _rank = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_userId);
    TT_RELEASE_SAFELY(_emailAddress);
    TT_RELEASE_SAFELY(_displayName);
    TT_RELEASE_SAFELY(_imageUrl);
    TT_RELEASE_SAFELY(_photosHidden);
    TT_RELEASE_SAFELY(_timesFound);
    TT_RELEASE_SAFELY(_rank);    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"User(ID %@, Display Name %@)", _userId, _displayName];
}

#pragma mark -
#pragma mark User

+ (User *)userFromJson:(NSDictionary *)userJson {
    User *user = [[[User alloc] init] autorelease];
    user.userId = [userJson objectForKey:@"user_id"];
    user.emailAddress = [userJson objectForKey:@"email_address"];
    user.displayName = [userJson objectForKey:@"display_name"];
    user.imageUrl = [userJson objectForKey:@"image_url"];    
    user.photosHidden = [userJson objectForKey:@"photos_hidden"];
    user.timesFound = [userJson objectForKey:@"times_found"];
    user.rank = [userJson objectForKey:@"rank"];
    
    return user;
}

@end