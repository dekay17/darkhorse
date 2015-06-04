//
//  LavahoundTableViewDragRefreshDelegate.m
//  Lavahound
//
//  Created by Mark Allen on 5/21/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundTableViewDragRefreshDelegate.h"
#import "TTModelViewController+Lavahound.h"

// The number of pixels the table needs to be pulled down by in order to initiate the refresh.
static const CGFloat kRefreshDeltaY = -65.0f;

@implementation LavahoundTableViewDragRefreshDelegate

#pragma mark -
#pragma mark TTTableViewDragRefreshDelegate

// Instead of just causing a reload of the same URL over the network, we forcefully trigger a recreation of the model.
// Useful for when the model URL parameters include current location, which might change over time.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= kRefreshDeltaY && !_model.isLoading) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"DragRefreshTableReload" object:nil];
        [self.controller invalidateModelAndNetworkCache];
    }
}

@end