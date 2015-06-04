//
//  PhotoSavedController.h
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"

@interface PhotoSavedController : ModelViewController {
    NSNumber *_photoId;
    UILabel *_pointsLabel;
}

- (id)initWithPhotoId:(NSNumber *)photoId;

@end