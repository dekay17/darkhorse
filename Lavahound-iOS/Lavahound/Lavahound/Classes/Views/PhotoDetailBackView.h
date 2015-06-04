//
//  PhotoDetailBackView.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LoadingAwareImageView.h"
#import "PhotoView.h"

@protocol PhotoDetailBackViewDelegate;

@interface PhotoDetailBackView : PhotoView {
    UIScrollView *_scrollView;
    UILabel *_pointsDescriptionLabel;
    UILabel *_pointsLabel;
    UILabel *_timesFoundDescriptionLabel;
    UILabel *_timesFoundLabel;      
    UILabel *_submittedByDescriptionLabel;
    UILabel *_submittedByLabel;
    LoadingAwareImageView *_submittedByImageView;
    LoadingAwareImageView *_photoImageView;    
    UILabel *_submittedOnLabel;    
    UILabel *_shotInformationDescriptionLabel;
    UILabel *_shotInformationLabel;       
    UIButton *_flagButton;
    UIButton *_shareButton;
    UIImageView *_submittedByBackgroundImageView;
    UIImageView *_actionsBackgroundImageView;    
    UIImageView *_boxesBackgroundImageView;        
    
    id<PhotoDetailBackViewDelegate> _delegate;
}

@property(nonatomic, assign) id<PhotoDetailBackViewDelegate> delegate;

@end


@protocol PhotoDetailBackViewDelegate<NSObject>

- (void)photoDetailBackViewDidTouchUpInShareButton:(PhotoDetailBackView *)photoDetailBackViewDelegate;
- (void)photoDetailBackViewDidTouchUpInFlagButton:(PhotoDetailBackView *)photoDetailBackViewDelegate;

@end