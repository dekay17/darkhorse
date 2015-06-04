//
//  ProfileController.m
//  Lavahound
//
//  Created by Mark Allen on 7/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ProfileController.h"
#import "UserDetailsModel.h"
#import "UIViewController+Lavahound.h"
#import "TTModelViewController+Lavahound.h"
#import "Constants.h"

@implementation ProfileController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:@"MyProfile" bundle:nibBundleOrNil]))
    {
        _photosHiddenLabel = nil;      
        _timesFoundLabel = nil;           
        _rankLabel = nil;
        _displayNameLabel = nil;
        _emailAddressLabel = nil;
        _userImageView = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiDataChangedNotification:) 
                                                     name:kLavahoundApiDataChangedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TT_RELEASE_SAFELY(_photosHiddenLabel);      
    TT_RELEASE_SAFELY(_timesFoundLabel);    
    TT_RELEASE_SAFELY(_rankLabel);    
    TT_RELEASE_SAFELY(_displayNameLabel);    
    TT_RELEASE_SAFELY(_emailAddressLabel);        
    TT_RELEASE_SAFELY(_userImageView);    
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    [_modelView removeFromSuperview];

//    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://profilePageBG.png")] autorelease];
//    [_modelView addSubview:backgroundImageView];
//
//    _photosHiddenLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 146, 78, 26)];
//    _photosHiddenLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
//    _photosHiddenLabel.textColor = RGBCOLOR(50, 50, 50);
//    _photosHiddenLabel.textAlignment = UITextAlignmentCenter;   
//    _photosHiddenLabel.backgroundColor = [UIColor clearColor];        
//    [_modelView addSubview:_photosHiddenLabel];
//    
//    _timesFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, _photosHiddenLabel.top, _photosHiddenLabel.width, _photosHiddenLabel.height)];
//    _timesFoundLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
//    _timesFoundLabel.textColor = RGBCOLOR(50, 50, 50);
//    _timesFoundLabel.textAlignment = UITextAlignmentCenter;   
//    _timesFoundLabel.backgroundColor = [UIColor clearColor];        
//    [_modelView addSubview:_timesFoundLabel];    
//    
//    _rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(222, _photosHiddenLabel.top, _photosHiddenLabel.width, _photosHiddenLabel.height)];
//    _rankLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
//    _rankLabel.textColor = RGBCOLOR(50, 50, 50);
//    _rankLabel.textAlignment = UITextAlignmentCenter;   
//    _rankLabel.backgroundColor = [UIColor clearColor];        
//    [_modelView addSubview:_rankLabel];        
//    
//    _userImageView = [[LoadingAwareImageView alloc] initWithFrame:CGRectMake(17, 17, 76, 75) contentMode:UIViewContentModeScaleAspectFit];
//    [_modelView addSubview:_userImageView];    
//    
//    _displayNameLabel = [[UILabel alloc] init];
//    _displayNameLabel.font = [UIFont boldSystemFontOfSize:20];
//    _displayNameLabel.textColor = RGBCOLOR(50, 50, 50);
//    _displayNameLabel.contentMode = UIViewContentModeCenter;
//    _displayNameLabel.backgroundColor = [UIColor clearColor];        
//    [_modelView addSubview:_displayNameLabel];            
//    
//    _emailAddressLabel = [[UILabel alloc] init];
//    _emailAddressLabel.font = [UIFont systemFontOfSize:16];
//    _emailAddressLabel.textColor = RGBCOLOR(50, 50, 50);
//    _emailAddressLabel.contentMode = UIViewContentModeCenter;
//    _emailAddressLabel.backgroundColor = [UIColor clearColor];        
//    [_modelView addSubview:_emailAddressLabel];
}

- (void)viewDidUnload
{
    [_photosHiddenLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_photosHiddenLabel);
    [_timesFoundLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_timesFoundLabel);
    [_rankLabel removeFromSuperview];          
    TT_RELEASE_SAFELY(_rankLabel);    
    [_displayNameLabel removeFromSuperview];          
    TT_RELEASE_SAFELY(_displayNameLabel);    
    [_emailAddressLabel removeFromSuperview];          
    TT_RELEASE_SAFELY(_emailAddressLabel);        
    [_userImageView removeFromSuperview];     
    TT_RELEASE_SAFELY(_userImageView);
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel
{
    self.model = [[[UserDetailsModel alloc] init] autorelease];
    
    [ContentFacebookUser    removeFromSuperview];
    [ContentLavaUser        removeFromSuperview];
}

- (void)didShowModel:(BOOL)firstTime
{
    User *user = ((UserDetailsModel *)self.model).user;

    [self setTitleWithLavahoundFont:@"my profile"];
    
    if ([LocalStorage sharedInstance].facebookOAuthToken)
    {
        [ContentContainer addSubview:ContentFacebookUser];
        
        [UserPhoto setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]]];
        [FacebookDisplayName setText:user.displayName];
    }
    else
    {
        [ContentContainer addSubview:ContentLavaUser];
        
        [EmailAddress   setText:user.emailAddress];
        [DisplayName 	setText:user.displayName];
    }

    [ContentContainer setHidden:FALSE];
    [ContentContainer setAlpha:0.1f];
    
    [UIView animateWithDuration:0.2f animations:^{ [ContentContainer setAlpha:1.0f];}];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)didTouchUpInSettingsButton
{
//    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://settings"] applyAnimated:YES]];
}

