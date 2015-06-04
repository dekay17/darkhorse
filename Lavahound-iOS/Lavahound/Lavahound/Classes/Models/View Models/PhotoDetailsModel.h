//
//  PhotoDetailsModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "Photo.h"

@interface PhotoDetailsModel : LavahoundModel {
    Photo *_photo;
    NSNumber *_photoId;
}

- (id)initWithPhotoId:(NSNumber *)photoId;

@property(nonatomic, readonly) Photo *photo;

@end