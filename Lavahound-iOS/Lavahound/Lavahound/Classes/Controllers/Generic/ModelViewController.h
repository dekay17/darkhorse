//
//  ModelViewController.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface ModelViewController : TTModelViewController {
    UIView *_loadingView;
    UIView *_errorView;
    UILabel *_errorLabel;    
    UIView *_emptyView;    
    UIView *_modelView;
}

- (void)setTitleAndKeepCurrentTabBarItemTitle:(NSString *)title;

@end