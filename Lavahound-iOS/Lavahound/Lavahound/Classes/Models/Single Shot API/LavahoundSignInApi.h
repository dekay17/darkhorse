//
//  LavahoundSignInApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@protocol LavahoundSignInApiDelegate;

@interface LavahoundSignInApi : LavahoundApiObject<LavahoundApiDelegate> {
    id<LavahoundSignInApiDelegate> _delegate;
}

- (void)signInWithEmailAddress:(NSString *)emailAddress password:(NSString *)password;
- (void)signInWithFacebookOAuthToken:(NSString *)facebookOAuthToken;
- (void)signInWithTwitterOAuthToken:(NSString *)twitterOAuthToken;



@property(nonatomic, assign) id<LavahoundSignInApiDelegate> delegate;

@end


@protocol LavahoundSignInApiDelegate<NSObject>

- (void)lavahoundSignInApiDidSignIn:(LavahoundSignInApi *)lavahoundSignInApi;

@end