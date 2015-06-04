//
//  WebViewController.m
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "WebViewController.h"
#import "UIViewController+Lavahound.h"

@implementation WebViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _webView = nil;
        [self initializeLavahoundNavigationBarWithTitle:@"loading..."];
    }
    
    return self;
}

- (void)dealloc {
    _webView.delegate = nil;
    TT_RELEASE_SAFELY(_webView);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.frame = self.view.bounds;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageUrl]]];    
    [self.view addSubview:_webView];
}

- (void)viewDidUnload {
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    TT_RELEASE_SAFELY(_webView);
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == NSURLErrorCancelled) {
        TTDPRINT(@"Caught spurious -999 error, loading anyway.");
        [self webViewDidFinishLoad:webView];
        return;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setTitleWithLavahoundFont:@"Error"];
}

#pragma mark -
#pragma mark UIWebViewDelegate
     
- (NSString *)pageUrl {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
     
@end