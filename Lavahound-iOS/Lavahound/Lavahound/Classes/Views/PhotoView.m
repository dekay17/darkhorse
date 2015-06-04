//
//  PhotoView.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

@synthesize photo = _photo;

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame]))
        _photo = nil;
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_photo);	
	[super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@)", [self class], [_photo description]];
}

#pragma mark -
#pragma mark PhotoView

- (void)setPhoto:(Photo *)photo {
    if(photo == _photo)
        return;
    
    TT_RELEASE_SAFELY(_photo);
    _photo = [photo retain];
    
    [self didSetPhoto:photo];    
    [self setNeedsLayout];
}

- (void)didSetPhoto:(Photo *)photo {
    // Subclasses should override
}

@end