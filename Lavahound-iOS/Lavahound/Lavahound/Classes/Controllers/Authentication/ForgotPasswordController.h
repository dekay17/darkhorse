//
//  ForgotPasswordController.h
//  Lavahound
//
//  Created by Mark Allen on 6/8/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundForgotPasswordApi.h"

@interface ForgotPasswordController : TTViewController<UITextFieldDelegate, LavahoundForgotPasswordApiDelegate> {
    UITextField *_emailAddressTextField;
}

@end