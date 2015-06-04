//
//  PhotosModel.m
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotosModel.h"

@implementation PhotosModel

@synthesize photos = _photos;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init]))
        _photos = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photos);
    [super dealloc];
}

#pragma mark -
#pragma mark ListableModel

- (NSArray *)items {
    return _photos;
}

@end