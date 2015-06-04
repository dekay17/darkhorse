//
//  FoundController.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "FoundController.h"
#import "NSString+Lavahound.h"
#import "UIViewController+Lavahound.h"
#import "ShareController.h"

@implementation FoundController

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId message:(NSString *)message points:(NSString *)points{
    if((self = [super initWithNibName:nil bundle:nil])) {
        _photoId = [photoId retain];
        _message = [message copy];
        _points = [points copy];
        [self initializeLavahoundNavigationBarWithTitle:@"nice work!"];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];           
    }

    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photoId);
    TT_RELEASE_SAFELY(_message);
    TT_RELEASE_SAFELY(_points);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://congratsPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];   
    
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];  
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];    
    
    UIImage *dogHeadImage = TTIMAGE(@"bundle://congratsDogAndGoodJob.png");
    UIImageView *dogHeadImageView = [[[UIImageView alloc] initWithImage:dogHeadImage] autorelease];
    dogHeadImageView.frame = CGRectMake(floorf((self.view.width - dogHeadImage.size.width) / 2) - 10, 16, dogHeadImage.size.width, dogHeadImage.size.height);
    [scrollView addSubview:dogHeadImageView];      
    
    UILabel *messageLabel = [[[UILabel alloc] init] autorelease];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = RGBCOLOR(50, 50, 50);
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];    
    messageLabel.text = _message;
    messageLabel.backgroundColor = [UIColor clearColor];
    
    CGSize messageLabelSize = !messageLabel.text ? CGSizeMake(0, 0) : 
        [messageLabel.text sizeWithFont:messageLabel.font
                      constrainedToSize:CGSizeMake(self.view.width - 36, 600)
                          lineBreakMode:messageLabel.lineBreakMode];    
    
    messageLabel.frame = CGRectMake(18, dogHeadImageView.bottom + 14, messageLabelSize.width, messageLabelSize.height);
    
    [scrollView addSubview:messageLabel];        
    
    UIImage *pointsAndButtonImage = TTIMAGE(@"bundle://congratsPointsAndButtonBG.png");
    UIImageView *pointsAndButtonImageView = [[[UIImageView alloc] initWithImage:pointsAndButtonImage] autorelease];
    pointsAndButtonImageView.frame = CGRectMake(floorf((self.view.width - pointsAndButtonImage.size.width) / 2), messageLabel.bottom + 14, pointsAndButtonImage.size.width, pointsAndButtonImage.size.height);
    [scrollView addSubview:pointsAndButtonImageView];      
    
    UILabel *pointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(floorf((self.view.width - 80) / 2) - 5, pointsAndButtonImageView.top + 4, 80, 25)] autorelease];
    pointsLabel.textAlignment = UITextAlignmentCenter;
    pointsLabel.numberOfLines = 0;
    pointsLabel.textColor = RGBCOLOR(50, 50, 50);    
    pointsLabel.backgroundColor = [UIColor clearColor];    
    pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];        
    pointsLabel.text = [NSString stringWithFormat:@"+%@", _points];
    [scrollView addSubview:pointsLabel];         
    
    UIImage *shareButtonImage = TTIMAGE(@"bundle://buttonShare.png");    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[shareButton setImage:shareButtonImage forState:UIControlStateNormal];
	[shareButton addTarget:self
                    action:@selector(didTouchUpInShareButton)
          forControlEvents:UIControlEventTouchUpInside];
	shareButton.frame = CGRectMake(18, pointsAndButtonImageView.top + 87, shareButtonImage.size.width, shareButtonImage.size.height);        
	[scrollView addSubview:shareButton]; 

    UIImage *keepPlayingButtonImage = TTIMAGE(@"bundle://congratsContinueButton.png");        
    UIButton *keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[keepPlayingButton setImage:keepPlayingButtonImage forState:UIControlStateNormal];
	[keepPlayingButton addTarget:self
                          action:@selector(didTouchUpInKeepPlayingButton)
                forControlEvents:UIControlEventTouchUpInside];
	keepPlayingButton.frame = CGRectMake(shareButton.right + 6, shareButton.top, keepPlayingButtonImage.size.width, keepPlayingButtonImage.size.height);        
	[scrollView addSubview:keepPlayingButton];     
    
    scrollView.contentSize = CGSizeMake(self.view.width, pointsAndButtonImageView.bottom + 8);
    
    for(UIView *view in scrollView.subviews)
        NSLog(@"Subview: %@", view);
}

#pragma mark -
#pragma mark FoundController

- (void)didTouchUpInShareButton {
    NSString *url = [NSString stringWithFormat:@"lavahound://share/%@/%d", _photoId, ShareControllerDismissalBehaviorPopToFindController];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];    
}

- (void)didTouchUpInKeepPlayingButton {        
    [self dismissModalViewControllerAnimated:NO];        
    TTNavigationController *navigationController = (TTNavigationController *)[TTNavigator navigator].visibleViewController.parentViewController;
    [navigationController popViewControllerAnimated:YES];              
}

@end