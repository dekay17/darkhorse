//
//  LocalStorage.h
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UnreleasableObject.h"

@interface LocalStorage : UnreleasableObject {}

+ (LocalStorage *)sharedInstance;

// Stores to NSDefaults
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *apiToken;
@property(nonatomic, copy) NSString *facebookOAuthToken;
@property(nonatomic, copy) NSString *totalPoints;

// Stores to the filesystem
- (void)saveMostRecentlyPickedImage:(UIImage *)mostRecentlyPickedImage;
@property(nonatomic, readonly) NSData *mostRecentlyPickedImageData;

@end