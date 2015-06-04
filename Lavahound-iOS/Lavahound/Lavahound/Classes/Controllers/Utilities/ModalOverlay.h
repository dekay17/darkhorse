//
//  ModalOverlay.h
//  Lavahound
//
//  Created by Mark Allen on 5/10/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "UnreleasableObject.h"

@interface ModalOverlay : UnreleasableObject {
    UIView *_overlayView;
    UIView *_messageView;
}

+ (ModalOverlay *)sharedInstance;

- (void)showWithMessage:(NSString *)message;
- (void)hide;

@end