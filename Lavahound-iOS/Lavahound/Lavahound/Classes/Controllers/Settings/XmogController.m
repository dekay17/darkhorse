//
//  XmogController.m
//  Lavahound
//
//  Created by Dan Kelley on 5/27/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//
#import "XmogController.h"
#import "UIViewController+Lavahound.h"
#import "Constants.h"

@implementation XmogController

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [super webViewDidFinishLoad:webView];
    [self setTitleWithLavahoundFont:@"Xmog"];
}

#pragma mark -
#pragma mark WebViewController

- (NSString *)pageUrl {
    return [Constants sharedInstance].xmogHomePageUrl;
}

@end