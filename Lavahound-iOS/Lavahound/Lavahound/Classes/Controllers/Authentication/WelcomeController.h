//
//  WelcomeController.h
//  Lavahound
//
//  Created by Mark Allen on 6/6/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LavahoundPlayNowApi.h"
#import "LavahoundFacebook.h"
#import "LavahoundSignInApi.h"

@interface WelcomeController : TTViewController<LavahoundPlayNowApiDelegate, LavahoundFacebookDelegate, LavahoundSignInApiDelegate>
@end