//
//  ShareController.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "ShareController.h"
#import "PhotoDetailsModel.h"
#import "LavahoundEmailer.h"
#import "LavahoundFacebook.h"
#import "UIViewController+Lavahound.h"
#import <TwitterKit/TwitterKit.h>

@implementation ShareController

#pragma mark -
#pragma mark NSObject

- (id)initWithPhotoId:(NSNumber *)photoId shareControllerDismissalBehavior:(ShareControllerDismissalBehavior)shareControllerDismissalBehavior {
    if((self = [super initWithNibName:nil bundle:nil])) {
        _photoId = [photoId retain];
        _shareControllerDismissalBehavior = shareControllerDismissalBehavior;
        [[LavahoundFacebook sharedInstance] addDelegate:self];        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                target:self
                                                                                                action:@selector(didTouchUpInDoneButton)] autorelease];           
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

    }
    
    return self;
}

- (void)dealloc {
    [[LavahoundFacebook sharedInstance] removeDelegate:self];
    TT_RELEASE_SAFELY(_photoId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://shareBG.png")] autorelease];
    [_modelView addSubview:backgroundImageView];     
    
    UILabel *shareLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 22)] autorelease];
    shareLabel.textAlignment = UITextAlignmentCenter;
    shareLabel.lineBreakMode = UILineBreakModeWordWrap; 
    shareLabel.numberOfLines = 0;
    shareLabel.textColor = RGBCOLOR(162, 25, 0);
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    shareLabel.text = @"How Would You Like To Share?";
    [_modelView addSubview:shareLabel];        
    
    UIImage *emailButtonImage = TTIMAGE(@"bundle://buttonEmail.png");     
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[emailButton setImage:emailButtonImage forState:UIControlStateNormal];
	[emailButton addTarget:self
                    action:@selector(didTouchUpInEmailButton)
          forControlEvents:UIControlEventTouchUpInside];
	emailButton.frame = CGRectMake(((_modelView.width/2) - (emailButtonImage.size.width/2)), 243, emailButtonImage.size.width, emailButtonImage.size.height);
	[_modelView addSubview:emailButton];

        UIImage *twitterButtonImage = TTIMAGE(@"bundle://buttonTwitter.png");
        UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    	[tweetButton setImage:twitterButtonImage forState:UIControlStateNormal];
    	[tweetButton addTarget:self
                           action:@selector(didTouchUpInTweetButton)
                 forControlEvents:UIControlEventTouchUpInside];
    	tweetButton.frame = CGRectMake(emailButton.right + 6, emailButton.top, twitterButtonImage.size.width, twitterButtonImage.size.height);
    	[_modelView addSubview:tweetButton];
    
//    UIImage *facebookButtonImage = TTIMAGE(@"bundle://buttonFacebook.png");         
//    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];  
//	[facebookButton setImage:facebookButtonImage forState:UIControlStateNormal];
//	[facebookButton addTarget:self
//                       action:@selector(didTouchUpInFacebookButton)
//             forControlEvents:UIControlEventTouchUpInside];
//	facebookButton.frame = CGRectMake(emailButton.right + 6, emailButton.top, facebookButtonImage.size.width, facebookButtonImage.size.height);
//	[_modelView addSubview:facebookButton];     
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[PhotoDetailsModel alloc] initWithPhotoId:_photoId] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {
    [super didShowModel:firstTime];
    [self setTitleWithLavahoundFont: @"share this shot"];
}

#pragma mark -
#pragma mark LavahoundFacebookDelegate

- (void)lavahoundFacebook:(LavahoundFacebook *)lavahoundFacebook didPostToFeed:(NSString *)postId {
    TTAlert(@"Successfully posted to your feed!");
}

#pragma mark -
#pragma mark ShareController

- (void)didTouchUpInEmailButton {
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;    
    [[LavahoundEmailer sharedInstance] emailPhoto:photo];
}

- (void)didTouchUpInFacebookButton {
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;    
    [[LavahoundFacebook sharedInstance] postPhotoToFeed:photo];
}
- (void)didTouchUpInTweetButton {
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"just setting up my Fabric"];
    [composer setImage:[UIImage imageNamed:@"fabric"]];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}


- (void)didTouchUpInDoneButton {
    // In 1.1, we don't do this anymore
    //TTNavigator *navigator = [TTNavigator navigator];    
    
    if(_shareControllerDismissalBehavior == ShareControllerDismissalBehaviorDefault) {
        [self dismissModalViewControllerAnimated:YES];       
    } else {
        TTDPRINT(@"Dismissing");
        [self dismissModalViewControllerAnimated:YES];               
        // In 1.1, we don't do this anymore
        //[self dismissModalViewControllerAnimated:NO];        
        //[navigator.visibleViewController.navigationController popToRootViewControllerAnimated:YES];            
    }
}

@end