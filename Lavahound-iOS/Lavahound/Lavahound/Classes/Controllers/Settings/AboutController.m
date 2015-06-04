//
//  AboutController.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "AboutController.h"
#import "UIViewController+Lavahound.h"
#import "LavahoundEmailer.h"

@implementation AboutController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self initializeLavahoundNavigationBarWithTitle:@"lavahound"];
        [self addPointsButtonToNavigationBar];        
        self.tabBarItem.image = TTIMAGE(@"bundle://tabBarAbout.png");
        self.tabBarItem.title = @"About";
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];
    }
    
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://aboutPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];        
    
    UIImageView *whiteBoxImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://aboutPageWhiteBoxBG.png")] autorelease];
    whiteBoxImageView.top = 12;
    whiteBoxImageView.left = 12;
    [self.view addSubview:whiteBoxImageView];

    UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 88, 280, 60)] autorelease];
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.lineBreakMode = UILineBreakModeWordWrap; 
    messageLabel.numberOfLines = 0;

    messageLabel.textColor = RGBCOLOR(162, 25, 0);
    messageLabel.backgroundColor = [UIColor clearColor];
    [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];       
    messageLabel.text = @"Lavahound is a mobile app that takes everyday things and places and turns them into games, stories, tours and more.";
	[self.view addSubview:messageLabel];
    
    UILabel *descriptionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, messageLabel.bottom+24, 280, 60)] autorelease];
//    descriptionLabel.textAlignment = UITextAlignmentLeft;
//    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap; 
//    descriptionLabel.numberOfLines = 0;
//    descriptionLabel.backgroundColor = [UIColor clearColor];
//    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];       
//    descriptionLabel.text = @"Lavahound is a mobile app that takes everyday things and places and turns them into games, stories, tours and more.";
//	[self.view addSubview:descriptionLabel];    
    
    UILabel *learnMessageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, descriptionLabel.bottom+10, 280, 26)] autorelease];
    learnMessageLabel.textAlignment = UITextAlignmentLeft;
    learnMessageLabel.lineBreakMode = UILineBreakModeWordWrap; 
    learnMessageLabel.numberOfLines = 0;    
    learnMessageLabel.backgroundColor = [UIColor clearColor];
    [learnMessageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    learnMessageLabel.text = @"Want to learn more about Lavahound?";
	[self.view addSubview:learnMessageLabel];
    
    UIImage *buttonAboutEmailImage = TTIMAGE(@"bundle://buttonAboutEmail.png");
    UIButton *buttonAboutEmail = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAboutEmail setImage:buttonAboutEmailImage forState:UIControlStateNormal];
    [buttonAboutEmail addTarget:self
                        action:@selector(didTouchUpInAboutEmailButton)
              forControlEvents:UIControlEventTouchUpInside];    
    buttonAboutEmail.frame = CGRectMake(12, learnMessageLabel.bottom +5, buttonAboutEmailImage.size.width, buttonAboutEmailImage.size.height);    
	[self.view addSubview:buttonAboutEmail];

    UIImage *buttonAboutCallImage = TTIMAGE(@"bundle://buttonAboutCall.png");
    UIButton *buttonAboutCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAboutCall setImage:buttonAboutCallImage forState:UIControlStateNormal];
    [buttonAboutCall addTarget:self
                        action:@selector(didTouchUpInAboutCallButton)
              forControlEvents:UIControlEventTouchUpInside];
    buttonAboutCall.frame = CGRectMake(163, learnMessageLabel.bottom +5, buttonAboutCallImage.size.width, buttonAboutCallImage.size.height);            
	[self.view addSubview:buttonAboutCall];

    UIImageView *hrImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://aboutPageHR.png")] autorelease];
    hrImageView.left = 12;
    hrImageView.top = buttonAboutCall.bottom + 14;
    [self.view addSubview:hrImageView];      
    
    UILabel *versionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(12, hrImageView.bottom + 12, 90, 18)] autorelease];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", [Constants sharedInstance].versionNumber];
    versionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    versionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:versionLabel];
        
    UIImage *textLinkPrivacyImage = TTIMAGE(@"bundle://textLinkPrivacy.png");
    UIButton *textLinkPrivacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textLinkPrivacyButton setImage:textLinkPrivacyImage forState:UIControlStateNormal];
    [textLinkPrivacyButton addTarget:self
                              action:@selector(didTouchUpInPrivacyPolicyButton)
                    forControlEvents:UIControlEventTouchUpInside];
    textLinkPrivacyButton.frame = CGRectMake(243, versionLabel.top + 4, textLinkPrivacyImage.size.width, textLinkPrivacyImage.size.height);            
	[self.view addSubview:textLinkPrivacyButton];    
    
    UIImage *textLinkTermsImage = TTIMAGE(@"bundle://textLinkTerms.png");
    UIButton *textLinkTermsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textLinkTermsButton setImage:textLinkTermsImage forState:UIControlStateNormal];
    [textLinkTermsButton addTarget:self
                            action:@selector(didTouchUpInTermsAndConditionsButton)
                  forControlEvents:UIControlEventTouchUpInside];
    textLinkTermsButton.frame = CGRectMake(textLinkPrivacyButton.left - textLinkTermsImage.size.width - 8, textLinkPrivacyButton.top, textLinkTermsImage.size.width, textLinkTermsImage.size.height);            
	[self.view addSubview:textLinkTermsButton];     
}

#pragma mark -
#pragma mark AboutController

- (void)didTouchUpInAboutXmogButton { 
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://xmog-home-page"] applyAnimated:YES]];
}

- (void)didTouchUpInAboutEmailButton {
    [[LavahoundEmailer sharedInstance] emailContactUs];
}

- (void)didTouchUpInAboutCallButton {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18883305893"]];
}

- (void)didTouchUpInTermsAndConditionsButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://terms-and-conditions"] applyAnimated:YES]];
}

- (void)didTouchUpInPrivacyPolicyButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://privacy-policy"] applyAnimated:YES]];    
}

@end