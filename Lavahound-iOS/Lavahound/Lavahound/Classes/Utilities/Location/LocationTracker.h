//
//  LocationTracker.h
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Three20/Three20+Additions.h"
#import "UnreleasableObject.h"

@protocol LocationTrackerDelegate;

@interface LocationTracker : UnreleasableObject<CLLocationManagerDelegate> {
    NSMutableArray *_delegates;    
    CLLocationManager *_locationManager;    
}

+ (LocationTracker *)sharedInstance;

- (void)addDelegate:(id<LocationTrackerDelegate>)delegate;
- (void)removeDelegate:(id<LocationTrackerDelegate>)delegate;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@property(nonatomic, readonly) CLLocation *location;

@end


@protocol LocationTrackerDelegate<NSObject>

@optional

- (void)locationTrackerDidDenyLocationServices:(LocationTracker *)locationTracker;
- (void)locationTracker:(LocationTracker *)locationTracker didUpdateLocation:(CLLocation *)location;

@end