//
//  LavahoundChangePasswordApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundChangePasswordApiDelegate;

@interface LavahoundChangePasswordApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundChangePasswordApiDelegate> _delegate;
}

- (void)changePassword:(NSString *)password confirmPassword:(NSString *)confirmPassword oldPassword:(NSString *)oldPassword;

@property(nonatomic, assign) id<LavahoundChangePasswordApiDelegate> delegate;

@end


@protocol LavahoundChangePasswordApiDelegate<NSObject>

- (void)lavahoundChangePasswordApiDidChangePassword:(LavahoundChangePasswordApi *)lavahoundChangePasswordApi;

@end