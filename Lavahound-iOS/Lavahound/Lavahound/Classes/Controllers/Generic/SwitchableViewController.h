//
//  SwitchableViewController.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ContainerViewController.h"

@interface SwitchableViewController : ContainerViewController {
    UIButton *_leftButton;
    UIButton *_rightButton;
}

@property(nonatomic, readonly) UIImage *leftButtonActiveImage;
@property(nonatomic, readonly) UIImage *leftButtonInactiveImage;
@property(nonatomic, readonly) UIImage *rightButtonActiveImage;
@property(nonatomic, readonly) UIImage *rightButtonInactiveImage;

@property(nonatomic, readonly) UIImage *backgroundImage;
@property(nonatomic, readonly) CGFloat switcherButtonTop;

@property(nonatomic, readonly) BOOL showLeftButtonControllerInitially;

@property(nonatomic, readonly) UIViewController *createLeftButtonController;
@property(nonatomic, readonly) UIViewController *createRightButtonController;

@end