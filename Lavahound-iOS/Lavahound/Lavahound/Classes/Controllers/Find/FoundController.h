//
//  FoundController.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface FoundController : TTViewController {
    NSNumber *_photoId;
    NSString *_message;
    NSString *_points;
}

- (id)initWithPhotoId:(NSNumber *)photoId message:(NSString *)message points:(NSString *)points;

@end