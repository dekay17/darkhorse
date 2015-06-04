//
//  SignInController.h
//  Lavahound
//
//  Created by Mark Allen on 4/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundSignInApi.h"

@interface SignInController : TTViewController<UITextFieldDelegate, LavahoundSignInApiDelegate> {
    UITextField *_emailAddressTextField;
	UITextField *_passwordTextField;
}

@end