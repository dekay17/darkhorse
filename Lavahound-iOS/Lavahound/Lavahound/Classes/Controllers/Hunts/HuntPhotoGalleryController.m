//
//  HuntPhotoGalleryController.m
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntPhotoGalleryController.h"
#import "PhotoGalleryDataSource.h"
#import "LocationTracker.h"

@implementation HuntPhotoGalleryController

#pragma mark -
#pragma mark NSObject

- (id)initWithHuntId:(NSNumber *)huntId {
    if((self = [super initWithNibName:nil bundle:nil]))   
        _huntId = [huntId retain];
    
    return self;    
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_huntId);
    [super dealloc];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.dataSource = [[[PhotoGalleryDataSource alloc] initWithCoordinate:[LocationTracker sharedInstance].location.coordinate huntId:_huntId] autorelease];
}

@end