//
//  Constants.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Constants.h"

NSString * const kLavahoundApiDataChangedNotification = @"LavahoundApiDataChangedNotification";
NSString * const kLavahoundApiPointsChangedNotification = @"LavahoundApiPointsChangedNotification";

static Constants *kSharedInstance = nil;

@implementation Constants

#pragma mark -
#pragma mark NSObject

- (id)init {
	if((self = [super init])) {    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
        if([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)]) {
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                _deviceType	= PadDeviceType;
            } else {
                if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                    _deviceType = [UIScreen mainScreen].scale > 1 ? HighResolutionPhoneDeviceType : LowResolutionPhoneDeviceType;
                else
                    _deviceType = LowResolutionPhoneDeviceType;										
            }
        }		
#else
        _deviceType = LowResolutionPhoneDeviceType;			
#endif
	}
	
	return self;
}

// No dealloc since we're a singleton

#pragma mark -
#pragma mark Constants

+ (Constants *)sharedInstance {
	// Double-checked locking to avoid synchronization hit.
    // In the worst-case scenario we allocate/leak an extra instance or two...no big deal.	
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[Constants alloc] init];
	}
	
	return kSharedInstance;
}

- (NSString *)versionNumber {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (DeviceType)deviceType {
	return _deviceType;
}

-  (CGFloat)deviceScaleFactor {
    return _deviceType == HighResolutionPhoneDeviceType ? 2 : 1;
}

- (NSString *)facebookAppId {
    // NOTE: YOU MUST ENSURE THAT THIS VALUE IS ALSO SPECIFIED IN THE PLIST!
	return @"115767901844605";
}

- (TTURLRequestCachePolicy)cachePolicy {
    // Never cache for testing
    return TTURLRequestCachePolicyNone;
//    return TTURLRequestCachePolicyMemory;
}

- (NSTimeInterval)cacheExpirationAge {
    // Never expire for testing
    // return TT_CACHE_EXPIRATION_AGE_NEVER;
    // return TT_DEFAULT_CACHE_EXPIRATION_AGE;
    return 60 * 20;  // 20 minutes
}

- (NSString *)termsAndConditionsPageUrl {
    return [NSString stringWithFormat:@"%@/terms-and-conditions", self.apiEndpointAbsoluteUrlPrefix];    
}

- (NSString *)privacyPolicyPageUrl {
    return [NSString stringWithFormat:@"%@/privacy-policy", self.apiEndpointAbsoluteUrlPrefix];
}

- (NSString *)screenShotsPageUrl {
    return [NSString stringWithFormat:@"%@/screen-shots", self.apiEndpointAbsoluteUrlPrefix];
}

- (NSString *)xmogHomePageUrl {
    return [NSString stringWithFormat:@"http://www.xmog.com"];
}

- (NSString *)apiEndpointAbsoluteUrlPrefix {
    // Production:
    //return @"http://107.21.239.118:3000/api/";
    
    // QA:
    //return @"http://ec2-107-20-20-21.compute-1.amazonaws.com";
    
    // dan work laptop:
    return @"http://localhost:3000/api/";
    // return @"http://lavahound.dev";
}

@end
