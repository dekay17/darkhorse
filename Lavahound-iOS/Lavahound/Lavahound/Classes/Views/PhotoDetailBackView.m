//
//  PhotoDetailBackView.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoDetailBackView.h"

@implementation PhotoDetailBackView

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {                            
        UIImageView *backgroundPhotoBackView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://flippedPhotoBG.png")] autorelease];
        [self addSubview:backgroundPhotoBackView];           
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];        
        [self addSubview:_scrollView];
        
        UIImage *boxesBackgroundImage = TTIMAGE(@"bundle://flippedPhotoBoxesBG.png");        
        _boxesBackgroundImageView = [[UIImageView alloc] initWithImage:boxesBackgroundImage];
        _boxesBackgroundImageView.frame = CGRectMake(0, 0, boxesBackgroundImage.size.width, boxesBackgroundImage.size.height);
        [_scrollView addSubview:_boxesBackgroundImageView]; 
        
        UIImage *submittedByBackgroundImage = TTIMAGE(@"bundle://flippedPhotoSubmittedBG.png");        
        _submittedByBackgroundImageView = [[UIImageView alloc] initWithImage:submittedByBackgroundImage];
        _submittedByBackgroundImageView.frame = CGRectMake(0, 0, submittedByBackgroundImage.size.width, submittedByBackgroundImage.size.height);
        [_scrollView addSubview:_submittedByBackgroundImageView];           
        
        UIImage *actionsBackgroundImage = TTIMAGE(@"bundle://flippedPhotoActionsBG.png");                
        _actionsBackgroundImageView = [[UIImageView alloc] initWithImage:actionsBackgroundImage];
        _actionsBackgroundImageView.frame = CGRectMake(0, 0, actionsBackgroundImage.size.width, actionsBackgroundImage.size.height);
        _actionsBackgroundImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_actionsBackgroundImageView];        
        
        _photoImageView = [[LoadingAwareImageView alloc] initWithFrame:CGRectZero contentMode:UIViewContentModeScaleAspectFit];
        [_scrollView addSubview:_photoImageView];              
        
        _pointsDescriptionLabel = [[UILabel alloc] init];        
        _pointsDescriptionLabel.text = @"Point Value";
        _pointsDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _pointsDescriptionLabel.textColor = RGBCOLOR(50, 50, 50);
        _pointsDescriptionLabel.textAlignment = UITextAlignmentCenter;         
        [_scrollView addSubview:_pointsDescriptionLabel];        
        
        _pointsLabel = [[UILabel alloc] init];        
        _pointsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        _pointsLabel.textColor = RGBCOLOR(50, 50, 50);
        _pointsLabel.textAlignment = UITextAlignmentCenter;        
        [_scrollView addSubview:_pointsLabel];          
        
        _timesFoundDescriptionLabel = [[UILabel alloc] init];        
        _timesFoundDescriptionLabel.text = @"Times Found";
        _timesFoundDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _timesFoundDescriptionLabel.textColor = RGBCOLOR(50, 50, 50);
        _timesFoundDescriptionLabel.textAlignment = UITextAlignmentCenter;   
        _timesFoundDescriptionLabel.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_timesFoundDescriptionLabel];     
        
        _timesFoundLabel = [[UILabel alloc] init];        
        _timesFoundLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        _timesFoundLabel.textColor = RGBCOLOR(50, 50, 50);
        _timesFoundLabel.textAlignment = UITextAlignmentCenter;   
        _timesFoundLabel.backgroundColor = [UIColor clearColor];        
        [_scrollView addSubview:_timesFoundLabel];        
        
        _submittedByDescriptionLabel = [[UILabel alloc] init];        
        _submittedByDescriptionLabel.text = @"Submitted By";
        _submittedByDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        _submittedByDescriptionLabel.textColor = RGBCOLOR(50, 50, 50);
        _submittedByDescriptionLabel.backgroundColor = [UIColor clearColor];        
        [_scrollView addSubview:_submittedByDescriptionLabel];
        
        _submittedByLabel = [[UILabel alloc] init];
        _submittedByLabel.contentMode = UIViewContentModeCenter;
        _submittedByLabel.textColor = RGBCOLOR(50, 50, 50);
        [_submittedByBackgroundImageView addSubview:_submittedByLabel];
        
        _submittedByImageView = [[LoadingAwareImageView alloc] initWithFrame:CGRectZero contentMode:UIViewContentModeScaleAspectFit];
        [_submittedByBackgroundImageView addSubview:_submittedByImageView];        
        
        _submittedOnLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 14, 160, 18)];
        _submittedOnLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];        
        _submittedOnLabel.textColor = RGBCOLOR(50, 50, 50);
        _submittedOnLabel.backgroundColor = [UIColor clearColor];        
        [_scrollView addSubview:_submittedOnLabel];            

        _shotInformationDescriptionLabel = [[UILabel alloc] init];
        _shotInformationDescriptionLabel.textColor = RGBCOLOR(50, 50, 50);
        _shotInformationDescriptionLabel.backgroundColor = [UIColor clearColor];        
        _shotInformationDescriptionLabel.text = @"Shot Information";
        _shotInformationDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];        
        [_scrollView addSubview:_shotInformationDescriptionLabel];      
        
        _shotInformationLabel = [[UILabel alloc] init];
        _shotInformationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16]; 
        _shotInformationLabel.numberOfLines = 0;
        _shotInformationLabel.textColor = RGBCOLOR(50, 50, 50);
        _shotInformationLabel.backgroundColor = [UIColor clearColor];
        _shotInformationLabel.lineBreakMode = UILineBreakModeWordWrap;        
        [_scrollView addSubview:_shotInformationLabel];       
        
        // Flag and share buttons should be subviews of _actionsBackgroundImageView
        // but if they are they are no longer clickable.
        // TODO: figure out why, for now we just have them as subviews of _scrollView as a workaround.
        
        UIImage *flagButtonImage = TTIMAGE(@"bundle://buttonFlagImage.png");
        _flagButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
        [_flagButton setImage:flagButtonImage forState:UIControlStateNormal];        
        [_flagButton addTarget:self
                        action:@selector(didTouchUpInFlagButton)
              forControlEvents:UIControlEventTouchUpInside];
        _flagButton.frame = CGRectMake(0, 0, flagButtonImage.size.width, flagButtonImage.size.height);
        [_scrollView addSubview:_flagButton];     

        UIImage *shareButtonImage = TTIMAGE(@"bundle://buttonShareImage.png");        
        _shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
        [_shareButton setImage:shareButtonImage forState:UIControlStateNormal];        
        [_shareButton addTarget:self
                         action:@selector(didTouchUpInShareButton)
               forControlEvents:UIControlEventTouchUpInside];
        _shareButton.frame = CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height);
        [_scrollView addSubview:_shareButton];           
    }
	
	return self;
}



