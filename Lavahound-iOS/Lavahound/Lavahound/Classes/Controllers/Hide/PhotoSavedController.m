//
//  PhotoSavedController.m
//  Lavahound
//
//  Created by Mark Allen on 5/15/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoSavedController.h"
#import "UIViewController+Lavahound.h"
#import "PhotoDetailsModel.h"
#import "ShareController.h"

@implementation PhotoSavedController

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _pointsLabel = nil;
        _photoId = [photoId retain];        
        [self initializeLavahoundNavigationBarWithTitle:@"upload complete"];
        self.navigationItem.hidesBackButton = YES;        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];          
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_pointsLabel);
    TT_RELEASE_SAFELY(_photoId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://congratsBG.png")] autorelease];
    [_modelView addSubview:backgroundImageView];       
    
    UILabel *wellDoneLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 165, self.view.width, 22)] autorelease];
    wellDoneLabel.textAlignment = UITextAlignmentCenter;
    wellDoneLabel.lineBreakMode = UILineBreakModeWordWrap; 
    wellDoneLabel.numberOfLines = 0;
    wellDoneLabel.textColor = RGBCOLOR(162, 25, 0);
    wellDoneLabel.backgroundColor = [UIColor clearColor];
    wellDoneLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    wellDoneLabel.text = @"You've Hidden a Photo!";
    [_modelView addSubview:wellDoneLabel];      
    
    UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, wellDoneLabel.bottom + 6, self.view.width - 60, 64)] autorelease];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = RGBCOLOR(50, 50, 50);
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];    
    messageLabel.text = @"Now others can try to sniff out your pic. Thanks for hiding it!";
    messageLabel.backgroundColor = [UIColor clearColor];
    [_modelView addSubview:messageLabel];        
    
    _pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 273, 85, 25)];
    _pointsLabel.textAlignment = UITextAlignmentCenter;
    _pointsLabel.numberOfLines = 0;
    _pointsLabel.textColor = RGBCOLOR(50, 50, 50);    
    _pointsLabel.backgroundColor = [UIColor clearColor];    
    _pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];        
    [_modelView addSubview:_pointsLabel];         
    
    UILabel *pointsDescriptionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_pointsLabel.left + 3, _pointsLabel.bottom, _pointsLabel.width, 14)] autorelease];
    pointsDescriptionLabel.textAlignment = UITextAlignmentCenter;
    pointsDescriptionLabel.numberOfLines = 0;
    pointsDescriptionLabel.textColor = RGBCOLOR(50, 50, 50);    
    pointsDescriptionLabel.backgroundColor = [UIColor clearColor];    
    pointsDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];        
    pointsDescriptionLabel.text = @"Points";
    [_modelView addSubview:pointsDescriptionLabel];     
    
    UIImage *shareButtonImage = TTIMAGE(@"bundle://buttonShare.png");    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[shareButton setImage:shareButtonImage forState:UIControlStateNormal];
	[shareButton addTarget:self
                    action:@selector(didTouchUpInShareButton)
          forControlEvents:UIControlEventTouchUpInside];
	shareButton.frame = CGRectMake(18, 355, shareButtonImage.size.width, shareButtonImage.size.height);        
	[_modelView addSubview:shareButton]; 
    
    UIImage *keepPlayingButtonImage = TTIMAGE(@"bundle://congratsContinueButton.png");        
    UIButton *keepPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];  
	[keepPlayingButton setImage:keepPlayingButtonImage forState:UIControlStateNormal];
	[keepPlayingButton addTarget:self
                          action:@selector(didTouchUpInKeepPlayingButton)
                forControlEvents:UIControlEventTouchUpInside];
	keepPlayingButton.frame = CGRectMake(shareButton.right + 6, shareButton.top, keepPlayingButtonImage.size.width, keepPlayingButtonImage.size.height);        
	[_modelView addSubview:keepPlayingButton];            
}

- (void)viewDidUnload {
    [_pointsLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_pointsLabel);    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[PhotoDetailsModel alloc] initWithPhotoId:_photoId] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {
    [self setTitleWithLavahoundFont:@"upload complete"];
    
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;
    _pointsLabel.text = [NSString stringWithFormat:@"+%@", photo.points];
}

#pragma mark -
#pragma mark FoundController

- (void)didTouchUpInShareButton {
    NSString *url = [NSString stringWithFormat:@"lavahound://share/%@/%d", _photoId, ShareControllerDismissalBehaviorDefault];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];    
}

- (void)didTouchUpInKeepPlayingButton {
    [self dismissModalViewControllerAnimated:YES];        
}

@end