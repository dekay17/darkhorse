//
//  LavahoundForgotPasswordApi.m
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundForgotPasswordApi.h"

@implementation LavahoundForgotPasswordApi

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
    [_delegate lavahoundForgotPasswordApiDidResetPassword:self];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Resetting your password, please wait...";
}

#pragma mark -
#pragma mark LavahoundForgotPasswordApi

- (void)resetPasswordForEmailAddress:(NSString *)emailAddress {   
    if(!emailAddress)
        emailAddress = @"";
    
    [_lavahoundApi performRequestWithRelativeUrl:@"/users/reset" httpMethod:@"POST" parameters:[NSDictionary dictionaryWithObject:emailAddress forKey:@"email_address"]];        
}

@end