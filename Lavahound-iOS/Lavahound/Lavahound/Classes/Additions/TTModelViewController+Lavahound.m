//
//  TTModelViewController+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TTModelViewController+Lavahound.h"

@implementation TTModelViewController(Lavahound)

- (void)invalidateModelAndNetworkCache {
    TTDPRINT(@"Completely invalidating model data and network cache for %@...", [self class]);
    [self.model invalidate:YES];
    [self invalidateModel];
}

@end