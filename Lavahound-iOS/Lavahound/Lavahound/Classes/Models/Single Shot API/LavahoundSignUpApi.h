//
//  LavahoundSignUpApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundSignUpApiDelegate;

@interface LavahoundSignUpApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundSignUpApiDelegate> _delegate;
}

- (void)signUpWithDisplayName:(NSString *)displayName emailAddress:(NSString *)emailAddress password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm;

@property(nonatomic, assign) id<LavahoundSignUpApiDelegate> delegate;

@end


@protocol LavahoundSignUpApiDelegate<NSObject>

- (void)lavahoundSignUpApiDidSignUp:(LavahoundSignUpApi *)lavahoundSignInApi;

@end