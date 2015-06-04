//
//  HuntsController.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TableViewController.h"

@interface HuntsController : TableViewController {
    NSNumber *_placeId;
    UILabel *_placeNameLabel;
}

- (id)initWithPlaceId:(NSNumber *)placeId;

@end