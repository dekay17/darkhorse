//
//  PrivacyPolicyController.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PrivacyPolicyController.h"
#import "UIViewController+Lavahound.h"
#import "Constants.h"

@implementation PrivacyPolicyController

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    [self setTitleWithLavahoundFont:@"privacy policy"];
}

#pragma mark -
#pragma mark WebViewController

- (NSString *)pageUrl {
    return [Constants sharedInstance].privacyPolicyPageUrl;
}

@end