//
//  HuntsModel.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "Place.h"

@interface HuntsModel : LavahoundModel {
    NSNumber *_placeId;
    Place *_place;
    NSMutableArray *_hunts;
}

- (id)initWithPlaceId:(NSNumber *)placeId;

@property(nonatomic, readonly) Place *place;
@property(nonatomic, readonly) NSArray *hunts;

@end