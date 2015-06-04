//
//  LavahoundSignUpApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundSignUpApi.h"
#import "LocalStorage.h"

@implementation LavahoundSignUpApi

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
    [LocalStorage sharedInstance].apiToken = [json objectForKey:@"api_token"];   
    [LocalStorage sharedInstance].totalPoints = [json objectForKey:@"total_points"];          
    [_delegate lavahoundSignUpApiDidSignUp:self];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Signing up, please wait...";
}

#pragma mark -
#pragma mark LavahoundSignUpApi

- (void)signUpWithDisplayName:(NSString *)displayName emailAddress:(NSString *)emailAddress password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm {
    if(!emailAddress)
        emailAddress = @"";
    if(!password)
        password = @"";
    if(!passwordConfirm)
        passwordConfirm = @"";
    if (!displayName)
        displayName = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                emailAddress, @"email_address",
                                password, @"password",
                                passwordConfirm, @"password_confirm",
                                displayName, @"display_name",
                                nil];
    
//    [_lavahoundApi performRequestWithRelativeUrl:@"/sign-up" httpMethod:@"POST" parameters:parameters];    
    [_lavahoundApi performRequestWithRelativeUrl:@"/sign-up" httpMethod:@"GET" parameters:parameters];
}

@end