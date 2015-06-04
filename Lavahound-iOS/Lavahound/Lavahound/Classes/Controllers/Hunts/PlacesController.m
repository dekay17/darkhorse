//
//  PlacesController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PlacesController.h"
#import "UIViewController+Lavahound.h"
#import "NearbyPlacesMapController.h"
#import "NearbyPlacesListController.h"

@implementation PlacesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {  
        [self initializeLavahoundNavigationBarWithTitle:@"lavahound"];
        self.tabBarItem.image = TTIMAGE(@"bundle://tabBarHunts.png");
        self.tabBarItem.title = @"Hunts";
    }
    return self;
}

#pragma mark -
#pragma mark SwitchableViewController

- (BOOL)showLeftButtonControllerInitially {
    return NO;
}

- (UIImage *)rightButtonActiveImage {
    return TTIMAGE(@"bundle://findListButtonActive.png");
}

- (UIImage *)rightButtonInactiveImage {
    return TTIMAGE(@"bundle://findListButtonInactive.png");
}

- (UIViewController *)createLeftButtonController {
    return [[[NearbyPlacesMapController alloc] initWithNibName:nil bundle:nil] autorelease];
}

- (UIViewController *)createRightButtonController {
    return [[[NearbyPlacesListController alloc] initWithNibName:nil bundle:nil] autorelease];    
}

@end