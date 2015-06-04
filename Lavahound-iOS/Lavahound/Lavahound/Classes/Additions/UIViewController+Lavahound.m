//
//  UIViewController+Lavahound.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "UIViewController+Lavahound.h"
#import "Three20/Three20+Additions.h"
#import "PointsButton.h"

@implementation UIViewController(Lavahound)

- (void)initializeLavahoundNavigationBarWithTitle:(NSString *)title {
    // self.navigationController.navigationBar.tintColor = RGBCOLOR(173, 41, 0);
    
    if([self isKindOfClass:[TTBaseViewController class]])
        ((TTBaseViewController *)self).navigationBarTintColor = RGBCOLOR(173, 41, 0);
    
    [self setTitleWithLavahoundFont:title];
}

- (void)addPointsButtonToNavigationBar
{
    PointsButton *pointsButton = [[[PointsButton alloc] initWithFrame:CGRectMake(0, 0, 68, 36)] autorelease];
    [pointsButton addTarget:self action:@selector(didTouchUpInPointsButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:pointsButton] autorelease];
}

- (void)setTitleWithLavahoundFont:(NSString *)title {
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) { 
        titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"DiavloBold-Regular" size:24];  
        titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];        
    }
    
    titleLabel.text = title;
    [titleLabel sizeToFit];

    self.navigationItem.titleView = titleLabel;    
    // self.navigationItem.title = title;
    self.title = title;            
}

- (void)didTouchUpInPointsButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://my-points"] applyAnimated:YES]];
}

@end