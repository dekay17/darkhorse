//
//  NearbyPhotoGalleryController.m
//  Lavahound
//
//  Created by Mark Allen on 4/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyPhotoGalleryController.h"
#import "PhotoGalleryDataSource.h"
#import "LocationTracker.h"

@implementation NearbyPhotoGalleryController

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.dataSource = [[[PhotoGalleryDataSource alloc] initWithCoordinate:[LocationTracker sharedInstance].location.coordinate] autorelease];
}

@end