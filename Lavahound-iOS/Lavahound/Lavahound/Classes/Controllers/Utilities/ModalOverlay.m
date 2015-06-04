//
//  ModalOverlay.m
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ModalOverlay.h"
#import <QuartzCore/QuartzCore.h>

static ModalOverlay *kSharedInstance = nil;

static NSTimeInterval const kFadeInAnimationDuration = 0.3;
static CGFloat const kOverlayAlpha = 0.5;

@implementation ModalOverlay

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _overlayView = nil;
        _messageView = nil;
    }
    
    return self;
}

// No dealloc since we're a singleton

#pragma mark -
#pragma mark ModalOverlay

+ (ModalOverlay *)sharedInstance {
	// Double-checked locking to avoid synchronization hit.
    // In the worst-case scenario we allocate/leak an extra instance or two...no big deal.	
	if(kSharedInstance)
		return kSharedInstance;
	
	@synchronized(self)	{
		kSharedInstance = [[ModalOverlay alloc] init];
	}
	
	return kSharedInstance;    
}

- (void)showWithMessage:(NSString *)message {
    [self hide];
    
    UIWindow *applicationWindow = [UIApplication sharedApplication].keyWindow;
    
    _overlayView = [[UIView alloc] initWithFrame:applicationWindow.bounds];
    _overlayView.alpha = 0;
    _overlayView.backgroundColor = [UIColor blackColor];
    [applicationWindow addSubview:_overlayView];
    
    _messageView = [[UIView alloc] initWithFrame:CGRectMake(30, 120, 260, 180)];
    _messageView.backgroundColor = [UIColor whiteColor];
    _messageView.layer.cornerRadius = 8;        
    _messageView.layer.masksToBounds = YES;
    _messageView.alpha = 0;        
    [applicationWindow addSubview:_messageView]; 
    
    if(!message)
        message = @"Please wait...";
    
    UILabel *messageLabel = [[[UILabel alloc] initWithFrame:_messageView.bounds] autorelease];
    messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    messageLabel.numberOfLines = 0;
    messageLabel.text = message;
    messageLabel.textAlignment = UITextAlignmentCenter;
    messageLabel.contentMode = UIViewContentModeCenter;
    [_messageView addSubview:messageLabel];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kFadeInAnimationDuration];    
    _overlayView.alpha = kOverlayAlpha;
    _messageView.alpha = 1;    
    [UIView commitAnimations]; 
}

- (void)hide {
    [_overlayView removeFromSuperview];
    TT_RELEASE_SAFELY(_overlayView);
    [_messageView removeFromSuperview];    
    TT_RELEASE_SAFELY(_messageView);    
}

@end