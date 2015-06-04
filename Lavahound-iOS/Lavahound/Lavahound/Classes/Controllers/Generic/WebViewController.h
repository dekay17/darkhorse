//
//  WebViewController.h
//  Lavahound
//
//  Created by Mark Allen on 5/16/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface WebViewController : TTViewController<UIWebViewDelegate> {
    UIWebView *_webView;
}

@property(nonatomic, readonly) NSString *pageUrl;

@end