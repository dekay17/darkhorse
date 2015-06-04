//
//  PhotoMapAnnotationView.m
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoMapAnnotationView.h"
#import "Three20UI/UINSObjectAdditions.h"

@implementation PhotoMapAnnotationView

@synthesize imageUrl = _imageUrl;

#pragma mark -
#pragma mark NSObject

- (id)init {
    // Force the frame to be the size of the image    
	if((self = [super initWithFrame:CGRectMake(0, 0, 32, 32)])) {
        _imageUrl = nil;                        
		_imageView = [[LoadingAwareImageView alloc] initWithFrame:self.bounds contentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
	
	return self;
}

- (void)dealloc { 
    TT_RELEASE_SAFELY(_imageView);
	TT_RELEASE_SAFELY(_imageUrl);	
	[super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@)", [self class], _imageUrl];
}

#pragma mark -
#pragma mark PhotoMapAnnotationView

- (void)setImageUrl:(NSString *)imageUrl {
    _imageView.imageUrl = imageUrl;
    // [self setNeedsLayout];
}

@end