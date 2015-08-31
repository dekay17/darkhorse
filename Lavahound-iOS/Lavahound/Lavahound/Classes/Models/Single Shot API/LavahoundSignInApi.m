//
//  LavahoundSignInApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundSignInApi.h"
#import "LocalStorage.h"

@implementation LavahoundSignInApi

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super initWithOverlayEnabled:YES]))
        _delegate = nil;
    
    return self;
}

#pragma mark -
#pragma mark LavahoundApiDelegate

- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithJson:(NSDictionary *)json {
    if([json objectForKey:@"api_token"] != nil){
        [LocalStorage sharedInstance].apiToken = [json objectForKey:@"api_token"];
        [LocalStorage sharedInstance].totalPoints = [json objectForKey:@"total_points"];
        [_delegate lavahoundSignInApiDidSignIn:self];
    }
}


#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Signing in, please wait...";
}

#pragma mark -
#pragma mark LavahoundSignInApi

- (void)signInWithEmailAddress:(NSString *)emailAddress password:(NSString *)password {
    if(!emailAddress)
        emailAddress = @"";
    if(!password)
        password = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                emailAddress, @"email_address",
                                password, @"password",                              
                                nil];
    
    [_lavahoundApi performRequestWithRelativeUrl:@"/sign-in" httpMethod:@"GET" parameters:parameters];
}

- (void)signInWithTwitterOAuthToken:(NSString *)twitterOAuthToken{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:twitterOAuthToken, @"authToken", @"dan",@"displayName", nil];
    [_lavahoundApi performRequestWithRelativeUrl:@"/twitter/sign-up" httpMethod:@"POST" parameters:parameters];
}


- (void)signInWithFacebookOAuthToken:(NSString *)facebookOAuthToken {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:facebookOAuthToken, @"facebook_oauth_token", nil];    
    [_lavahoundApi performRequestWithRelativeUrl:@"/sign-in" httpMethod:@"POST" parameters:parameters];   
}

@end