//
//  LavahoundMarkPhotoFoundApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundMarkPhotoFoundApiDelegate;

@interface LavahoundMarkPhotoFoundApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundMarkPhotoFoundApiDelegate> _delegate;
}

- (void)markFoundWithPhotoId:(NSNumber *)photoId;

@property(nonatomic, assign) id<LavahoundMarkPhotoFoundApiDelegate> delegate;

@end


@protocol LavahoundMarkPhotoFoundApiDelegate<NSObject>

- (void)lavahoundMarkPhotoFoundApi:(LavahoundMarkPhotoFoundApi *)lavahoundMarkPhotoFoundApi didMarkFoundWithMessage:(NSString *)message points:(NSNumber *)points;

@end