//
//  UIViewController+Lavahound.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface UIViewController(Lavahound)

- (void)initializeLavahoundNavigationBarWithTitle:(NSString *)title;
- (void)setTitleWithLavahoundFont:(NSString *)title;
- (void)addPointsButtonToNavigationBar;

@end