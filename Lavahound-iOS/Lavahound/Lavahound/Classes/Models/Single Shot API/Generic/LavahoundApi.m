    //
//  LavahoundApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "JSON.h"
#import "LavahoundApi.h"
#import "Constants.h"
#import "NSDictionary+Lavahound.h"
#import "NSData+Lavahound.h"
#import "TTRequestLoader+Lavahound.h"
#import "ModalOverlay.h"

@implementation LavahoundApi

@synthesize delegate = _delegate, dataSource = _dataSource;

#pragma mark -
#pragma mark NSObject

- (id)initWithOverlayEnabled:(BOOL)overlayEnabled {
    if((self = [super init]))
        _overlayEnabled = overlayEnabled;
    
    return self;
}

- (void)dealloc {
    // TTDPRINT(@"Dealloced.");
    [super dealloc];
}

#pragma mark -
#pragma mark TTURLRequestDelegate

- (void)requestDidStartLoad:(TTURLRequest *)request {
    if(_overlayEnabled) {
        // TTDPRINT(@"HTTP request started, showing modal dialog...");
        
        NSString *message = @"Please wait...";
        
        if([_dataSource respondsToSelector:@selector(lavahoundApiMessageForLoading:)])
            message = [_dataSource lavahoundApiMessageForLoading:self];
        
        [[ModalOverlay sharedInstance] showWithMessage:message];
    } else {
        // TTDPRINT(@"HTTP request started...");
    }
    
    if([_delegate respondsToSelector:@selector(lavahoundApiDidStartRequest:)])    
        [_delegate lavahoundApiDidStartRequest:self];    
}

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    // TTDPRINT(@"HTTP response received.");    
    
    TTURLDataResponse *response = request.response;  
    NSString *jsonString = [[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding] autorelease]; 
    NSDictionary *json = [jsonString JSONValue];
    
    TTDPRINT(@"Response JSON in NSDictionary format is:\n%@", json);    

    if(_overlayEnabled)
        [[ModalOverlay sharedInstance] hide];
    
    if([_delegate respondsToSelector:@selector(lavahoundApi:didRespondWithJson:)])    
        [_delegate lavahoundApi:self didRespondWithJson:json];
    
    if([_delegate respondsToSelector:@selector(lavahoundApiDidFinishRequest:)])    
        [_delegate lavahoundApiDidFinishRequest:self];      
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    TTDPRINT(@"HTTP request for %@ failed, error description is '%@'.", request.urlPath, [error localizedDescription]);
    
    NSData *responseData = [[error userInfo] objectForKey:kLavahoundHttpErrorResponseDataKey];
    NSDictionary *json = nil;
    NSString *serverErrorMessage = nil;
    
    if(responseData) {
        NSString *jsonString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];           
        
        TTDPRINT(@"Error response body:\n%@", jsonString);
        
        json = [jsonString JSONValue];
        serverErrorMessage = [json objectForKey:@"error_message"];
    }
    
    if(_overlayEnabled)
        [[ModalOverlay sharedInstance] hide];    
    
    if([_delegate respondsToSelector:@selector(lavahoundApi:didRespondWithError:serverErrorMessage:)])
        [_delegate lavahoundApi:self didRespondWithError:error serverErrorMessage:serverErrorMessage];
    
    if([_delegate respondsToSelector:@selector(lavahoundApiDidFinishRequest:)])    
        [_delegate lavahoundApiDidFinishRequest:self];              
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    TTDPRINT(@"HTTP request for %@ was canceled", request.urlPath);
    
    if(_overlayEnabled)
        [[ModalOverlay sharedInstance] hide];
        
    if([_delegate respondsToSelector:@selector(lavahoundApiDidCancelRequest:)])
        [_delegate lavahoundApiDidCancelRequest:self];
    
    if([_delegate respondsToSelector:@selector(lavahoundApiDidFinishRequest:)])    
        [_delegate lavahoundApiDidFinishRequest:self];           
}

#pragma mark -
#pragma mark LavahoundApi

- (void)performRequestWithRelativeUrl:(NSString *)relativeUrl
                           httpMethod:(NSString *)httpMethod
                           parameters:(NSDictionary *)parameters {
    httpMethod = [[httpMethod stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    BOOL getRequest = [@"GET" isEqualToString:httpMethod];
    
    // Never cache if this is non-GET request, e.g. POST or PUT
    // TTURLRequestCachePolicy cachePolicy = getRequest ? [Constants sharedInstance].cachePolicy : TTURLRequestCachePolicyNoCache;
    TTURLRequestCachePolicy cachePolicy = TTURLRequestCachePolicyNone;
    // Always include the "scale" and "udid" parameters
    NSMutableDictionary *parametersWithAdditions = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parametersWithAdditions setObject:[Constants sharedInstance].versionNumber forKey:@"version_number"];        
    [parametersWithAdditions setObject:[[NSNumber numberWithFloat:[Constants sharedInstance].deviceScaleFactor] description] forKey:@"scale"];
//    [parametersWithAdditions setObject:[UIDevice currentDevice].uniqueIdentifier forKey:@"udid"];        
    
    NSString *absoluteUrl = [NSString stringWithFormat:@"%@%@%@",
                             [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix,
                             relativeUrl,
                             getRequest ? [parametersWithAdditions formatAsQueryString] : @""];

    TTDPRINT(@"Making HTTP %@ request to %@", httpMethod, absoluteUrl);
    
    if(!getRequest)
        TTDPRINT(@"POST parameters in NSDictionary format are:\n%@", parametersWithAdditions);
    
    TTURLRequest *request = [TTURLRequest requestWithURL:absoluteUrl delegate:self];
    request.httpMethod = httpMethod;
    request.cachePolicy = cachePolicy;
    request.response = [[[TTURLDataResponse alloc] init] autorelease];        
    
    // If this is a POST or PUT, add the parameters to the request body
    if(!getRequest){
//          request.contentType = @"application/json";
        request.contentType=@"application/x-www-form-urlencoded";
//          [request.parameters setObject:@"test" forKey:@"userid"];
        [request.parameters addEntriesFromDictionary:parametersWithAdditions];
    }
    [request send];
}

@end