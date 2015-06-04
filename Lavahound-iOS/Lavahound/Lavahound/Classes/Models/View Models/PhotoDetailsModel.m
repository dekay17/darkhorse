//
//  PhotoDetailsModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoDetailsModel.h"
#import "LocalStorage.h"

@implementation PhotoDetailsModel

@synthesize photo = _photo;

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId {
    if((self = [super init])) {
        _photo = nil;
        _photoId = [photoId retain];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photoId);
    TT_RELEASE_SAFELY(_photo);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundModel

- (NSString *)relativeUrl {
	return[NSString stringWithFormat:@"/photos/show/%@", _photoId];
}

- (void)processResponse:(NSDictionary *)json {
    TT_RELEASE_SAFELY(_photo);
    _photo = [[Photo photoFromJson:json] retain];
}

@end