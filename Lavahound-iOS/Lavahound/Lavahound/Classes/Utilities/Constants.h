//
//  Constants.h
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UnreleasableObject.h"
#import "Three20/Three20.h"

extern NSString * const kLavahoundApiDataChangedNotification;
extern NSString * const kLavahoundApiPointsChangedNotification;

typedef enum {
	UnknownDeviceType,
	PadDeviceType,	
	LowResolutionPhoneDeviceType,
	HighResolutionPhoneDeviceType
} DeviceType;

@interface Constants : UnreleasableObject {
    DeviceType _deviceType;
}

+ (Constants *)sharedInstance;

// What's our version number?
@property (nonatomic, readonly) NSString *versionNumber;

// What kind of device are we running on?
@property (nonatomic, readonly) DeviceType deviceType;

// What is the scale factor for the device's screen?
@property (nonatomic, readonly) CGFloat deviceScaleFactor;

// Sandra Lee Facebook App ID
@property (nonatomic, readonly) NSString *facebookAppId;

// Network caching policy
@property (nonatomic, readonly) TTURLRequestCachePolicy cachePolicy;

// Network cache expiration age
@property (nonatomic, readonly) NSTimeInterval cacheExpirationAge;

// Absolute base URL for the server-side API
@property (nonatomic, readonly) NSString *apiEndpointAbsoluteUrlPrefix;

// Absolute URL for the Terms and Conditions webpage
@property (nonatomic, readonly) NSString *termsAndConditionsPageUrl;

// Absolute URL for the privacy policy webpage
@property (nonatomic, readonly) NSString *privacyPolicyPageUrl;

// Absolute URL for the screen shots webpage
@property (nonatomic, readonly) NSString *screenShotsPageUrl;

// Absolute URL for the xmog webpage
@property (nonatomic, readonly) NSString *xmogHomePageUrl;

@end