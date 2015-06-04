//
//  PointsModel.h
//  Lavahound
//
//  Created by Mark Allen on 5/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundModel.h"
#import "Points.h"

@interface PointsModel : LavahoundModel {
    Points *_points;
}

@property(nonatomic, readonly) Points *points;

@end