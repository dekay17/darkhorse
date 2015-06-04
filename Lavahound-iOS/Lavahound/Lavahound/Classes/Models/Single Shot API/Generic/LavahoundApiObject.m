//
//  LavahoundApiObject.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundApiObject.h"

@implementation LavahoundApiObject

#pragma mark -
#pragma mark NSObject

- (id)initWithOverlayEnabled:(BOOL)overlayEnabled {
    if((self = [super init])) {
        _lavahoundApi = [[LavahoundApi alloc] initWithOverlayEnabled:overlayEnabled];
        _lavahoundApi.delegate = self;
        _lavahoundApi.dataSource = self;
    }
        
    return self;
}

- (void)dealloc {
    // TTDPRINT(@"Dealloced.");
    _lavahoundApi.dataSource = nil;
    _lavahoundApi.delegate = nil;
    TT_RELEASE_SAFELY(_lavahoundApi);
    [super dealloc];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return nil;
}

#pragma mark -
#pragma mark LavahoundApiDelegate

// Make sure we hang on to a reference to ourselves for the duration of the request.
// This way client code can create autoreleased instances and not have to worry about unexpected deallocation
- (void)lavahoundApiDidStartRequest:(LavahoundApi *)lavahoundApi {
    [self retain];
}

// Clean up the self-retain we did above
- (void)lavahoundApiDidFinishRequest:(LavahoundApi *)lavahoundApi {
    [self autorelease];    
}

// Subclasses should implement these as necessary

- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithJson:(NSDictionary *)json {}

- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithError:(NSError *)error serverErrorMessage:(NSString *)serverErrorMessage {
    if(serverErrorMessage)
        TTAlert(serverErrorMessage);
    else
        TTAlert([NSString stringWithFormat:@"Unable to complete this operation.\nReason: %@", [error localizedDescription]]);
}

- (void)lavahoundApiDidCancelRequest:(LavahoundApi *)lavahoundApi {}

@end