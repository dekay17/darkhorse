//
//  WelcomeController.m
//  Lavahound
//
//  Created by Mark Allen on 6/6/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "WelcomeController.h"
#import "LocationTracker.h"
#import <TwitterKit/TwitterKit.h>
#import "Lavahound-Swift.h"
#import "LocalStorage.h"

@interface WelcomeController(PrivateMethods)

- (void)performPostSignInProcessing;

@end

@implementation WelcomeController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        [[LavahoundFacebook sharedInstance] addDelegate:self];  
    
    return self;
}

- (void)dealloc {
    [[LavahoundFacebook sharedInstance] removeDelegate:self];        
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

+ (UIColor *)colorFromRGB:(NSUInteger)RGB alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((CGFloat)((RGB & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((RGB & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(RGB & 0xFF)) / 255.0
                           alpha:alpha];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [WelcomeController colorFromRGB:0xAD2A01 alpha:1];  //
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://signInOrUpBG.png")] autorelease];    
    backgroundImageView.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:backgroundImageView];
    
    UIImage *signInButtonImage = TTIMAGE(@"bundle://buttonSignIn.png");
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setImage:signInButtonImage forState:UIControlStateNormal];
	[signInButton addTarget:self
                     action:@selector(didTouchUpInSignInButton)
           forControlEvents:UIControlEventTouchUpInside];
	signInButton.frame = CGRectMake(10, 238, signInButtonImage.size.width, signInButtonImage.size.height);
	[self.view addSubview:signInButton];
    
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithType:UIButtonTypeCustom];
    [logInButton addTarget:self
                     action:@selector(didTouchUpInTwitterStartButton)
           forControlEvents:UIControlEventTouchUpInside];
    logInButton.frame = CGRectMake(10, 238, signInButtonImage.size.width, signInButtonImage.size.height);
    [self.view addSubview:logInButton];
    
//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setObject:session.userName forKey:@"displayName"];
//        [params setObject:session.userID forKey:@"userId"];
//        [params setObject:session.authToken forKey:@"authToken"];
//        [params setObject:session.authTokenSecret forKey:@"authTokenSecret"];
//        [API postToServer:@"twitter/sign-up" parameters:params successBlock:^(NSString *apiToken) {
//            [LocalStorage sharedInstance].apiToken = apiToken;
//            [LocalStorage sharedInstance].totalPoints = 0;
//            [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://sign-up"] applyAnimated:YES]];
//
////            [self performPostSignInProcessing];
//        } failureBlock:^(NSError *error) {
//            // Handle error
//            NSLog(@"error %@", error);
//        }];
//        LavahoundSignInApi *lavahoundSignInApi = [[[LavahoundSignInApi alloc] init] autorelease];
//        lavahoundSignInApi.delegate = self;
//        [lavahoundSignInApi signInWithTwitterOAuthToken:session.authToken];
//    }];
    logInButton.frame = CGRectMake(10, signInButton.bottom + 10, signInButtonImage.size.width, signInButtonImage.size.height);
    [self.view addSubview:logInButton];
    
    
    UIImage *signUpButtonImage = TTIMAGE(@"bundle://buttonSignUp.png");
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setImage:signUpButtonImage forState:UIControlStateNormal];
	[signUpButton addTarget:self
                     action:@selector(didTouchUpInSignUpButton)
           forControlEvents:UIControlEventTouchUpInside];
    signUpButton.frame = CGRectMake(10, logInButton.bottom + 20, signUpButtonImage.size.width, signUpButtonImage.size.height);
	[self.view addSubview:signUpButton];
    
//    UIImage *signInWithFacebookButtonImage = TTIMAGE(@"bundle://buttonSignInWithFacebook.png");
//    UIButton *signInWithFacebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [signInWithFacebookButton setImage:signInWithFacebookButtonImage forState:UIControlStateNormal];    
//	[signInWithFacebookButton addTarget:self
//                                 action:@selector(didTouchUpInSignInWithFacebookButton)
//                       forControlEvents:UIControlEventTouchUpInside];
//	signInWithFacebookButton.frame = CGRectMake(10, signUpButton.bottom + 10, signInWithFacebookButtonImage.size.width, signInWithFacebookButtonImage.size.height);
//	[self.view addSubview:signInWithFacebookButton];       

