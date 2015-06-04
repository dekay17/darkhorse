//
//  ContainerViewController.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ContainerViewController.h"

@implementation ContainerViewController

@synthesize viewControllers = _viewControllers;

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        _viewControllers = nil;
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_viewControllers);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {    
    for(UIViewController *viewController in self.viewControllers)     
        [viewController viewDidLoad];      
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    for(UIViewController *viewController in self.viewControllers)     
        [viewController viewWillAppear:animated];  
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    for(UIViewController *viewController in self.viewControllers)     
        [viewController viewDidAppear:animated];  
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    for(UIViewController *viewController in self.viewControllers)     
        [viewController viewWillDisappear:animated];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    for(UIViewController *viewController in self.viewControllers)     
        [viewController viewDidUnload];
    
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {    
    for(UIViewController *viewController in self.viewControllers)
        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for(UIViewController *viewController in self.viewControllers)       
        [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for(UIViewController *viewController in self.viewControllers)       
        [viewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for(UIViewController *viewController in self.viewControllers)       
        [viewController didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
    
    [super didAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
    for(UIViewController *viewController in self.viewControllers)       
        [viewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
    
    [super willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {    
    for(UIViewController *viewController in self.viewControllers)     
        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning {    
    for(UIViewController *viewController in self.viewControllers)
        [viewController didReceiveMemoryWarning];
    
    [super didReceiveMemoryWarning];    
}

#pragma mark -
#pragma mark TTViewController

- (void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
    for(id viewController in self.viewControllers)
        if([viewController respondsToSelector:@selector(keyboardDidAppear:withBounds:)])
           [viewController keyboardDidAppear:animated withBounds:bounds]; 
    
    [super keyboardDidAppear:animated withBounds:bounds];
}

- (void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    for(id viewController in self.viewControllers)
        if([viewController respondsToSelector:@selector(keyboardWillDisappear:withBounds:)])
           [viewController keyboardWillDisappear:animated withBounds:bounds];
    
    [super keyboardWillDisappear:animated withBounds:bounds];
}

- (void)keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {
    for(id viewController in self.viewControllers)
        if([viewController respondsToSelector:@selector(keyboardDidDisappear:withBounds:)])        
            [viewController keyboardDidDisappear:animated withBounds:bounds];  
    
    [super keyboardDidDisappear:animated withBounds:bounds];
}

@end