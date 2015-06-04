//
//  TabBarController.h
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ImagePicker.h"
#import "PlacesController.h"
#import "ProfileController.h"
#import "PhotoDetailsController.h"
#import "MapItController.h"

@interface TabBarController : UITabBarController<ImagePickerDelegate>
{
    UIButton    * btnTabHunts;
    UIButton    * btnTabMyStuff;
    UIButton    * btnFoundIt;
    UIImageView * ivTabIconHunts;
    UIImageView * ivTabIconProfile;
    UIView      * vTabBackgroundHunts;
    UIView      * vTabBackgroundProfile;
}

- (void) setFoundItButtonVisibility:(BOOL)Visible animated:(BOOL)Animated;

@end