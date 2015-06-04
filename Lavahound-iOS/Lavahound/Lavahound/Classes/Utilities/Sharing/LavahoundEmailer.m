//
//  LavahoundEmailer.m
//  Lavahound
//
//  Created by Mark Allen on 5/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "LavahoundEmailer.h"
#import "Three20/Three20+Additions.h"
#import "Constants.h"
#import "UIViewController+Lavahound.h"

static LavahoundEmailer *kSharedInstance = nil;

@interface LavahoundEmailer(PrivateMethods)

- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body to:(NSArray *)to;

@end

@implementation LavahoundEmailer

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate 

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[[[TTNavigator navigator] visibleViewController] dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark LavahoundEmailer

+ (LavahoundEmailer *)sharedInstance {
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[LavahoundEmailer alloc] init];
	}
	
	return kSharedInstance;
}

- (void)emailPhoto:(Photo *)photo {
    NSString *subject = @"Check out lavahound";
    NSString *body = [NSString stringWithFormat:@"<b>Check this pic out!</b><br/><br/><img src='%@'/><br/>Stop doggin’ it – you can go out and find it on <a href='%@/itunes-link'>Lavahound</a><br/><br/>Definitely return the favor – challenge me to sniff out a pic that you took or at least share something cool!!<br/><br/>Thanks!!", photo.imageUrl, [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix ];    
    [self sendEmailWithSubject:subject body:body to:nil];
}

- (void)emailContactUs {
    NSArray *to = [NSArray arrayWithObject:@"info@lavahound.com"];
    NSString *subject = @"Contact Us!";
    NSString *body = @"Dear Mr. Hound<br/>I have a question about....";
    [self sendEmailWithSubject:subject body:body to:to];
}

- (void)sendEmailWithSubject:(NSString *)subject body:(NSString *)body to:(NSArray *)to{
	MFMailComposeViewController *mailComposeController = [[[MFMailComposeViewController alloc] init] autorelease];	
    mailComposeController.navigationBar.tintColor = RGBCOLOR(173, 41, 0);
	mailComposeController.mailComposeDelegate = self;
	[mailComposeController setSubject:subject];
    [mailComposeController setToRecipients:to];
	[mailComposeController setMessageBody:body isHTML:YES];
    
    // TODO: Unfortunately this isn't working, so we're stuck with the generic font.
    // Might need to subclass MFMailComposeViewController to get the behavior we want.
    [mailComposeController setTitleWithLavahoundFont:subject];
	
	if(mailComposeController)		
        [[[TTNavigator navigator] visibleViewController] presentModalViewController:mailComposeController animated:YES];
    else
        TTAlert(@"Sorry, it looks like you don't have an email account set up on this device.");
}

@end