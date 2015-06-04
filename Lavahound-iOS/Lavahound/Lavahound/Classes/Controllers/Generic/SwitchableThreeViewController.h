//
//  SwitchableThreeViewController.h
//  Lavahound
//
//  Created by Nathan Russak on 2/22/12.
//  Copyright 2012 LavaHound. All rights reserved.
//

#import "ContainerViewController.h"

@interface SwitchableThreeViewController : ContainerViewController {
    UIButton *_leftButton;
    UIButton *_centerButton;
    UIButton *_rightButton;
}

@property(nonatomic, readonly) UIImage *leftButtonActiveImage;
@property(nonatomic, readonly) UIImage *leftButtonInactiveImage;
@property(nonatomic, readonly) UIImage *centerButtonActiveImage;
@property(nonatomic, readonly) UIImage *centerButtonInactiveImage;

@property(nonatomic, readonly) UIImage *rightButtonActiveImage;
@property(nonatomic, readonly) UIImage *rightButtonInactiveImage;

@property(nonatomic, readonly) UIImage *backgroundImage;
@property(nonatomic, readonly) CGFloat switcherButtonTop;

@property(nonatomic, readonly) BOOL showLeftButtonControllerInitially;

@property(nonatomic, readonly) UIViewController *createLeftButtonController;
@property(nonatomic, readonly) UIViewController *createCenterButtonController;
@property(nonatomic, readonly) UIViewController *createRightButtonController;

@end