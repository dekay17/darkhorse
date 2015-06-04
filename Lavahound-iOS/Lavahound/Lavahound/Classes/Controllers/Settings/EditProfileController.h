//
//  EditProfileController.h
//  Lavahound
//
//  Created by Mark Allen on 5/17/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"
#import "LavahoundFacebook.h"
#import "LavahoundEditProfileApi.h"

@interface EditProfileController : ModelViewController<UITextFieldDelegate, LavahoundEditProfileApiDelegate, LavahoundFacebookDelegate> {
    UITextField *_displayNameTextField;
    UITextField *_emailAddressTextField;    
    UIButton *_facebookButton;    
}

@end