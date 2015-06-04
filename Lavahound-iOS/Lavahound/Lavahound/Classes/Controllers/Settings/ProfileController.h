//
//  ProfileController.h
//  Lavahound
//
//  Created by Mark Allen on 7/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"
#import "LoadingAwareImageView.h"
#import "LavahoundEditProfileApi.h"
#import "LavahoundChangePasswordApi.h"
#import "LocalStorage.h"

@interface ProfileController : ModelViewController <UITextFieldDelegate, LavahoundEditProfileApiDelegate, LavahoundChangePasswordApiDelegate>
{
    UILabel *_photosHiddenLabel;      
    UILabel *_timesFoundLabel;      
    UILabel *_rankLabel;
    UILabel *_displayNameLabel;    
    UILabel *_emailAddressLabel;    
    LoadingAwareImageView *_userImageView;    
    
    IBOutlet UIView         * ContentContainer;
    IBOutlet UIView         * ContentLavaUser;
    IBOutlet UIView         * ContentFacebookUser;
    IBOutlet UIImageView    * UserPhoto;
    IBOutlet UITextField    * EmailAddress;
    IBOutlet UITextField    * DisplayName;
    IBOutlet UITextField    * OldPassword;
    IBOutlet UITextField    * NewPassword;
    IBOutlet UITextField    * NewPasswordConfirm;
    IBOutlet UITextField    * FacebookDisplayName;
}

- (IBAction) EventUpdateEmailAndDisplayName;
- (IBAction) EventUpdateAccountPassword;
- (IBAction) EventUpdateFacebookDisplayName;

@end