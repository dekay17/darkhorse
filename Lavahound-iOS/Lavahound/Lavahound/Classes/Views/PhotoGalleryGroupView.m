//
//  PhotoGalleryGroupView.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoGalleryGroupView.h"
#import "PhotoGalleryView.h"

@implementation PhotoGalleryGroupView

@synthesize photos = _photos;

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
        _photos = nil;        
        _photoGalleryViews = [[NSMutableArray alloc] init];         
    }
	
	return self;
}

- (void)dealloc {
	TT_RELEASE_SAFELY(_photos);	    
    TT_RELEASE_SAFELY(_photoGalleryViews);
	[super dealloc];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGFloat VerticalPadding = 3;    
    static CGFloat BetweenPhotoPadding = 5;    
    CGFloat currentLeft = 3;
    CGFloat photoViewHeight = self.height - 2 * VerticalPadding;

    for(PhotoGalleryView *photoGalleryView in _photoGalleryViews) {
        photoGalleryView.frame = CGRectMake(currentLeft, VerticalPadding, kPhotoGalleryViewStandardWidth, photoViewHeight);      
        currentLeft += BetweenPhotoPadding + photoGalleryView.width;
    }
}

#pragma mark -
#pragma mark PhotosView

- (void)setPhotos:(NSArray *)photos {
    if(photos == _photos)
        return;
    
    TT_RELEASE_SAFELY(_photos);
    _photos = [photos retain];
    
    for(PhotoGalleryView *photoGalleryView in _photoGalleryViews)
        [photoGalleryView removeFromSuperview];
    
    [_photoGalleryViews removeAllObjects];    
    
    for(Photo *photo in _photos) {
        PhotoGalleryView *photoGalleryView = [[[PhotoGalleryView alloc] initWithFrame:CGRectZero] autorelease];
        photoGalleryView.photo = photo;
        [_photoGalleryViews addObject:photoGalleryView];
        [self addSubview:photoGalleryView];
    }
    
    [self setNeedsLayout];
}

@end