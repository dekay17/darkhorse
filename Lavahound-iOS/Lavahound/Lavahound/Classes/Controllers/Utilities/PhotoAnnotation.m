//
//  PhotoAnnotation.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoAnnotation.h"

@implementation PhotoAnnotation

@synthesize photo = _photo, title = _title, subtitle = _subtitle, coordinate = _coordinate;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _photo = nil;
        _title = nil;
        _subtitle = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photo);   
    TT_RELEASE_SAFELY(_title);   
    TT_RELEASE_SAFELY(_subtitle);       
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"PhotoAnnotation(%@)", [_photo description]];
}

#pragma mark -
#pragma mark PhotoAnnotation

- (void)setPhoto:(Photo *)photo {
    if(_photo == photo)
        return;
    
    TT_RELEASE_SAFELY(_photo);
    _photo = [photo retain];    
    _coordinate = photo.coordinate;
}

@end