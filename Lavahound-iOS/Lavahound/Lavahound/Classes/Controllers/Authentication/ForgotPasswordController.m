//
//  ForgotPasswordController.m
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ForgotPasswordController.h"

static NSTimeInterval const kKeyboardAnimationDuration = 0.3;

@implementation ForgotPasswordController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _emailAddressTextField = nil;       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];        
    }
    
    return self;
}

- (void)dealloc { 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _emailAddressTextField.delegate = nil;
    TT_RELEASE_SAFELY(_emailAddressTextField);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://forgotPasswordPageBG.png")] autorelease];
    [self.view addSubview:backgroundImageView];    
    
    _emailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 272, 290, 30)];
    _emailAddressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailAddressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailAddressTextField.borderStyle = UITextBorderStyleNone;
    _emailAddressTextField.font = [UIFont systemFontOfSize:14];
    _emailAddressTextField.returnKeyType = UIReturnKeyDone;
    _emailAddressTextField.delegate = self;
    [self.view addSubview:_emailAddressTextField];    

    UIImage *cancelButtonImage = TTIMAGE(@"bundle://buttonBack.png");
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    [cancelButton setImage:cancelButtonImage forState:UIControlStateNormal];
	[cancelButton addTarget:self
                     action:@selector(didTouchUpInCancelButton)
           forControlEvents:UIControlEventTouchUpInside];
	cancelButton.frame = CGRectMake(10, 320, cancelButtonImage.size.width, cancelButtonImage.size.height);
	[self.view addSubview:cancelButton];      
    
    UIImage *sendEmailButtonImage = TTIMAGE(@"bundle://buttonSendPassword.png");
    UIButton *sendEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    [sendEmailButton setImage:sendEmailButtonImage forState:UIControlStateNormal];
	[sendEmailButton addTarget:self
                        action:@selector(didTouchUpInSendEmailButton)
              forControlEvents:UIControlEventTouchUpInside];
	sendEmailButton.frame = CGRectMake(cancelButton.right + 10, 320, sendEmailButtonImage.size.width, sendEmailButtonImage.size.height);
	[self.view addSubview:sendEmailButton];      
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {    
    _emailAddressTextField.delegate = nil;
    [_emailAddressTextField removeFromSuperview];    
    TT_RELEASE_SAFELY(_emailAddressTextField);
    [super viewDidUnload];        
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}  

#pragma mark -
#pragma mark LavahoundForgotPasswordApiDelegate

- (void)lavahoundForgotPasswordApiDidResetPassword:(LavahoundForgotPasswordApi *)lavahoundForgotPasswordApi {
    [self.navigationController popViewControllerAnimated:YES];    
    TTAlert(@"A new password has been emailed to you.");    
}

#pragma mark -
#pragma mark ForgotPasswordController

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = -150;
    [UIView commitAnimations]; 
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kKeyboardAnimationDuration];    
    self.view.top = 0;
    [UIView commitAnimations];    
}

- (void)didTouchUpInSendEmailButton {
    [_emailAddressTextField resignFirstResponder];    
    LavahoundForgotPasswordApi *lavahoundForgotPasswordApi = [[[LavahoundForgotPasswordApi alloc] init] autorelease];
    lavahoundForgotPasswordApi.delegate = self;
    [lavahoundForgotPasswordApi resetPasswordForEmailAddress:_emailAddressTextField.text];
}

- (void)didTouchUpInCancelButton {
    [_emailAddressTextField resignFirstResponder];        
    [self.navigationController popViewControllerAnimated:YES];
}

@end