- (void)dealloc {
    TT_RELEASE_SAFELY(_scrollView);
    TT_RELEASE_SAFELY(_photoImageView);
    TT_RELEASE_SAFELY(_pointsDescriptionLabel); 
    TT_RELEASE_SAFELY(_pointsLabel);
    TT_RELEASE_SAFELY(_timesFoundDescriptionLabel);
    TT_RELEASE_SAFELY(_timesFoundLabel);    
    TT_RELEASE_SAFELY(_submittedByDescriptionLabel);
    TT_RELEASE_SAFELY(_submittedByLabel);
    TT_RELEASE_SAFELY(_submittedByImageView);
    TT_RELEASE_SAFELY(_submittedOnLabel);
    TT_RELEASE_SAFELY(_shotInformationDescriptionLabel);
    TT_RELEASE_SAFELY(_shotInformationLabel);  
    TT_RELEASE_SAFELY(_flagButton);  
    TT_RELEASE_SAFELY(_shareButton);      
    TT_RELEASE_SAFELY(_submittedByBackgroundImageView);
    TT_RELEASE_SAFELY(_actionsBackgroundImageView);  
    TT_RELEASE_SAFELY(_boxesBackgroundImageView);
	[super dealloc];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Very slow if done in here.  Set the bounds instead in setPhoto:
    //_scrollView.frame = self.bounds;    
    
    _boxesBackgroundImageView.frame = CGRectMake(10, 10, _boxesBackgroundImageView.width, _boxesBackgroundImageView.height);
    
    _photoImageView.frame = CGRectMake(12, 12, 79, 79);
    _pointsLabel.frame = CGRectMake(108, 44, 86, 27);
    _pointsDescriptionLabel.frame = CGRectMake(_pointsLabel.left, _pointsLabel.bottom, _pointsLabel.width, 14);
    _timesFoundLabel.frame = CGRectMake(_pointsLabel.right + 9, _pointsLabel.top, _pointsLabel.width, _pointsLabel.height); 
    _timesFoundDescriptionLabel.frame = CGRectMake(_timesFoundLabel.left, _timesFoundLabel.bottom, _timesFoundLabel.width, 14);    
    
    //_submittedOnLabel.frame = CGRectMake(110, 14, 160, 18);        
    
    _shotInformationDescriptionLabel.frame = CGRectMake(10, _boxesBackgroundImageView.bottom + 12, 300, 18);
    CGSize shotInformationLabelSize = !_shotInformationLabel.text || [@"" isEqualToString:_shotInformationLabel.text] ? CGSizeMake(0, 0) :
    [_shotInformationLabel.text sizeWithFont:_shotInformationLabel.font
                                                                 constrainedToSize:CGSizeMake(300, 700) 
                                                                                              lineBreakMode:_shotInformationLabel.lineBreakMode];     

    _shotInformationLabel.frame = CGRectMake(10, _shotInformationDescriptionLabel.bottom + 6, 300, shotInformationLabelSize.height);        

    _submittedByDescriptionLabel.frame = CGRectMake(10, (_shotInformationDescriptionLabel.hidden ? _boxesBackgroundImageView.bottom : _shotInformationLabel.bottom) + 10, 300, 18);    
    
    _submittedByBackgroundImageView.frame = CGRectMake(10, _submittedByDescriptionLabel.bottom + 8, _submittedByBackgroundImageView.width, _submittedByBackgroundImageView.height);
    
    _submittedByImageView.frame = CGRectMake(8, 8, 48, 48);
    _submittedByLabel.frame = CGRectMake(_submittedByImageView.right + 10, _submittedByImageView.top, 200, _submittedByImageView.height);    
    
    _actionsBackgroundImageView.frame = CGRectMake(10, _submittedByBackgroundImageView.bottom + 8, _actionsBackgroundImageView.width, _actionsBackgroundImageView.height);    
    
    _flagButton.frame = CGRectMake(_actionsBackgroundImageView.left + 8, _actionsBackgroundImageView.top + 8, _flagButton.width, _flagButton.height);
    _shareButton.frame = CGRectMake(_flagButton.right + 4, _flagButton.top, _shareButton.width, _shareButton.height);
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _actionsBackgroundImageView.bottom + 10);
    /*
    NSLog(@"REDRAW");
    
    for(UIView *subview in self.subviews) {
        NSLog(@"Subview: %@", subview);
        for(UIView *subview2 in subview.subviews) {            
            NSLog(@"--> Subview: %@", subview2);                
        }
    }
    
    NSLog(@"REDRAW DONE");  */    
}

