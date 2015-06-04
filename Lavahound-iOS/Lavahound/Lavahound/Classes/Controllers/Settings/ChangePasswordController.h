//
//  ChangePasswordController.h
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundChangePasswordApi.h"

@interface ChangePasswordController : TTViewController<UITextFieldDelegate, LavahoundChangePasswordApiDelegate> {
    UITextField *_oldPasswordTextField;
	UITextField *_passwordTextField;
	UITextField *_confirmPasswordTextField;    
}

@end