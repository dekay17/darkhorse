//
//  LoadingAwareImageView.h
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify, LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface LoadingAwareImageView : UIView<TTImageViewDelegate> {
    TTImageView *_imageView;
	UIActivityIndicatorView *_activityIndicatorView;
}

- (id)initWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode;

@property (nonatomic, copy) NSString *imageUrl;

@end