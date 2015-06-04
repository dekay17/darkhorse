//
//  EditProfileController.m
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "EditProfileController.h"
#import "UIViewController+Lavahound.h"
#import "TTModelViewController+Lavahound.h"
#import "UserDetailsModel.h"
#import "LocalStorage.h"
#import "Constants.h"

@interface EditProfileController(PrivateMethods)

- (void)synchronizeFacebookButtonImage;

@end

@implementation EditProfileController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _displayNameTextField = nil;
        _emailAddressTextField = nil;    
        _facebookButton = nil;
        [[LavahoundFacebook sharedInstance] addDelegate:self];        
    }
    
    return self;
}

- (void)dealloc { 
    [[LavahoundFacebook sharedInstance] removeDelegate:self];    
    TT_RELEASE_SAFELY(_facebookButton);    
    _displayNameTextField.delegate = nil;
    TT_RELEASE_SAFELY(_displayNameTextField);
    _emailAddressTextField.delegate = nil;
    TT_RELEASE_SAFELY(_emailAddressTextField);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://accountPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];    
    
    _emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 42, 290, 30)];
    _emailAddressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailAddressTextField.borderStyle = UITextBorderStyleNone;
    _emailAddressTextField.font = [UIFont systemFontOfSize:14];
    _emailAddressTextField.returnKeyType = UIReturnKeyDone;
    _emailAddressTextField.delegate = self;
    [_modelView addSubview:_emailAddressTextField];

    _displayNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 110, 290, 30)];
    _displayNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _displayNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _displayNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _displayNameTextField.borderStyle = UITextBorderStyleNone;
    _displayNameTextField.font = [UIFont systemFontOfSize:14];
    _displayNameTextField.returnKeyType = UIReturnKeyDone;
    _displayNameTextField.delegate = self;
    [_modelView addSubview:_displayNameTextField];   
    
    UIImage *facebookButtonImage = TTIMAGE(@"bundle://buttonSignIntoFacebook.png");
    _facebookButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
    [_facebookButton setImage:facebookButtonImage forState:UIControlStateNormal];
	[_facebookButton addTarget:self
                          action:@selector(didTouchUpInFacebookButton)
                forControlEvents:UIControlEventTouchUpInside];
	_facebookButton.frame = CGRectMake(10, 180, facebookButtonImage.size.width, facebookButtonImage.size.height);
	[_modelView addSubview:_facebookButton];      
    
    [self synchronizeFacebookButtonImage];    
    
    UIImage *saveProfileButtonImage = TTIMAGE(@"bundle://buttonSaveAccountSettings.png");
    UIButton *saveProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    [saveProfileButton setImage:saveProfileButtonImage forState:UIControlStateNormal];
	[saveProfileButton addTarget:self
                          action:@selector(didTouchUpInSaveProfileButton)
                forControlEvents:UIControlEventTouchUpInside];
	saveProfileButton.frame = CGRectMake(10, 254, saveProfileButtonImage.size.width, saveProfileButtonImage.size.height);
	[_modelView addSubview:saveProfileButton];  
}

- (void)viewDidUnload {    
    _displayNameTextField.delegate = nil;
    [_displayNameTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_displayNameTextField);
    _emailAddressTextField.delegate = nil;
    [_emailAddressTextField removeFromSuperview];    
    TT_RELEASE_SAFELY(_emailAddressTextField);
    [_facebookButton removeFromSuperview];
    TT_RELEASE_SAFELY(_facebookButton);
    [super viewDidUnload];        
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[UserDetailsModel alloc] init] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {
    User *user = ((UserDetailsModel *)self.model).user;
    [self setTitleWithLavahoundFont:@"edit profile"];   
    _emailAddressTextField.text = user.emailAddress;
    _displayNameTextField.text = user.displayName;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}   

#pragma mark -
#pragma mark LavahoundEditProfileApiDelegate

- (void)lavahoundEditProfileApiDidUpdateProfile:(LavahoundEditProfileApi *)lavahoundEditProfileApi {
    [_model invalidate:YES];
    [self.navigationController popViewControllerAnimated:YES];
    TTAlert(@"Your profile has been updated.");
}

#pragma mark -
#pragma mark LavahoundFacebookDelegate

- (void)lavahoundFacebook:(LavahoundFacebook *)lavahoundFacebook didObtainFacebookOAuthToken:(NSString *)facebookOAuthToken {
    [self synchronizeFacebookButtonImage];    
}

#pragma mark -
#pragma mark EditProfileController

- (void)didTouchUpInSaveProfileButton {
    LavahoundEditProfileApi *lavahoundEditProfileApi = [[[LavahoundEditProfileApi alloc] init] autorelease];
    lavahoundEditProfileApi.delegate = self;
    [lavahoundEditProfileApi updateDisplayName:_displayNameTextField.text emailAddress:_emailAddressTextField.text];
}

- (void)didTouchUpInFacebookButton {
    LavahoundFacebook *lavahoundFacebook = [LavahoundFacebook sharedInstance];
    BOOL signedInToFacebook = lavahoundFacebook.signedIn;
    
    if(signedInToFacebook) {
        [lavahoundFacebook signOut];
        [self synchronizeFacebookButtonImage];
    } else {
        [lavahoundFacebook showAuthorizeDialog];
    }
}

- (void)synchronizeFacebookButtonImage {
	[_facebookButton setImage:TTIMAGE(([LavahoundFacebook sharedInstance].signedIn ? @"bundle://buttonSignOutFacebook.png" : @"bundle://buttonSignIntoFacebook.png"))
                     forState:UIControlStateNormal];    
}

@end