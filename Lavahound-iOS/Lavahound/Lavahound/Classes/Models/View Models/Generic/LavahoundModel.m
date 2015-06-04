//
//  LavahoundModel.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "JSON.h"
#import "TTRequestLoader+Lavahound.h"
#import "NSDictionary+Lavahound.h"
#import "LavahoundModel.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundModel

#pragma mark -
#pragma mark TTModel

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (self.isLoading)
        return;
    
    // Always include "scale", "udid", and "api_token" parameters
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [parameters setObject:[LocalStorage sharedInstance].apiToken forKey:@"api_token"];
    [parameters setObject:[NSNumber numberWithFloat:[Constants sharedInstance].deviceScaleFactor] forKey:@"scale"];    
//    [parameters setObject:[UIDevice currentDevice].uniqueIdentifier forKey:@"udid"];    
    [parameters setObject:[Constants sharedInstance].versionNumber forKey:@"version_number"];
    
    NSString *absoluteUrl = [NSString stringWithFormat:@"%@%@%@", [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix, self.relativeUrl, [parameters formatAsQueryString]];
    
    //TTDPRINT(@"Requesting %@", absoluteUrl);
    NSLog(@"%@", absoluteUrl);
    
    TTURLRequest *request = [TTURLRequest requestWithURL:absoluteUrl delegate:self];
    request.cachePolicy = TTURLRequestCachePolicyNone;
//    request.cachePolicy = cachePolicy | self.cachePolicy;
//    request.cacheExpirationAge = [Constants sharedInstance].cacheExpirationAge;
    
    TTURLDataResponse *response = [[TTURLDataResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    //TTDPRINT(@"Received response for %@", request.urlPath);  
    
    TTURLDataResponse *response = request.response;  
    NSString *jsonString = [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]; 
    NSDictionary *json = [jsonString JSONValue];
    
	// Let subclasses do their own thing
	[self processResponse:json];
	
    [super requestDidFinishLoad:request];
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    TTDPRINT(@"HTTP request for %@ failed, error description is '%@'.", request.urlPath, [error localizedDescription]);
    
    NSData *responseData = [[error userInfo] objectForKey:kLavahoundHttpErrorResponseDataKey];
    // NSDictionary *json = nil;
    
    if(responseData) {
        NSString *jsonString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];        
        TTDPRINT(@"Error response body:\n%@", jsonString);
        // json = [jsonString JSONValue];       
    }
    
    [super request:request didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    TTDPRINT(@"Request for %@ canceled.", request.urlPath);
    [super requestDidCancelLoad:request];
}

#pragma mark -
#pragma mark LavahoundModel

- (TTURLRequestCachePolicy)cachePolicy {
    return [Constants sharedInstance].cachePolicy;
}

- (NSDictionary *)parameters {
    return [NSDictionary dictionary];
}

- (NSString *)relativeUrl {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)processResponse:(NSDictionary *)json {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end