//    UIImage *justStartPlayingButtonImage = TTIMAGE(@"bundle://buttonStartPlaying.png");
//    UIButton *justStartPlayingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [justStartPlayingButton setImage:justStartPlayingButtonImage forState:UIControlStateNormal];
//	[justStartPlayingButton addTarget:self
//                               action:@selector(didTouchUpInJustStartPlayingButton)
//                     forControlEvents:UIControlEventTouchUpInside];
//	justStartPlayingButton.frame = CGRectMake(10, signUpButton.bottom + 10, justStartPlayingButtonImage.size.width, justStartPlayingButtonImage.size.height);
//    justStartPlayingButton.hidden = YES;
//	[self.view addSubview:justStartPlayingButton];    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[LocationTracker sharedInstance] stopUpdatingLocation];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark LavahoundPlayNowApiDelegate

- (void)lavahoundPlayNowApiDidSignIn:(LavahoundPlayNowApi *)lavahoundPlayNowApi {
    [self performPostSignInProcessing];
}

#pragma mark -
#pragma mark LavahoundSignInApiDelegate

- (void)lavahoundSignInApiDidSignIn:(LavahoundSignInApi *)lavahoundSignInApi {
    [self performPostSignInProcessing];
}

#pragma mark -
#pragma mark LavahoundFacebookDelegate

- (void)lavahoundFacebook:(LavahoundFacebook *)lavahoundFacebook didObtainFacebookOAuthToken:(NSString *)facebookOAuthToken {
    LavahoundSignInApi *lavahoundSignInApi = [[[LavahoundSignInApi alloc] init] autorelease];
    lavahoundSignInApi.delegate = self;
    [lavahoundSignInApi signInWithFacebookOAuthToken:facebookOAuthToken];
}

#pragma mark -
#pragma mark WelcomeController

- (void)didTouchUpInJustStartPlayingButton {
    LavahoundPlayNowApi *lavahoundPlayNowApi = [[[LavahoundPlayNowApi alloc] init] autorelease];
    lavahoundPlayNowApi.delegate = self;
    [lavahoundPlayNowApi playNow];
}

- (void)didTouchUpInTwitterStartButton {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:session.userName forKey:@"displayName"];
        [params setObject:session.userID forKey:@"userId"];
        [params setObject:session.authToken forKey:@"authToken"];
        [params setObject:session.authTokenSecret forKey:@"authTokenSecret"];
        [API postToServer:@"twitter/sign-in" parameters:params successBlock:^(NSString *apiToken, NSString *totalPoints) {
            [LocalStorage sharedInstance].apiToken = apiToken;
            [LocalStorage sharedInstance].totalPoints = totalPoints;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[TTURLCache sharedCache] removeAll:YES];
                [[TTNavigator navigator] removeAllViewControllers];
                [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://tab-bar"] applyAnimated:YES]];
            });
        } failureBlock:^(NSError *error) {
            // Handle error
            NSLog(@"error %@", error);
        }];
    }];
}

- (void)performPostSignInProcessing {
    [[TTURLCache sharedCache] removeAll:YES];
    [self dismissModalViewControllerAnimated:NO];
    [[TTNavigator navigator] removeAllViewControllers]; 
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://tab-bar"] applyAnimated:YES]];
}

//- (void)didTouchUpInSignInWithFacebookButton {
//    [[LavahoundFacebook sharedInstance] showAuthorizeDialog];
//}

- (void)didTouchUpInSignInButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://sign-in"] applyAnimated:YES]];    
}

- (void)didTouchUpInSignUpButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://sign-up"] applyAnimated:YES]];    
}

@end