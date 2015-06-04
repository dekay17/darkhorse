//
//  LavahoundEmailer.h
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "UnreleasableObject.h"
#import "Photo.h"
#import "Constants.h"

@interface LavahoundEmailer : UnreleasableObject<MFMailComposeViewControllerDelegate> {}

+ (LavahoundEmailer *)sharedInstance;

- (void)emailPhoto:(Photo *)photo;
- (void)emailContactUs;

@end