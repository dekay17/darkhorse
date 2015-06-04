//
//  ChangePasswordController.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ChangePasswordController.h"
#import "UIViewController+Lavahound.h"

static NSTimeInterval const kKeyboardAnimationDuration = 0.3;

@implementation ChangePasswordController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _oldPasswordTextField = nil;
        _passwordTextField = nil;
        _confirmPasswordTextField = nil;
        [self initializeLavahoundNavigationBarWithTitle:@"password"]; 
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];           
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];           
    _oldPasswordTextField.delegate = nil;
    TT_RELEASE_SAFELY(_oldPasswordTextField);  
    _passwordTextField.delegate = nil;
    TT_RELEASE_SAFELY(_passwordTextField);  
    _confirmPasswordTextField.delegate = nil;
    TT_RELEASE_SAFELY(_confirmPasswordTextField);  
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://changePasswordPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];       
    
    _oldPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 42, 290, 30)];
    _oldPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _oldPasswordTextField.borderStyle = UITextBorderStyleNone;
    _oldPasswordTextField.font = [UIFont systemFontOfSize:14];
    _oldPasswordTextField.returnKeyType = UIReturnKeyDone;
    _oldPasswordTextField.secureTextEntry = YES;
    _oldPasswordTextField.clearsOnBeginEditing = YES;
    _oldPasswordTextField.delegate = self;
    [self.view addSubview:_oldPasswordTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 110, 290, 30)];
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearsOnBeginEditing = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    
    _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 178, 290, 30)];
    _confirmPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPasswordTextField.borderStyle = UITextBorderStyleNone;
    _confirmPasswordTextField.font = [UIFont systemFontOfSize:14];
    _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.clearsOnBeginEditing = YES;
    _confirmPasswordTextField.delegate = self;
    [self.view addSubview:_confirmPasswordTextField];    
    
    UIImage *savePasswordButtonImage = TTIMAGE(@"bundle://buttonSavePassword.png");    
    UIButton *savePasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
	[savePasswordButton setImage:savePasswordButtonImage forState:UIControlStateNormal];
	[savePasswordButton addTarget:self
                           action:@selector(didTouchUpInSavePasswordButton)
                 forControlEvents:UIControlEventTouchUpInside];
	savePasswordButton.frame = CGRectMake(10, 248, savePasswordButtonImage.size.width, savePasswordButtonImage.size.height);
	[self.view addSubview:savePasswordButton];
}

- (void)viewDidUnload {
    _oldPasswordTextField.delegate = nil;
    [_oldPasswordTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_oldPasswordTextField);  
    _passwordTextField.delegate = nil;
    [_passwordTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_passwordTextField);  
    _confirmPasswordTextField.delegate = nil;
    [_confirmPasswordTextField removeFromSuperview];
    TT_RELEASE_SAFELY(_confirmPasswordTextField);      
    [super viewDidUnload];    
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}   

#pragma mark -
#pragma mark LavahoundChangePasswordApiDelegate

- (void)lavahoundChangePasswordApiDidChangePassword:(LavahoundChangePasswordApi *)lavahoundChangePasswordApi {
    [self.navigationController popViewControllerAnimated:YES];
    TTAlert(@"Your password has been updated.");
}

#pragma mark -
#pragma mark ChangePasswordController

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = -14;
    [UIView commitAnimations]; 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = 0;
    [UIView commitAnimations];    
}

- (void)didTouchUpInSavePasswordButton {
    [_passwordTextField resignFirstResponder];
    [_confirmPasswordTextField resignFirstResponder];
    [_oldPasswordTextField resignFirstResponder];
    
    LavahoundChangePasswordApi *lavahoundChangePasswordApi = [[[LavahoundChangePasswordApi alloc] init] autorelease];
    lavahoundChangePasswordApi.delegate = self;
    [lavahoundChangePasswordApi changePassword:_passwordTextField.text
                               confirmPassword:_confirmPasswordTextField.text
                                   oldPassword:_oldPasswordTextField.text];
}

@end