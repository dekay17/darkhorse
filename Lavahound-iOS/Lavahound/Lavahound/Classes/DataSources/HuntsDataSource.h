//
//  HuntsDataSource.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "HuntsModel.h"

@interface HuntsDataSource : TTListDataSource {
    HuntsModel *_huntsModel;
}

- (id)initWithPlaceId:(NSNumber *)placeId;

@end