//
//  LavahoundFlagPhotoApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundFlagPhotoApi.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundFlagPhotoApi

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
    [_delegate lavahoundFlagPhotoApiDidFlagPhoto:self];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Flagging photo, please wait...";
}

#pragma mark -
#pragma mark LavahoundFlagPhotoApi

- (void)flagPhotoId:(NSNumber *)photoId reason:(NSString *)reason {    
    if(!reason)
        reason = @"";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [LocalStorage sharedInstance].apiToken, @"api_token",
                                photoId, @"photo_id",
                                reason, @"reason",
                                nil];    
    
    [_lavahoundApi performRequestWithRelativeUrl:[NSString stringWithFormat:@"/photos/flag/%@",photoId] httpMethod:@"GET" parameters:parameters];
}

@end
