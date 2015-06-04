//
//  LavahoundApi.h
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@protocol LavahoundApiDelegate;
@protocol LavahoundApiDataSource;

@interface LavahoundApi : NSObject<TTURLRequestDelegate> {
    BOOL _overlayEnabled;
    id<LavahoundApiDelegate> _delegate;
    id<LavahoundApiDataSource> _dataSource;    
}

- (id)initWithOverlayEnabled:(BOOL)overlayEnabled;

- (void)performRequestWithRelativeUrl:(NSString *)relativeUrl
                           httpMethod:(NSString *)httpMethod
                           parameters:(NSDictionary *)parameters;

@property(nonatomic, assign) id<LavahoundApiDelegate> delegate;
@property(nonatomic, assign) id<LavahoundApiDataSource> dataSource;

@end


@protocol LavahoundApiDataSource<NSObject>

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi;

@end


@protocol LavahoundApiDelegate<NSObject>

@optional
    
// Always called at the start of the request
- (void)lavahoundApiDidStartRequest:(LavahoundApi *)lavahoundApi;

// Always called at the end of the request regardless of status (error, cancel, success)
- (void)lavahoundApiDidFinishRequest:(LavahoundApi *)lavahoundApi;

// Called depending on request/response status
- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithJson:(NSDictionary *)json;
- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithError:(NSError *)error serverErrorMessage:(NSString *)serverErrorMessage;
- (void)lavahoundApiDidCancelRequest:(LavahoundApi *)lavahoundApi;

@end