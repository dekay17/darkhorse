//
//  LoadingAwareImageView.h
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify, LLC. All rights reserved.
//

#import "LoadingAwareImageView.h"

@implementation LoadingAwareImageView

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame contentMode:UIViewContentModeCenter];
}

- (id)initWithFrame:(CGRect)frame contentMode:(UIViewContentMode)contentMode {
	if((self = [super initWithFrame:frame])) {	
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[TTImageView alloc] init];    
        _imageView.contentMode = contentMode;
        _imageView.defaultImage = TTIMAGE(@"bundle://default-image.png");  
        _imageView.clipsToBounds = YES;
        _imageView.delegate = self;
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.hidesWhenStopped = YES;
        _activityIndicatorView.contentMode = UIViewContentModeCenter;

        [self addSubview:_activityIndicatorView];
        [self addSubview:_imageView];
    }
	
	return self;
}

- (void)dealloc { 
	_imageView.delegate = nil;	
	TT_RELEASE_SAFELY(_imageView);
	TT_RELEASE_SAFELY(_activityIndicatorView);  
	[super dealloc];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
	_activityIndicatorView.frame = CGRectMake(0, 0, self.width, self.height);
	_imageView.frame = _activityIndicatorView.frame;
}

#pragma mark -
#pragma mark TTImageViewDelegate

- (void)imageViewDidStartLoad:(TTImageView *)imageView {
	_imageView.alpha = 0;
	_activityIndicatorView.hidden = NO;
	[_activityIndicatorView startAnimating];
}

- (void)imageView:(TTImageView *)imageView didLoadImage:(UIImage *)image {
	// This means we were loaded from cache, since imageViewDidStartLoad: was never called.
	// Bail right away since the loading indicator was never shown in the first place.
	if(_activityIndicatorView.hidden)
		return;
	
	[_activityIndicatorView stopAnimating];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	_imageView.alpha = 1;	
	[UIView commitAnimations]; 		
}

- (void)imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error {
	[_activityIndicatorView stopAnimating];	
	_imageView.alpha = 1;
}

#pragma mark -
#pragma mark LoadingAwareImageView

- (void)setImageUrl:(NSString *)imageUrl {
  _imageView.urlPath = imageUrl;
}

- (NSString *)imageUrl {
  return _imageView.urlPath;
}

@end