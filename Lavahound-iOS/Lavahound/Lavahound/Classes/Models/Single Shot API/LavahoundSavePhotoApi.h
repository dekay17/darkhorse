//
//  LavahoundSavePhotoApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LavahoundApiObject.h"

@protocol LavahoundSavePhotoApiDelegate;

@interface LavahoundSavePhotoApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundSavePhotoApiDelegate> _delegate;
}

- (void)savePhoto:(NSData *)photo
       coordinate:(CLLocationCoordinate2D)coordinate
originalCoordinate:(CLLocationCoordinate2D)originalCoordinate
 originalAccuracy:(CLLocationAccuracy)originalAccuracy;

@property(nonatomic, assign) id<LavahoundSavePhotoApiDelegate> delegate;

@end


@protocol LavahoundSavePhotoApiDelegate<NSObject>

- (void)lavahoundSavePhotoApi:(LavahoundSavePhotoApi *)lavahoundSavePhotoApi didSavePhotoId:(NSNumber *)photoId;

@end