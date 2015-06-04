//
//  PhotoMapAnnotationView.h
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "SelectableView.h"
#import "LoadingAwareImageView.h"
#import "Photo.h"

extern const CGFloat kPhotoGalleryViewStandardWidth;

@interface PhotoMapAnnotationView : SelectableView {
    LoadingAwareImageView *_imageView;    
    NSString *_imageUrl;
}

@property(nonatomic, retain) NSString *imageUrl;

@end