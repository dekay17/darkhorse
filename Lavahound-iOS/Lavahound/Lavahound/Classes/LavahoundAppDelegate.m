//
//  LavahoundAppDelegate.m
//  Lavahound
//
//  Created by Mark Allen on 4/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundAppDelegate.h"
#import "Three20/Three20+Additions.h"
#import "SignInController.h"
#import "SignUpController.h"
#import "FindController.h"
#import "ChangePasswordController.h"
#import "EditProfileController.h"
#import "PhotoDetailsController.h"
#import "PhotoPositioningController.h"
#import "PhotoSavedController.h"
#import "FlagController.h"
#import "FlaggedController.h"
#import "MyPointsController.h"
#import "SettingsController.h"
#import "AboutController.h"
#import "FoundController.h"
#import "XmogController.h"
#import "ShareController.h"
#import "MapItController.h"
#import "PrivacyPolicyController.h"
#import "ScreenShotsController.h"
#import "TermsAndConditionsController.h"
#import "WelcomeController.h"
#import "FindFailedController.h"
#import "ForgotPasswordController.h"
#import "TabBarController.h"
#import "Photo.h"
#import "LavahoundFacebook.h"
#import "LocalStorage.h"
#import "LocationTracker.h"
#import "LavahoundStyleSheet.h"
#import "ProfileController.h"
#import "DummyController.h"
#import "PlacesController.h"
#import "HuntsController.h"
#import "Place.h"
#import "HuntController.h"
#import "MyStuffHomeController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>

@implementation LavahoundAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"********** didFinishLaunchingWithOptions **********");
//    [Fabric with:@[CrashlyticsKit]];
//    [Fabric with:@[TwitterKit]];

    [Fabric with:@[[Crashlytics class], [Twitter class]]];