#pragma mark -
#pragma mark ProfileController

- (void)didReceiveLavahoundApiDataChangedNotification:(NSNotification *)notification
{
    TTDPRINT(@"Received %@, invalidating model data...", [notification name]);
    [self invalidateModelAndNetworkCache];
}

- (IBAction) EventUpdateEmailAndDisplayName
{    
    LavahoundEditProfileApi * lavahoundEditProfileApi = nil;
    UIAlertView * InputError    = nil;
    NSString    * NameText      = nil,
                * EmailText     = nil;
    
    EmailText = [EmailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NameText = [DisplayName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (EmailText.length == 0)
    {
        InputError = [[UIAlertView alloc] initWithTitle:nil message:@"Enter An Email Address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [InputError show];
        [InputError release];
    }
    else if (NameText.length == 0)
    {
        InputError = [[UIAlertView alloc] initWithTitle:nil message:@"Enter A Display Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [InputError show];
        [InputError release];        
    }
    else
    {
        lavahoundEditProfileApi = [[LavahoundEditProfileApi alloc] init];
        [lavahoundEditProfileApi setDelegate:self];
        [lavahoundEditProfileApi updateDisplayName:NameText emailAddress:EmailText];
        [lavahoundEditProfileApi release];
    }
}

- (IBAction) EventUpdateAccountPassword
{    
    NSString    * TextOldPass           = nil,
                * TextNewPass           = nil,
                * TextNewPassConfirm    = nil;
    LavahoundChangePasswordApi * lavahoundChangePasswordApi = nil;
    UIAlertView * PasswordError = nil;
    
    TextOldPass = [OldPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    TextNewPass = [NewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    TextNewPassConfirm = [NewPasswordConfirm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (TextOldPass.length == 0)
    {
        PasswordError = [[UIAlertView alloc] initWithTitle:nil message:@"Enter The Original Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [PasswordError show];
        [PasswordError release];
    }
    else if (TextNewPass.length == 0)
    {
        PasswordError = [[UIAlertView alloc] initWithTitle:nil message:@"Enter A New Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [PasswordError show];
        [PasswordError release];
    }
    else if (TextNewPassConfirm.length == 0)
    {
        PasswordError = [[UIAlertView alloc] initWithTitle:nil message:@"Confirm Your New Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [PasswordError show];
        [PasswordError release];        
    }
    else if (![TextNewPass isEqualToString:TextNewPassConfirm])
    {
        PasswordError = [[UIAlertView alloc] initWithTitle:nil message:@"New Paswords Do Not Match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [PasswordError show];
        [PasswordError release];
    }
    else
    {
        lavahoundChangePasswordApi = [[LavahoundChangePasswordApi alloc] init];
        lavahoundChangePasswordApi.delegate = self;
        [lavahoundChangePasswordApi changePassword:NewPassword.text
                                   confirmPassword:NewPasswordConfirm.text
                                       oldPassword:OldPassword.text];
        [lavahoundChangePasswordApi release];
    }
}

- (IBAction) EventUpdateFacebookDisplayName
{
    NSString * FacebookName = nil;
    LavahoundEditProfileApi *lavahoundEditProfileApi = nil;
    UIAlertView * InputError = nil;
    
    FacebookName = [FacebookDisplayName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (FacebookName.length == 0)
    {
        InputError = [[UIAlertView alloc] initWithTitle:nil message:@"Enter A Display Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [InputError show];
        [InputError release];
    }
    else
    {
        lavahoundEditProfileApi = [[LavahoundEditProfileApi alloc] init];
        [lavahoundEditProfileApi setDelegate:self];
        [lavahoundEditProfileApi updateDisplayName:FacebookName emailAddress:nil];
        [lavahoundEditProfileApi release];
    }
}

- (void)lavahoundEditProfileApiDidUpdateProfile:(LavahoundEditProfileApi *)lavahoundEditProfileApi {
    TTAlert(@"Your profile has been updated.");
}

- (void)lavahoundChangePasswordApiDidChangePassword:(LavahoundChangePasswordApi *)lavahoundChangePasswordApi {
    TTAlert(@"Your password has been updated.");
    [NewPassword        setText:nil];
    [NewPasswordConfirm setText:nil];
    [OldPassword        setText:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{    
    if ((textField == OldPassword) || (textField == NewPassword) || (textField == NewPasswordConfirm))
    {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
                                 {
                                     [ContentContainer setFrame:CGRectMake(0.0f, - 163.0f, ContentContainer.frame.size.width, ContentContainer.frame.size.height)];
                                 }
                        completion:^(BOOL finished){}];
    }
    else if (textField == FacebookDisplayName)
    {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
                                 {
                                     [ContentContainer setFrame:CGRectMake(0.0f, -128.0f, ContentContainer.frame.size.width, ContentContainer.frame.size.height)];
                                 }
                         completion:^(BOOL finished){}];        
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
                             {
                                 [ContentContainer setFrame:CGRectMake(0.0f, 0.0f, ContentContainer.frame.size.width, ContentContainer.frame.size.height)];
                             }
                     completion:^(BOOL finished){}];
    
    return TRUE;
}

@end