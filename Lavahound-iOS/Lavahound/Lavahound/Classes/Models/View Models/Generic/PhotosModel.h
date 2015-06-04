//
//  PhotosModel.h
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"

@interface PhotosModel : LavahoundModel<ListableModel> {
    NSMutableArray *_photos;
}

@property(nonatomic, readonly) NSArray *photos;

@end