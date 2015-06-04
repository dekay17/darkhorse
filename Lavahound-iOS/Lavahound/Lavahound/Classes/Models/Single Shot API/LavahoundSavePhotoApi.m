//
//  LavahoundSavePhotoApi.m
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundSavePhotoApi.h"
#import "LocalStorage.h"
#import "Constants.h"

@implementation LavahoundSavePhotoApi

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
    NSNumber *photoId = [json objectForKey:@"photo_id"];
    [LocalStorage sharedInstance].totalPoints = [json objectForKey:@"total_points"];                  
    [_delegate lavahoundSavePhotoApi:self didSavePhotoId:photoId];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLavahoundApiDataChangedNotification object:self];        
}

- (void)lavahoundApi:(LavahoundApi *)lavahoundApi didRespondWithError:(NSError *)error json:(NSDictionary *)json {
    TTAlert(@"Sorry, an error occurred and we were unable to save your photo. Please try again in a minute!");
}

#pragma mark -
#pragma mark LavahoundApiDataSource

- (NSString *)lavahoundApiMessageForLoading:(LavahoundApi *)lavahoundApi {
    return @"Uploading your photo, please wait...";
}

#pragma mark -
#pragma mark LavahoundMarkPhotoFoundApi

- (void)savePhoto:(NSData *)photo
       coordinate:(CLLocationCoordinate2D)coordinate
originalCoordinate:(CLLocationCoordinate2D)originalCoordinate
 originalAccuracy:(CLLocationAccuracy)originalAccuracy {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [LocalStorage sharedInstance].apiToken, @"api_token",
                                photo, @"photo[image]",
                                [NSString stringWithFormat:@"%f", coordinate.latitude], @"lat",
                                [NSString stringWithFormat:@"%f", coordinate.longitude], @"lng",
                                [NSString stringWithFormat:@"%f", originalCoordinate.latitude], @"orig_lat",
                                [NSString stringWithFormat:@"%f", originalCoordinate.longitude], @"orig_lng",
                                [NSString stringWithFormat:@"%f", originalAccuracy], @"accuracy",
                                nil];
    [_lavahoundApi performRequestWithRelativeUrl:@"/photos/create" httpMethod:@"POST" parameters:parameters];        
}

@end