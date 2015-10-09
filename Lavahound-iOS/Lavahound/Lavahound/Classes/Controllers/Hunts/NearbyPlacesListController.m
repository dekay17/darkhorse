//
//  NearbyPlacesListController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "NearbyPlacesListController.h"
#import "PlacesDataSource.h"
#import "LocationTracker.h"

@implementation NearbyPlacesListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.dataSource = [[[PlacesDataSource alloc] initWithCoordinate:[LocationTracker sharedInstance].location.coordinate] autorelease];
}

@end