//
//  PhotoGalleryView.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "SelectableView.h"
#import "LoadingAwareImageView.h"
#import "Photo.h"

extern const CGFloat kPhotoGalleryViewStandardWidth;

@interface PhotoGalleryView : SelectableView<SelectableViewDelegate> {
    UILabel *_proximityDescriptionLabel;
    LoadingAwareImageView *_imageView;    
    UIImageView *_foundImageView;
    Photo *_photo;
}

@property(nonatomic, retain) Photo *photo;

@end