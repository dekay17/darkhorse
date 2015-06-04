//
//  SettingsController.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SettingsController.h"
#import "LocalStorage.h"
#import "UIViewController+Lavahound.h"

static CGFloat const kButtonHeight = 43;

@interface SettingsController(PrivateMethods)

- (UILabel *)buttonLabelWithText:(NSString *)text;

@end

@implementation SettingsController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self initializeLavahoundNavigationBarWithTitle:@"settings"];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];          
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(didTouchUpInDoneButton)] autorelease];        
    }
    
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://settingsPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];
    
    static CGFloat ButtonLeft = 10;
    static CGFloat ButtonWidth = 300;
    
    UIImage *settingsButtonTopActiveImage = TTIMAGE(@"bundle://settingsTabTop.png");
    UIImage *settingsButtonBottomActiveImage = TTIMAGE(@"bundle://settingsTabBottom.png");

    UIButton *editProfileButton = [[[UIButton alloc] initWithFrame:CGRectMake(ButtonLeft, 15, ButtonWidth, kButtonHeight)] autorelease];
    [editProfileButton setBackgroundImage:settingsButtonTopActiveImage forState:UIControlStateNormal];
    [editProfileButton addSubview:[self buttonLabelWithText:@"Edit Profile"]];
	[editProfileButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[editProfileButton addTarget:self
                      action:@selector(didTouchUpInEditProfileButton)
            forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:editProfileButton]; 
    
    UIButton *changePasswordButton = [[[UIButton alloc] initWithFrame:CGRectMake(ButtonLeft, editProfileButton.bottom, ButtonWidth, kButtonHeight)] autorelease];
    [changePasswordButton setBackgroundImage:settingsButtonBottomActiveImage forState:UIControlStateNormal];    
    [changePasswordButton addSubview:[self buttonLabelWithText:@"Change Password"]];    
	[changePasswordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[changePasswordButton addTarget:self
                              action:@selector(didTouchUpInChangePasswordButton)
                    forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:changePasswordButton];
    
    UIImage *signOutButtonImage = TTIMAGE(@"bundle://buttonSignOut.png");    
    UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    [signOutButton setImage:signOutButtonImage forState:UIControlStateNormal];
	[signOutButton addTarget:self
                      action:@selector(didTouchUpInSignOutButton)
            forControlEvents:UIControlEventTouchUpInside];
	signOutButton.frame = CGRectMake(ButtonLeft, changePasswordButton.bottom + 44, signOutButtonImage.size.width, signOutButtonImage.size.height);
	[self.view addSubview:signOutButton];   
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
        return;
    
    [LocalStorage sharedInstance].apiToken = nil;
    [self dismissModalViewControllerAnimated:NO];   
    [[TTNavigator navigator] removeAllViewControllers];          
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://welcome"] applyAnimated:NO]];        
}

#pragma mark -
#pragma mark SettingsController

- (UILabel *)buttonLabelWithText:(NSString *)text {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, kButtonHeight)] autorelease];        
    label.text = text;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    label.textColor = RGBCOLOR(68, 68, 68);
    label.textAlignment = UITextAlignmentLeft;
    label.contentMode = UIViewContentModeCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)didTouchUpInDoneButton {
    [self dismissModalViewControllerAnimated:YES]; 
}

- (void)didTouchUpInEditProfileButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://edit-profile"] applyAnimated:YES]];        
}

- (void)didTouchUpInAccountSettingsButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://account-settings"] applyAnimated:YES]];    
}

- (void)didTouchUpInChangePasswordButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://change-password"] applyAnimated:YES]];    
}

- (void)didTouchUpInScreenShotsButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://screen-shots"] applyAnimated:YES]];    
}

- (void)didTouchUpInSignOutButton {
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Really sign out?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil] autorelease];
    [alertView show];    
}

@end