//
//  SignUpController.m
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SignUpController.h"

static NSTimeInterval const kKeyboardAnimationDuration = 0.3;

@implementation SignUpController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:@"SignUp" bundle:nibBundleOrNil])) {
//        _emailAddressTextField = nil;
//        _passwordTextField = nil;
//        _passwordConfirmTextField = nil;
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
    _passwordConfirmTextField.delegate = nil;
    TT_RELEASE_SAFELY(_passwordConfirmTextField);        
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
    
    self.view.backgroundColor = [SignUpController colorFromRGB:0xAD2A01 alpha:1];
    
//    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://signUpBG.png")] autorelease];    
//    backgroundImageView.frame = CGRectMake(0, 0, 320, 460);
//    [self.view addSubview:backgroundImageView];
//
//    _emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 180, 300, 30)];
//    _emailAddressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _emailAddressTextField.placeholder = @"E-mail Address";
//    _emailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _emailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//    _emailAddressTextField.borderStyle = UITextBorderStyleNone;
//    _emailAddressTextField.font = [UIFont systemFontOfSize:14];
//    _emailAddressTextField.returnKeyType = UIReturnKeyDone;
//    _emailAddressTextField.delegate = self;
//    //_emailAddressTextField.text = @"maa@xmog.com";
//    [self.view addSubview:_emailAddressTextField];
//    
//    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, _emailAddressTextField.bottom + 35, 300, 30)];
//    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _passwordTextField.placeholder = @"Password";
//    _passwordTextField.borderStyle = UITextBorderStyleNone;
//    _passwordTextField.font = [UIFont systemFontOfSize:14];
//    _passwordTextField.returnKeyType = UIReturnKeyDone;
//    _passwordTextField.secureTextEntry = YES;
//    _passwordTextField.clearsOnBeginEditing = YES;
//    _passwordTextField.delegate = self;
//    //_passwordTextField.text = @"test123";    
//    [self.view addSubview:_passwordTextField];    
//    
//    _passwordConfirmTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, _passwordTextField.bottom + 35, 300, 30)];
//    _passwordConfirmTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _passwordConfirmTextField.placeholder = @"Password";
//    _passwordConfirmTextField.borderStyle = UITextBorderStyleNone;
//    _passwordConfirmTextField.font = [UIFont systemFontOfSize:14];
//    _passwordConfirmTextField.returnKeyType = UIReturnKeyDone;
//    _passwordConfirmTextField.secureTextEntry = YES;
//    _passwordConfirmTextField.clearsOnBeginEditing = YES;
//    _passwordConfirmTextField.delegate = self;
//    //_passwordTextField.text = @"test123";    
//    [self.view addSubview:_passwordConfirmTextField];     
    
    UIImage *cancelButtonImage = TTIMAGE(@"bundle://buttonBack.png");
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	[cancelButton addTarget:self
                     action:@selector(didTouchUpInCancelButton)
           forControlEvents:UIControlEventTouchUpInside];
	cancelButton.frame = CGRectMake(8, 390, 150, 50);
	[self.view addSubview:cancelButton];        
    
    UIImage *signUpButtonImage = TTIMAGE(@"bundle://buttonSignUpComplete.png");
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setImage:signUpButtonImage forState:UIControlStateNormal];    
	[signUpButton addTarget:self
                     action:@selector(didTouchUpInSignUpButton)
           forControlEvents:UIControlEventTouchUpInside];
	signUpButton.frame = CGRectMake(160, 390, 150, 50);
	[self.view addSubview:signUpButton];
    
//    _displayNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, _emailAddressTextField.top-35.0f, 300, 30)];
//    _displayNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _displayNameTextField.placeholder = @"Display Name";
//    _displayNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _displayNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//    _displayNameTextField.borderStyle = UITextBorderStyleBezel;
//    _displayNameTextField.backgroundColor = [UIColor whiteColor];
//    _displayNameTextField.font = [UIFont systemFontOfSize:14];
//    _displayNameTextField.returnKeyType = UIReturnKeyDone;
//    _displayNameTextField.delegate = self;
//    [self.view addSubview:_displayNameTextField];
}

- (void)viewDidUnload {
//    _emailAddressTextField.delegate = nil;
//    [_emailAddressTextField removeFromSuperview];
//    TT_RELEASE_SAFELY(_emailAddressTextField);
//    _passwordTextField.delegate = nil;
//    [_passwordTextField removeFromSuperview];
//    TT_RELEASE_SAFELY(_passwordTextField);    
//    _displayNameTextField.delegate = nil;
//    [_displayNameTextField removeFromSuperview];
//    TT_RELEASE_SAFELY(_displayNameTextField);
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
#pragma mark LavahoundSignUpApiDelegate

- (void)lavahoundSignUpApiDidSignUp:(LavahoundSignUpApi *)lavahoundSignInApi {
    [[TTURLCache sharedCache] removeAll:YES];    
    [self dismissModalViewControllerAnimated:NO];
    [[TTNavigator navigator] removeAllViewControllers]; 
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://tab-bar"] applyAnimated:YES]];
}

#pragma mark -
#pragma mark SignUpController

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = -130;
    
    for(UIView *subview in self.view.subviews)
        if([subview isKindOfClass:[UIButton class]])
            subview.alpha = 0;
        
    [UIView commitAnimations]; 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = 0;
    
    for(UIView *subview in self.view.subviews)
        if([subview isKindOfClass:[UIButton class]])
            subview.alpha = 1;
    
    [UIView commitAnimations];    
}

- (void)didTouchUpInSignUpButton
{
    NSString * FormattedDisplayName = nil;
    UIAlertView * NameError = nil;
    
    [_displayNameTextField resignFirstResponder];
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];  
    [_passwordConfirmTextField resignFirstResponder];      
    
    FormattedDisplayName = _displayNameTextField.text;
    
    if (FormattedDisplayName)
    {
        FormattedDisplayName = [FormattedDisplayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (FormattedDisplayName.length == 0)
        {
            FormattedDisplayName = nil;
        }
    }
    
    if (FormattedDisplayName)
    {
        LavahoundSignUpApi *lavahoundSignUpApi = [[[LavahoundSignUpApi alloc] init] autorelease];
        lavahoundSignUpApi.delegate = self;
        [lavahoundSignUpApi signUpWithDisplayName:FormattedDisplayName emailAddress:_emailAddressTextField.text password:_passwordTextField.text passwordConfirm:_passwordConfirmTextField.text];
    }
    else
    {
        NameError = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"no display name specified" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [NameError show];
        [NameError release];
        _displayNameTextField.text = nil;
    }
}

- (void)didTouchUpInCancelButton { 
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];  
    [_passwordConfirmTextField resignFirstResponder];      
    [self.navigationController popViewControllerAnimated:YES];
}

@end