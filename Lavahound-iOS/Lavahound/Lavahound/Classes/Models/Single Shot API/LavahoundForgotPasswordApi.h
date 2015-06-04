//
//  LavahoundForgotPasswordApi.h
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundForgotPasswordApiDelegate;

@interface LavahoundForgotPasswordApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundForgotPasswordApiDelegate> _delegate;
}

- (void)resetPasswordForEmailAddress:(NSString *)emailAddress;

@property(nonatomic, assign) id<LavahoundForgotPasswordApiDelegate> delegate;

@end


@protocol LavahoundForgotPasswordApiDelegate<NSObject>

- (void)lavahoundForgotPasswordApiDidResetPassword:(LavahoundForgotPasswordApi *)lavahoundForgotPasswordApi;

@end