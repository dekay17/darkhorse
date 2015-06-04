//
//  LocalStorage.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocalStorage.h"
#import "Three20/Three20+Additions.h"
#import "Constants.h"

static LocalStorage *kSharedInstance = nil;

static NSString *const kApiTokenStorageKey = @"apiToken";
static NSString *const kFacebookOAuthTokenStorageKey = @"facebookOAuthToken";
static NSString *const kTotalPointsStorageKey = @"totalPoints";

static NSString *const kMostRecentlyPickedImageFileRelativePath = @"MostRecentlyPickedImageFile.png";
static CGFloat const kImageCompressionLevel = 0.8;  // compression is 0(most)..1(least)

@interface LocalStorage(PrivateMethods)

- (void)storeObject:(NSObject *)object forKey:(NSString *)key;
- (id)retrieveObjectForKey:(NSString *)key;

@property(nonatomic, readonly) NSString *mostRecentlyPickedImageFilePath;

@end

@implementation LocalStorage

#pragma mark -
#pragma mark LocalStorage

+ (LocalStorage *)sharedInstance {
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[LocalStorage alloc] init];
	}
	
	return kSharedInstance;
}

- (void)storeObject:(NSObject *)object forKey:(NSString *)key {
    TTDPRINT(@"Storing '%@' for key '%@'...", object, key);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];	
    [userDefaults synchronize];
}

- (id)retrieveObjectForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id object = [userDefaults objectForKey:key];
    // TTDPRINT(@"Retrieved object '%@' for key '%@'.", object, key);    
    return object;
}

- (NSString *)apiToken {
    return [self retrieveObjectForKey:kApiTokenStorageKey];
}

- (void)setApiToken:(NSString *)apiToken {
    [self storeObject:apiToken forKey:kApiTokenStorageKey];
}

- (NSString *)facebookOAuthToken {
    return [self retrieveObjectForKey:kFacebookOAuthTokenStorageKey];
}

- (void)setFacebookOAuthToken:(NSString *)facebookOAuthToken {
    [self storeObject:facebookOAuthToken forKey:kFacebookOAuthTokenStorageKey];
}

- (NSString *)totalPoints {
    NSString *totalPoints = [self retrieveObjectForKey:kTotalPointsStorageKey];
    return totalPoints ? totalPoints : @"0";
}

- (void)setTotalPoints:(NSString *)totalPoints {
    [self storeObject:totalPoints forKey:kTotalPointsStorageKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLavahoundApiPointsChangedNotification object:self];     
}

- (void)saveMostRecentlyPickedImage:(UIImage *)mostRecentlyPickedImage {
    // Use JPEG instead of PNG since JPEG is so much smaller
    // NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(mostRecentlyPickedImage)];    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(mostRecentlyPickedImage, kImageCompressionLevel)];
    NSString *mostRecentlyPickedImageFilePath = self.mostRecentlyPickedImageFilePath;    
    TTDPRINT(@"Storing picked image data to %@", mostRecentlyPickedImageFilePath);
    [imageData writeToFile:mostRecentlyPickedImageFilePath atomically:YES];
}

- (NSData *)mostRecentlyPickedImageData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mostRecentlyPickedImageFilePath = self.mostRecentlyPickedImageFilePath;
    TTDPRINT(@"Loading picked image data from %@", self.mostRecentlyPickedImageFilePath);    
    return [fileManager fileExistsAtPath:mostRecentlyPickedImageFilePath] ? [fileManager contentsAtPath:mostRecentlyPickedImageFilePath] : nil;
}

- (NSString *)mostRecentlyPickedImageFilePath {
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];    
    return [documentsDirectoryPath stringByAppendingPathComponent:kMostRecentlyPickedImageFileRelativePath];
}

@end