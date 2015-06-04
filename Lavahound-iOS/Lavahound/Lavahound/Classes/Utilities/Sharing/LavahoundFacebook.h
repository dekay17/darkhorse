//
//  LavahoundFacebook.h
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UnreleasableObject.h"
#import "FBConnect.h"
#import "Photo.h"

@protocol LavahoundFacebookDelegate;

@interface LavahoundFacebook : UnreleasableObject<FBDialogDelegate> {
    Facebook *_facebook;
    NSMutableArray *_delegates;
}

+ (LavahoundFacebook *)sharedInstance;

- (void)showAuthorizeDialog;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)postPhotoToFeed:(Photo *)photo;
- (void)signOut;

- (void)addDelegate:(id<LavahoundFacebookDelegate>)delegate;
- (void)removeDelegate:(id<LavahoundFacebookDelegate>)delegate;

@property(nonatomic, readonly) BOOL signedIn;

@end

@protocol LavahoundFacebookDelegate<NSObject>

@optional

- (void)lavahoundFacebook:(LavahoundFacebook *)lavahoundFacebook didObtainFacebookOAuthToken:(NSString *)facebookOAuthToken;
- (void)lavahoundFacebook:(LavahoundFacebook *)lavahoundFacebook didPostToFeed:(NSString *)postId;

@end