//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    // FOR TESTING ONLY!  Clear out the cache every launch
    [[TTURLCache sharedCache] removeAll:YES];
    
	// Allow HTTP response size to be unlimited
	[[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    [TTStyleSheet setGlobalStyleSheet:[[[LavahoundStyleSheet alloc] init] autorelease]];     
    
	TTNavigator *navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeAll;
	
	TTURLMap *urlMap = navigator.URLMap;
	
    // URLs for shared controllers
    [urlMap from:@"lavahound://tab-bar" toSharedViewController:[TabBarController class]];    
    
	// URLs for modal controllers
    [urlMap from:@"lavahound://welcome" toModalViewController:[WelcomeController class]];  
    [urlMap from:@"lavahound://photo-positioning" toModalViewController:[PhotoPositioningController class]];  
    [urlMap from:@"lavahound://find-failed" toModalViewController:[FindFailedController class]];      
    [urlMap from:@"lavahound://found/(initWithPhotoId:)/(message:)/(points:)" toModalViewController:[FoundController class]];
    [urlMap from:@"lavahound://flag/(initWithPhotoId:)" toModalViewController:[FlagController class]];    
    [urlMap from:@"lavahound://share-modal/(initWithPhotoId:)/(shareControllerDismissalBehavior:)" toModalViewController:[ShareController class]];
    [urlMap from:@"lavahound://settings" toModalViewController:[SettingsController class]];            
    [urlMap from:@"lavahound://my-points" toModalViewController:[MyPointsController class]];    
    
    // URLs for normal controllers
    [urlMap from:@"lavahound://find" toViewController:[FindController class]];        
    [urlMap from:@"lavahound://sign-in" toViewController:[SignInController class]];    
    [urlMap from:@"lavahound://sign-up" toViewController:[SignUpController class]];    
    [urlMap from:@"lavahound://change-password" toViewController:[ChangePasswordController class]];    
    [urlMap from:@"lavahound://edit-profile" toViewController:[EditProfileController class]];    
    [urlMap from:@"lavahound://photo-details/(initWithPhotoId:)" toViewController:[PhotoDetailsController class]];    
    [urlMap from:@"lavahound://about" toViewController:[AboutController class]];
    [urlMap from:@"lavahound://privacy-policy" toViewController:[PrivacyPolicyController class]];                
    [urlMap from:@"lavahound://screen-shots" toViewController:[ScreenShotsController class]];                
    [urlMap from:@"lavahound://terms-and-conditions" toViewController:[TermsAndConditionsController class]];                    
    [urlMap from:@"lavahound://xmog-home-page" toViewController:[XmogController class]];                    
    [urlMap from:@"lavahound://share/(initWithPhotoId:)/(shareControllerDismissalBehavior:)" toViewController:[ShareController class]];
    [urlMap from:@"lavahound://map-it/(initWithPhotoId:)" toViewController:[MapItController class]];    
    [urlMap from:@"lavahound://saved/(initWithPhotoId:)" toViewController:[PhotoSavedController class]];    
    [urlMap from:@"lavahound://flagged" toViewController:[FlaggedController class]];        
    [urlMap from:@"lavahound://forgot-password" toViewController:[ForgotPasswordController class]];      
    [urlMap from:@"lavahound://profile" toViewController:[ProfileController class]];
    [urlMap from:@"lavahound://dummy" toViewController:[DummyController class]];    
    [urlMap from:@"lavahound://places" toViewController:[PlacesController class]];        
    [urlMap from:@"lavahound://hunts/(initWithPlaceId:)" toViewController:[HuntsController class]];    
    [urlMap from:@"lavahound://hunt/(initWithHuntId:)/(huntName:)" toViewController:[HuntController class]];        
    [urlMap from:@"lavahound://mystuffhome" toViewController:[MyStuffHomeController class]];
	
    // URLs for model objects
    [urlMap from:[Photo class] name:@"details" toURL:@"lavahound://photo-details/(photoId)"];      
    [urlMap from:[Photo class] name:@"map-it" toURL:@"lavahound://map-it/(photoId)"];    
    [urlMap from:[Photo class] name:@"share" toURL:[NSString stringWithFormat:@"lavahound://share/(photoId)/%d", ShareControllerDismissalBehaviorPopToFindController]];
    [urlMap from:[Photo class] name:@"share-modal" toURL:[NSString stringWithFormat:@"lavahound://share-modal/(photoId)/%d", ShareControllerDismissalBehaviorDefault]];
    [urlMap from:[Photo class] name:@"flag" toURL:@"lavahound://flag/(photoId)"];
    [urlMap from:[Place class] name:@"hunts" toURL:@"lavahound://hunts/(placeId)"];    
    
    
//    NSArray *windows = [[UIApplication sharedApplication] windows];
//    for(UIWindow *window in windows) {
//        NSLog(@"window: %@",window.description);
//        if(window.rootViewController == nil){
//            UIViewController* vc = [[UIViewController alloc]initWithNibName:nil bundle:nil];
//            window.rootViewController = vc;
//        }
//    }
//    UIViewController * rootViewController;// = [[UIViewController alloc] init];
    [navigator.window setRootViewController:[[UIViewController alloc] init]];
    [navigator.window makeKeyAndVisible];

//    self.window.rootViewController = rootViewController;
    NSLog(@"ApiToken %@", [LocalStorage sharedInstance].apiToken);
        if([LocalStorage sharedInstance].apiToken){
//            TabBarController *rootViewController = [[TabBarController alloc] init];
//            TabBarController *rootViewController = [navigator viewControllerForURL:@"lavahound://welcome"];
//            [ pushViewController:tabBarController animated:NO];
            //[urlMap objectForURL:@"lavahound://tab-bar"];
//            rootViewController = [navigator viewControllerForURL:@"lavahound://welcome"];
//            self.window.rootViewController = [TTNavigationController ];

//            rootViewController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
            dispatch_async(dispatch_get_main_queue(), ^{
                [navigator openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://tab-bar"] applyAnimated:NO]];
            });
            
//            rootViewController.view.bounds = self.window.bounds;
//            self.window.rootViewController = rootViewController;
        }else{
//            WelcomeController *welcomeController = [urlMap objectForURL:@"lavahound://welcome"];
//            rootViewController = [navigator viewControllerForURL:@"lavahound://welcome"];
//            self.window.rootViewController = welcomeController;
//
            [navigator openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://welcome"] applyAnimated:NO]];
//            WelcomeController *welcomeController = [[WelcomeController alloc] init];
//            rootViewController = [[UINavigationController alloc] initWithRootViewController:welcomeController];
//            rootViewController.view.bounds = self.window.bounds;
//            self.window.rootViewController = rootViewController;
    }
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    navigator.window.backgroundColor = [UIColor grayColor];
//    self.window.rootViewController = navigator;
//    [self.window makeKeyAndVisible];
//    [navigator.window setRootViewController:[[UIViewController alloc] init]];
//    [navigator.window makeKeyAndVisible];

//    CGRect frame = [[UIScreen mainScreen] bounds];
//    NSLog(@"Frame %@", NSStringFromCGRect(frame));

//    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[LavahoundFacebook sharedInstance] handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LocationTracker sharedInstance] stopUpdatingLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LocationTracker sharedInstance] stopUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LocationTracker sharedInstance] stopUpdatingLocation];    
}

@end