//
//  TermsAndConditionsController.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TermsAndConditionsController.h"
#import "UIViewController+Lavahound.h"
#import "Constants.h"

@implementation TermsAndConditionsController

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    [self setTitleWithLavahoundFont:@"terms"];
}

#pragma mark -
#pragma mark WebViewController

- (NSString *)pageUrl {
    return [Constants sharedInstance].termsAndConditionsPageUrl;
}

@end