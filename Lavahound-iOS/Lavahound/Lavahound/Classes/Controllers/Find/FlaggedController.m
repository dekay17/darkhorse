//
//  FlaggedController.m
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "FlaggedController.h"
#import "UIViewController+Lavahound.h"

@implementation FlaggedController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self initializeLavahoundNavigationBarWithTitle:@"shot flagged"];
        self.navigationItem.hidesBackButton = YES;
    }
    
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *shotFlaggedLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 18)] autorelease];
    shotFlaggedLabel.text = @"Shot successfully flagged.";
    [self.view addSubview:shotFlaggedLabel];       
    
    UIButton *keepPlayingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
	[keepPlayingButton setTitle:@"Keep Playing" forState:UIControlStateNormal];
	[keepPlayingButton addTarget:self
                     action:@selector(didTouchUpInKeepPlayingButton)
           forControlEvents:UIControlEventTouchUpInside];
	keepPlayingButton.frame = CGRectMake(10, shotFlaggedLabel.bottom + 10, 300, 50);        
	[self.view addSubview:keepPlayingButton]; 
}

#pragma mark -
#pragma mark FlagController

- (void)didTouchUpInKeepPlayingButton {
    TTNavigator *navigator = [TTNavigator navigator];    
    [self dismissModalViewControllerAnimated:NO];        
    [navigator.visibleViewController.navigationController popViewControllerAnimated:NO];    
    [navigator openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://find"] applyAnimated:NO]];   
}

@end