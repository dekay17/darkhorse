//
//  PhotoGalleryGroupView.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "Photo.h"

@interface PhotoGalleryGroupView : UIView {
    NSArray *_photos;
    NSMutableArray *_photoGalleryViews;    
}

@property(nonatomic, retain) NSArray *photos;

@end