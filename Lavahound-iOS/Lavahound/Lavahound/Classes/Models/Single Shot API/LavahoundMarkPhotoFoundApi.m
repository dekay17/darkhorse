//
//  LavahoundMarkPhotoFoundApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundMarkPhotoFoundApi.h"
#import "LocationTracker.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundMarkPhotoFoundApi

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
    [LocalStorage sharedInstance].totalPoints = [json objectForKey:@"total_points"];          
    [_delegate lavahoundMarkPhotoFoundApi:self didMarkFoundWithMessage:[json objectForKey:@"message"] points:[json objectForKey:@"points"]];    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLavahoundApiDataChangedNotification object:self];
}

- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithError:(NSError *)error serverErrorMessage:(NSString *)serverErrorMessage {
    if([error code] == 400)
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://find-failed"] applyAnimated:YES]];
    else
        [super lavahoundApi:lavahoundApi didRespondWithError:error serverErrorMessage:serverErrorMessage];
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Seeing if you get credit for this find, please wait...";
}

#pragma mark -
#pragma mark LavahoundMarkPhotoFoundApi

- (void)markFoundWithPhotoId:(NSNumber *)photoId {    
    CLLocation *location = [LocationTracker sharedInstance].location;   

    if(!location) {
        TTAlert(@"Sorry, you must enable location services to mark a photo as found.");
        return;
    } 
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [LocalStorage sharedInstance].apiToken, @"api_token",
                                [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat",
                                [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lng",
                                [NSString stringWithFormat:@"%f", location.horizontalAccuracy], @"accuracy",
                                nil];
                            //    photoId, @"photo_id",

    [_lavahoundApi performRequestWithRelativeUrl:[NSString stringWithFormat:@"/photos/found/%@", photoId] httpMethod:@"GET" parameters:parameters];
  
//    [_lavahoundApi performRequestWithRelativeUrl:@"/photos/found" httpMethod:@"POST" parameters:parameters];
}

@end