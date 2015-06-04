//
//  Photo.m
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "NSString+Lavahound.h"
#import "Photo.h"

@implementation Photo

@synthesize photoId = _photoId, accountId = _accountId, title = _title, description = _description,
    imageUrl = _imageUrl, proximityDescription = _proximityDescription,proximityColor = _proximityColor, submittedBy = _submittedBy,
    submittedByImageUrl = _submittedByImageUrl, submittedOn = _submittedOn, points = _points,
    timesFound = _timesFound, shotInformation = _shotInformation, found = _found, owner = _owner;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _photoId = nil;
        _accountId = nil;
        _points = nil;
        _timesFound = nil;
        _title = nil;
        _description = nil;
        _imageUrl = nil;
        _proximityDescription = nil;
        _proximityColor = nil;
        _submittedBy = nil;
        _submittedByImageUrl = nil;
        _submittedOn = nil;
        _shotInformation = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photoId);
    TT_RELEASE_SAFELY(_accountId);
    TT_RELEASE_SAFELY(_points);
    TT_RELEASE_SAFELY(_timesFound);    
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_description);
    TT_RELEASE_SAFELY(_imageUrl);
    TT_RELEASE_SAFELY(_proximityDescription);
    TT_RELEASE_SAFELY(_proximityColor);
    TT_RELEASE_SAFELY(_submittedBy);
    TT_RELEASE_SAFELY(_submittedByImageUrl);
    TT_RELEASE_SAFELY(_submittedOn);
    TT_RELEASE_SAFELY(_shotInformation);    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Photo(ID %@)", _photoId];
}

#pragma mark -
#pragma mark Photo

+ (Photo *)photoFromJson:(NSDictionary *)photoJson {
    Photo *photo = [[[Photo alloc] init] autorelease];
    photo.photoId = [photoJson objectForKey:@"photo_id"];
    photo.accountId = [photoJson objectForKey:@"account_id"];  
    photo.points = [photoJson objectForKey:@"points"];  
    photo.timesFound = [photoJson objectForKey:@"times_found"];      
    photo.title = [photoJson objectForKey:@"title"];    
    photo.description = [photoJson objectForKey:@"description"];        
    photo.imageUrl = [photoJson objectForKey:@"image_url"];    
    photo.latitude = [photoJson objectForKey:@"latitude"];    
    photo.longitude = [photoJson objectForKey:@"longitude"];    
    photo.proximityDescription = [photoJson objectForKey:@"proximity_description"];
    photo.proximityColor = [photoJson objectForKey:@"proximity_color"];
    photo.submittedBy = [photoJson objectForKey:@"submitted_by"];
    photo.submittedByImageUrl = [photoJson objectForKey:@"submitted_by_image_url"];
    photo.submittedOn = [photoJson objectForKey:@"submitted_on"];
    photo.shotInformation = [[photoJson objectForKey:@"shot_information"] isKindOfClass:[NSString class]] ? [photoJson objectForKey:@"shot_information"] : nil;    
    photo.found = [[photoJson objectForKey:@"found"] boolValue];
    photo.owner = [[photoJson objectForKey:@"owner"] boolValue];    
    
    return photo;
}

@end