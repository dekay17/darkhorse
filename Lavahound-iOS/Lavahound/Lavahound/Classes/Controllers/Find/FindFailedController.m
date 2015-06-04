//
//  FindFailedController.m
//  Lavahound
//
//  Created by Mark Allen on 6/7/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "FindFailedController.h"
#import "UIViewController+Lavahound.h"

@implementation FindFailedController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:nibNameOrNil bundle:nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        [self initializeLavahoundNavigationBarWithTitle:@"too far away!"];
    
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://tooFarBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];        
    
    UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 85, 280, 40)] autorelease];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.lineBreakMode = UILineBreakModeWordWrap; 
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = RGBCOLOR(162, 25, 0);
    messageLabel.text = @"Not there yet - you've still got some meat on that bone!";
    [self.view addSubview:messageLabel];        
    
    UIImage *keepPlayingButtonImage = TTIMAGE(@"bundle://buttonKeepPlaying.png");
    UIButton *keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [keepPlayingButton setImage:keepPlayingButtonImage forState:UIControlStateNormal];
    [keepPlayingButton addTarget:self
                          action:@selector(didTouchUpInKeepPlayingButton)
                forControlEvents:UIControlEventTouchUpInside];    
    keepPlayingButton.frame = CGRectMake(floorf((self.view.width - keepPlayingButtonImage.size.width) / 2), messageLabel.bottom + 50, keepPlayingButtonImage.size.width, keepPlayingButtonImage.size.height);    
	[self.view addSubview:keepPlayingButton];    
}

#pragma mark -
#pragma mark FindFailedController

- (void)didTouchUpInKeepPlayingButton {
    [self dismissModalViewControllerAnimated:YES]; 
}

@end