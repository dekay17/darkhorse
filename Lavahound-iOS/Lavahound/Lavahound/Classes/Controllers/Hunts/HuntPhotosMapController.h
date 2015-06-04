//
//  HuntPhotosMapController.h
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "MapViewController.h"

@interface HuntPhotosMapController : MapViewController {
    NSNumber *_huntId;
    BOOL _shouldCenterMapOnHuntCenter;
}

- (id)initWithHuntId:(NSNumber *)huntId;

@end