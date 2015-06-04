//
//  SignUpController.h
//  Lavahound
//
//  Created by Mark Allen on 5/9/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundSignUpApi.h"

@interface SignUpController : TTViewController<UITextFieldDelegate, LavahoundSignUpApiDelegate> {
    IBOutlet UITextField *_displayNameTextField;
    IBOutlet UITextField *_emailAddressTextField;
	IBOutlet UITextField *_passwordTextField;
	IBOutlet UITextField *_passwordConfirmTextField;
}

@end
