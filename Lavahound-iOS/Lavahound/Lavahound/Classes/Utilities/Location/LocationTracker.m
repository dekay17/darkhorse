//
//  LocationTracker.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LocationTracker.h"
#import "NSMutableArray+Lavahound.h"

static LocationTracker *kSharedInstance = nil;

#pragma mark -
#pragma mark NSObject

@implementation LocationTracker

- (id)init {
    if((self = [super init])) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate = self;
        _delegates = [[NSMutableArray mutableArrayUsingWeakReferences] retain];
    }
    
    return self;
}

// No dealloc since we're a singleton

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    for(id<LocationTrackerDelegate> delegate in _delegates)
        if([delegate respondsToSelector:@selector(locationTracker:didUpdateLocation:)])
            [delegate locationTracker:self didUpdateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if([error code] == kCLErrorDenied) {
        TTDPRINT(@"Unable to get location because location services are disabled.");
        for(id<LocationTrackerDelegate> delegate in _delegates)
            if([delegate respondsToSelector:@selector(locationTrackerDidDenyLocationServices:)])
                [delegate locationTrackerDidDenyLocationServices:self];
    }
}

#pragma mark -
#pragma mark LocationTracker

+ (LocationTracker *)sharedInstance {
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[LocationTracker alloc] init];
	}
	
	return kSharedInstance;
}

- (void)addDelegate:(id<LocationTrackerDelegate>)delegate {
    if(![_delegates containsObject:delegate])
        [_delegates addObject:delegate];
}

- (void)removeDelegate:(id<LocationTrackerDelegate>)delegate {
    [_delegates removeObject:delegate];
}

- (void)startUpdatingLocation {
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [_locationManager stopUpdatingLocation];
}

- (CLLocation *)location {
    [self startUpdatingLocation];
    return _locationManager.location;
}

@end