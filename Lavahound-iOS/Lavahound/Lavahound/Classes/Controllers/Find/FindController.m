//
//  FindController.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "FindController.h"
#import "UIViewController+Lavahound.h"
#import "UINavigationBar+Lavahound.h"
#import "NearbyLocationsMapController.h"
#import "NearbyPhotoGalleryController.h"

//NSString * const kNearbyPhotoGalleryControllerKey = @"NearbyPhotoGalleryControllerKey";
//NSString * const kNearbyLocationsMapControllerKey = @"NearbyLocationsMapControllerKey";

@implementation FindController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {  
        [self initializeLavahoundNavigationBarWithTitle:@"lavahound"];
        self.tabBarItem.image = TTIMAGE(@"bundle://tabBarFind.png");
        self.tabBarItem.title = @"Nearby";
    }
    
    return self;
}

#pragma mark -
#pragma mark SwitchableViewController

- (UIViewController *)createLeftButtonController {
    return [[[NearbyLocationsMapController alloc] initWithNibName:nil bundle:nil] autorelease];
}

- (UIViewController *)createRightButtonController {
    return [[[NearbyPhotoGalleryController alloc] initWithNibName:nil bundle:nil] autorelease];    
}

@end