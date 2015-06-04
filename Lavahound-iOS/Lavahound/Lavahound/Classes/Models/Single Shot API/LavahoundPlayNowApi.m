//
//  LavahoundPlayNowApi.m
//  Lavahound
//
//  Created by Mark Allen on 6/6/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundPlayNowApi.h"
#import "LocalStorage.h"

@implementation LavahoundPlayNowApi

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
    [_delegate lavahoundPlayNowApiDidSignIn:self];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Signing in, please wait...";
}

#pragma mark -
#pragma mark LavahoundPlayNowApi

- (void)playNow {   
    [_lavahoundApi performRequestWithRelativeUrl:@"/playnow"
                                      httpMethod:@"POST"
                                      parameters:[NSDictionary dictionary]];    
}

@end