#pragma mark -
#pragma mark PhotoView

- (void)didSetPhoto:(Photo *)photo {
    // Very slow if done in layoutSubviews - do it here instead.
    // _scrollView.frame = self.bounds;
    
    _submittedByLabel.text = photo.submittedBy;
    _submittedByImageView.imageUrl = photo.submittedByImageUrl;
    _submittedOnLabel.text = photo.submittedOn;
    _shotInformationLabel.text = photo.shotInformation;
    _pointsLabel.text = [photo.points description];
    // DEK
    _timesFoundLabel.text = [NSString stringWithFormat:@"%@", photo.timesFound]; //description];
    _photoImageView.imageUrl = photo.imageUrl;
    
    if(photo.shotInformation) {
        _shotInformationDescriptionLabel.hidden = NO;
        _shotInformationLabel.hidden = NO;
    } else {
        _shotInformationDescriptionLabel.hidden = YES;
        _shotInformationLabel.hidden = YES;        
    }
}

#pragma mark -
#pragma mark PhotoDetailBackView

- (void)didTouchUpInFlagButton {
    [_delegate photoDetailBackViewDidTouchUpInFlagButton:self];
}

- (void)didTouchUpInShareButton {
    [_delegate photoDetailBackViewDidTouchUpInShareButton:self];    
}

@end