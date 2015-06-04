//
//  TTRequestLoader+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TTRequestLoader+Lavahound.h"
#import "Three20Network/private/TTURLRequestQueueInternal.h"

NSString * const kLavahoundHttpErrorResponseDataKey = @"LavahoundHttpErrorResponseBodyKey";

@implementation TTRequestLoader(Lavahound)

// By default, Three20 only returns the response body for 200-status responses.
// We need to monkeypatch to support getting the response body for non-200-status responses.
// See http://forums.three20.info/discussion/101/network-support-for-http-status-code-422-and-others/p1

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TTNetworkRequestStopped();
    
    // TTDCONDITIONLOG(TTDFLAG_ETAGS, @"Response status code: %d", _response.statusCode);
    
    // We need to accept valid HTTP status codes, not only 200.
    if (_response.statusCode >= 200 && _response.statusCode < 300) {
        [_queue loader:self didLoadResponse:_response data:_responseData];
        
    } else if (_response.statusCode == 304) {
        [_queue loader:self didLoadUnmodifiedResponse:_response];
        
    } else {
        // TTDCONDITIONLOG(TTDFLAG_URLREQUEST, @"  FAILED LOADING (%d) %@",
        //                _response.statusCode, _urlPath);
        
        // MONKEYPATCH START
        NSDictionary *userInfo =[NSDictionary dictionaryWithObjectsAndKeys:_responseData, kLavahoundHttpErrorResponseDataKey, nil];        
        // MONKEYPATCH END
        
        NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:_response.statusCode
                          // MONKEYPATCH START
                                         // userInfo:nil];
                                         userInfo:userInfo];
                          // MONKEYPATCH END                          
        
                          
        [_queue loader:self didFailLoadWithError:error];
    }
    
    TT_RELEASE_SAFELY(_responseData);
    TT_RELEASE_SAFELY(_connection);
}

@end