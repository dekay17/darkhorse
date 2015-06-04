//
//  LavahoundChangePasswordApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundChangePasswordApi.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundChangePasswordApi

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
    [_delegate lavahoundChangePasswordApiDidChangePassword:self];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Updating your password, please wait...";
}

#pragma mark -
#pragma mark LavahoundChangePasswordApi

- (void)changePassword:(NSString *)password confirmPassword:(NSString *)confirmPassword oldPassword:(NSString *)oldPassword {
    if(!password)
        password = @"";
    if(!confirmPassword)
        confirmPassword = @"";
    if(!oldPassword)
        oldPassword = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [LocalStorage sharedInstance].apiToken, @"api_token",
                                password, @"password",
                                confirmPassword, @"confirm_password",
                                oldPassword, @"old_password",
                                nil];    
    
    [_lavahoundApi performRequestWithRelativeUrl:@"/users/update_password" httpMethod:@"POST" parameters:parameters];        
}

@end