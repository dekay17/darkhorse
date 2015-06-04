//
//  LavahoundFacebook.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundFacebook.h"
#import "Constants.h"
#import "NSURL+Lavahound.h"
#import "NSMutableArray+Lavahound.h"
#import "LocalStorage.h"

static LavahoundFacebook *kSharedInstance = nil;

@implementation LavahoundFacebook

#pragma mark -
#pragma mark NSObject

- (id)init {
	if((self = [super init])) {
        _facebook = [[Facebook alloc] initWithAppId:[Constants sharedInstance].facebookAppId];    
        _facebook.accessToken = [LocalStorage sharedInstance].facebookOAuthToken;
        _facebook.expirationDate = [NSDate distantFuture];
        _delegates = [[NSMutableArray mutableArrayUsingWeakReferences] retain];        
	}
    
	return self;
}

// No dealloc since we're a singleton

#pragma mark -
#pragma mark FBDialogDelegate

- (void)dialogCompleteWithUrl:(NSURL *)url {
    TTDPRINT(@"FB dialog completed. URL is %@", url);
    
    // The only way we can find out if there's an error is by parsing the URL and checking
    // for the existence of the "error_code" param.
    // Example: fbconnect://success/?error_code=190&error_msg=Error+validating+access+token.
    NSString *errorCode = [url.parameters objectForKey:@"error_code"];
    
    // If there's an error, always reset the access token.
    // If it's an access token error, also display a message.
    if(errorCode) {
        if([errorCode isEqualToString:@"190"])
            TTAlert(@"You need to re-authenticate with Facebook. To do so, please try to share this photo again.");
        
        [self signOut];
    } else {
        NSString *postId = [url.parameters objectForKey:@"post_id"];        
        if(postId)
            for(id<LavahoundFacebookDelegate> delegate in _delegates)  
                if([delegate respondsToSelector:@selector(lavahoundFacebook:didPostToFeed:)])
                    [delegate lavahoundFacebook:self didPostToFeed:postId];
    }
}

#pragma mark -
#pragma mark LavahoundFacebook

+ (LavahoundFacebook *)sharedInstance {
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[LavahoundFacebook alloc] init];
	}
	
	return kSharedInstance;
}

- (void)addDelegate:(id<LavahoundFacebookDelegate>)delegate {
    if(![_delegates containsObject:delegate])
        [_delegates addObject:delegate];
}

- (void)removeDelegate:(id<LavahoundFacebookDelegate>)delegate {
    [_delegates removeObject:delegate];
}

- (void)showAuthorizeDialog {
    [_facebook authorize:[NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil] delegate:nil];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL result = [_facebook handleOpenURL:url];
    
    NSString *facebookOAuthToken = _facebook.accessToken;
    
    if(!facebookOAuthToken) {
        TTDPRINT(@"Facebook auth dialog was canceled.");
        return result;
    }
    
    [LocalStorage sharedInstance].facebookOAuthToken = facebookOAuthToken;
    
    for(id<LavahoundFacebookDelegate> delegate in _delegates)    
        if([delegate respondsToSelector:@selector(lavahoundFacebook:didObtainFacebookOAuthToken:)])
            [delegate lavahoundFacebook:self didObtainFacebookOAuthToken:facebookOAuthToken];
    
    return result;
}

- (void)postPhotoToFeed:(Photo *)photo {
    if(_facebook.accessToken) {
        TTDPRINT(@"Displaying FB feed post dialog for %@", photo);    
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Share on Facebook", @"user_message_prompt",
                                       photo.imageUrl, @"picture",
                                       [NSString stringWithFormat:@"%@/facebook-link?photoId=%@", [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix, photo.photoId], @"link",
                                       @"Find this on Lavahound!", @"message",
                                       nil];
        
        [_facebook dialog:@"feed" andParams:params andDelegate:self];        
    } else {  
        [_facebook authorize:[NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil] delegate:nil];
    }   
}

- (void)signOut {
    _facebook.accessToken = nil;
    [LocalStorage sharedInstance].facebookOAuthToken = nil;
}

- (BOOL)signedIn {
    return [LocalStorage sharedInstance].facebookOAuthToken != nil;
}

@end