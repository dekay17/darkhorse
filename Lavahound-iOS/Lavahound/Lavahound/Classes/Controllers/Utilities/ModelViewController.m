//
//  ModelViewController.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ModelViewController.h"

@implementation ModelViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _loadingView = nil;
        _errorView = nil;
        _emptyView = nil;
        _modelView = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_loadingView);
    TT_RELEASE_SAFELY(_errorView);
    TT_RELEASE_SAFELY(_emptyView);
    TT_RELEASE_SAFELY(_modelView);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: these should be created on-demand in showError:, showLoading:, etc.
    // But it's simpler to just make them now and keep them hidden.
    
    TTActivityLabel *loadingActivityLabel = [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleGray];
    loadingActivityLabel.frame = self.view.bounds;
    loadingActivityLabel.hidden = YES;
    loadingActivityLabel.text = @"Loading...";
    loadingActivityLabel.contentMode = UIViewContentModeCenter;
    loadingActivityLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _loadingView = loadingActivityLabel;
	[self.view addSubview:_loadingView];   
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    errorLabel.hidden = YES;
    errorLabel.textAlignment = UITextAlignmentCenter;
    errorLabel.text = @"Sorry, an error occurred.";
    errorLabel.numberOfLines = 0;
    errorLabel.contentMode = UIViewContentModeCenter;
    errorLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _errorView = errorLabel;
	[self.view addSubview:_errorView];    
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    emptyLabel.hidden = YES;
    emptyLabel.textAlignment = UITextAlignmentCenter;
    emptyLabel.text = @"Sorry, no data was found.";
    emptyLabel.numberOfLines = 0;
    emptyLabel.contentMode = UIViewContentModeCenter;
    emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _emptyView = emptyLabel;
	[self.view addSubview:_emptyView];
    
    _modelView = [[UIView alloc] initWithFrame:self.view.bounds];
    _modelView.hidden = YES;    
    _modelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;        
    [self.view addSubview:_modelView];
}

- (void)viewDidUnload {
    [_loadingView removeFromSuperview];
    TT_RELEASE_SAFELY(_loadingView);
    [_errorView removeFromSuperview];
    TT_RELEASE_SAFELY(_errorView);
    [_emptyView removeFromSuperview];
    TT_RELEASE_SAFELY(_emptyView);    
    [_modelView removeFromSuperview];    
    TT_RELEASE_SAFELY(_modelView);        
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)showError:(BOOL)show {
    if(show) {
        [self.view bringSubviewToFront:_errorView];        
        _errorView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
}

- (void)showLoading:(BOOL)show {
    if(show) {
        [self.view bringSubviewToFront:_loadingView];        
        _loadingView.hidden = NO;
    } else {
        _loadingView.hidden = YES;
    }
}

- (void)showEmpty:(BOOL)show {
    if(show) {
        [self.view bringSubviewToFront:_emptyView];        
        _emptyView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
}

- (void)showModel:(BOOL)show {
    if(show) {
        [self.view bringSubviewToFront:_modelView];        
        _modelView.hidden = NO;
    } else {
        _modelView.hidden = YES;
    }
}

@end