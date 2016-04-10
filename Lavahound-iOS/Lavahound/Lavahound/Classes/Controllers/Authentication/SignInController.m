//
//  SignInController.m
//  Lavahound
//
//  Created by Mark Allen on 4/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SignInController.h"
#import "LavahoundFacebook.h"

static NSTimeInterval const kKeyboardAnimationDuration = 0.3;

@implementation SignInController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _emailAddressTextField = nil;
        _passwordTextField = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];           
    }

    return self;
}

- (void)dealloc {     
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    _emailAddressTextField.delegate = nil;
    TT_RELEASE_SAFELY(_emailAddressTextField);
    _passwordTextField.delegate = nil;
    TT_RELEASE_SAFELY(_passwordTextField);   
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

+ (UIColor *)colorFromRGB:(NSUInteger)RGB alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((CGFloat)((RGB & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((RGB & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(RGB & 0xFF)) / 255.0
                           alpha:alpha];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Jefferson Blue
    self.view.backgroundColor = [SignInController colorFromRGB:0x0D1135 alpha:1];
// Lavahound Red
//    self.view.backgroundColor = [SignInController colorFromRGB:0xAD2A01 alpha:1];  //

    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://signInBG.png")] autorelease];    
    backgroundImageView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:backgroundImageView];
    
    _emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 211, 300, 30)];
    _emailAddressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailAddressTextField.placeholder = @"E-mail Address";
    _emailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailAddressTextField.borderStyle = UITextBorderStyleNone;
    _emailAddressTextField.font = [UIFont systemFontOfSize:14];
    _emailAddressTextField.returnKeyType = UIReturnKeyDone;
    _emailAddressTextField.delegate = self;
    // _emailAddressTextField.text = @"maa@xmog.com";
    [self.view addSubview:_emailAddressTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, _emailAddressTextField.bottom + 35, 300, 30)];
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.placeholder = @"Password";
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearsOnBeginEditing = YES;
    _passwordTextField.delegate = self;
    //_passwordTextField.text = @"test123";    
    [self.view addSubview:_passwordTextField];

    UIImage *backButtonImage = TTIMAGE(@"bundle://buttonBack.png");
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
	[backButton addTarget:self
                   action:@selector(didTouchUpInBackButton)
         forControlEvents:UIControlEventTouchUpInside];
	backButton.frame = CGRectMake(8, _passwordTextField.bottom + 15, 150, 50);
	[self.view addSubview:backButton];     
    
    UIImage *signInButtonImage = TTIMAGE(@"bundle://buttonSignInComplete.png");
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setImage:signInButtonImage forState:UIControlStateNormal];
	[signInButton addTarget:self
                     action:@selector(didTouchUpInSignInButton)
           forControlEvents:UIControlEventTouchUpInside];
	signInButton.frame = CGRectMake(160, _passwordTextField.bottom + 15, 150, 50);
	[self.view addSubview:signInButton];
    
    UIImage *forgotPasswordButtonImage = TTIMAGE(@"bundle://forgotPasswordLink.png");
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPasswordButton setImage:forgotPasswordButtonImage forState:UIControlStateNormal];
	[forgotPasswordButton addTarget:self
                             action:@selector(didTouchUpInForgotPasswordButton)
                   forControlEvents:UIControlEventTouchUpInside];
	forgotPasswordButton.frame = CGRectMake(180, _passwordTextField.top - 20, forgotPasswordButtonImage.size.width, forgotPasswordButtonImage.size.height);
	[self.view addSubview:forgotPasswordButton];     
}

- (void)viewDidUnload {
    _emailAddressTextField.delegate = nil;
    [_emailAddressTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_emailAddressTextField);
    _passwordTextField.delegate = nil;
    [_passwordTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_passwordTextField);    
    [super viewDidUnload];    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}   

#pragma mark -
#pragma mark LavahoundSignInApiDelegate

- (void)lavahoundSignInApiDidSignIn:(LavahoundSignInApi *)lavahoundSignInApi {
    [[TTURLCache sharedCache] removeAll:YES];    
    [self dismissModalViewControllerAnimated:NO];
    [[TTNavigator navigator] removeAllViewControllers]; 
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://tab-bar"] applyAnimated:YES]];
}

#pragma mark -
#pragma mark SignInController

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = -155;
    [UIView commitAnimations]; 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = 0;
    [UIView commitAnimations];    
}

- (void)didTouchUpInForgotPasswordButton {
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://forgot-password"] applyAnimated:YES]];
}

- (void)didTouchUpInSignInButton
{
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];    
    LavahoundSignInApi *lavahoundSignInApi = [[[LavahoundSignInApi alloc] init] autorelease];
    lavahoundSignInApi.delegate = self;
    [lavahoundSignInApi signInWithEmailAddress:_emailAddressTextField.text password:_passwordTextField.text];
}

- (void)didTouchUpInBackButton {
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];    
    [self.navigationController popViewControllerAnimated:YES];
}

@end