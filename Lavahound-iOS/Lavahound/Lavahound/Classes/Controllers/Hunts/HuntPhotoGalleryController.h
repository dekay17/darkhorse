//
//  HuntPhotoGalleryController.h
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TableViewController.h"

@interface HuntPhotoGalleryController : TableViewController {
    NSNumber *_huntId;
}

- (id)initWithHuntId:(NSNumber *)huntId;

@end