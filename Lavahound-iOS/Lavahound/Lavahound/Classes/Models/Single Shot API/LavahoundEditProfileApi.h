//
//  LavahoundEditProfileApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundEditProfileApiDelegate;

@interface LavahoundEditProfileApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundEditProfileApiDelegate> _delegate;
}

- (void)updateDisplayName:(NSString *)displayName emailAddress:(NSString *)emailAddress;

@property(nonatomic, assign) id<LavahoundEditProfileApiDelegate> delegate;

@end


@protocol LavahoundEditProfileApiDelegate<NSObject>

- (void)lavahoundEditProfileApiDidUpdateProfile:(LavahoundEditProfileApi *)lavahoundEditProfileApi;

@end