//
//  FlagController.h
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundFlagPhotoApi.h"

@interface FlagController : TTViewController<UITextViewDelegate, LavahoundFlagPhotoApiDelegate> {
    UITextView *_reasonTextView;
    NSNumber *_photoId;
}

- (id)initWithPhotoId:(NSNumber *)photoId;

@end