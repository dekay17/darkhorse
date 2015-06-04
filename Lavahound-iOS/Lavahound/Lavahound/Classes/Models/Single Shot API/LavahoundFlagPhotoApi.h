//
//  LavahoundFlagPhotoApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundFlagPhotoApiDelegate;

@interface LavahoundFlagPhotoApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundFlagPhotoApiDelegate> _delegate;
}

- (void)flagPhotoId:(NSNumber *)photoId reason:(NSString *)reason;

@property(nonatomic, assign) id<LavahoundFlagPhotoApiDelegate> delegate;

@end


@protocol LavahoundFlagPhotoApiDelegate<NSObject>

- (void)lavahoundFlagPhotoApiDidFlagPhoto:(LavahoundFlagPhotoApi *)lavahoundFlagPhotoApi;

@end