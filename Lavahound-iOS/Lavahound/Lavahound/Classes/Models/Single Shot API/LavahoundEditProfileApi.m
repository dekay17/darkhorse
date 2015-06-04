//
//  LavahoundEditProfileApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundEditProfileApi.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundEditProfileApi

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
    [_delegate lavahoundEditProfileApiDidUpdateProfile:self];    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLavahoundApiDataChangedNotification object:self];        
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Updating your profile, please wait...";
}

#pragma mark -
#pragma mark LavahoundEditProfileApi

- (void)updateDisplayName:(NSString *)displayName emailAddress:(NSString *)emailAddress {
    if(!emailAddress)
        emailAddress = @"";
    if(!displayName)
        displayName = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [LocalStorage sharedInstance].apiToken, @"api_token",
                                emailAddress, @"email_address",
                                displayName, @"display_name",
                                nil];    
    
    [_lavahoundApi performRequestWithRelativeUrl:@"/users/update" httpMethod:@"POST" parameters:parameters];        
}

@end