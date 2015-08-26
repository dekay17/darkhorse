//
//  SwitchableViewController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SwitchableViewController.h"
#import "UIViewController+Lavahound.h"
#import "UINavigationBar+Lavahound.h"
#import "LocationTracker.h"

NSString * const kLeftButtonControllerKey = @"LeftButtonControllerKey";
NSString * const kRightButtonControllerKey = @"RightButtonControllerKey";

@interface SwitchableViewController(PrivateMethods)

@property(nonatomic, readonly) UIViewController *leftButtonController;
@property(nonatomic, readonly) UIViewController *rightButtonController;

@end


@implementation SwitchableViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {  
        _leftButton = nil;
        _rightButton = nil;
        [self addPointsButtonToNavigationBar];
        // DEK
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
                
        //UIBarButtonItemStyleBordered
        UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:nil
                                                                       action:nil] autorelease];
        [backButton setTintColor:[UIColor whiteColor]];
        
        self.navigationItem.backBarButtonItem = backButton;
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

//        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_leftButton);
    TT_RELEASE_SAFELY(_rightButton);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:self.backgroundImage] autorelease];
    [self.view addSubview:backgroundImageView];
    
    UIImage *mapButtonInactiveImage = self.leftButtonInactiveImage;
    UIImage *mapButtonActiveImage = self.leftButtonActiveImage;
    
    _leftButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
    [_leftButton setImage:mapButtonInactiveImage forState:UIControlStateNormal];
    [_leftButton setImage:mapButtonActiveImage forState:UIControlStateSelected];    
	[_leftButton addTarget:self
                    action:@selector(didTouchUpInLeftButton)
          forControlEvents:UIControlEventTouchUpInside];
	_leftButton.frame = CGRectMake(5, self.switcherButtonTop, mapButtonInactiveImage.size.width, mapButtonInactiveImage.size.height);
    
    if(self.showLeftButtonControllerInitially)
    {
        [_leftButton setImage:mapButtonActiveImage forState:UIControlStateNormal];
        _leftButton.selected = YES;
    }
    
	[self.view addSubview:_leftButton];       
    
    UIImage *galleryButtonInactiveImage = self.rightButtonInactiveImage;
    UIImage *galleryButtonActiveImage = self.rightButtonActiveImage;    
    
    _rightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
    [_rightButton setImage:galleryButtonInactiveImage forState:UIControlStateNormal];
    [_rightButton setImage:galleryButtonActiveImage forState:UIControlStateSelected];   
	[_rightButton addTarget:self
                     action:@selector(didTouchUpInRightButton)
           forControlEvents:UIControlEventTouchUpInside];
	_rightButton.frame = CGRectMake(_leftButton.right, _leftButton.top, galleryButtonInactiveImage.size.width, galleryButtonInactiveImage.size.height);
    
    if(!self.showLeftButtonControllerInitially)
    {
        _rightButton.selected = YES;    
        [_rightButton setImage:galleryButtonActiveImage  forState:UIControlStateNormal];
    }
    
	[self.view addSubview:_rightButton];        
    
    UIViewController *leftButtonController = [self createLeftButtonController];
    leftButtonController.view.top = 36 + self.switcherButtonTop;
    leftButtonController.view.height -= 36 + self.switcherButtonTop;   
    
    UIViewController *rightButtonController = [self createRightButtonController];
    rightButtonController.view.top = 36 + self.switcherButtonTop;
    rightButtonController.view.height -= 36 + self.switcherButtonTop;
    
    if(self.showLeftButtonControllerInitially)
        rightButtonController.view.hidden = YES;     
    else
        leftButtonController.view.hidden = YES;                 
    
    [self.view addSubview:leftButtonController.view];        
    [self.view addSubview:rightButtonController.view];        
    
    [self.viewControllers setObject:leftButtonController forKey:kLeftButtonControllerKey];
    [self.viewControllers setObject:rightButtonController forKey:kRightButtonControllerKey];
}

- (void)viewDidUnload {
    [_leftButton removeFromSuperview];
    TT_RELEASE_SAFELY(_leftButton);
    [_rightButton removeFromSuperview];
    TT_RELEASE_SAFELY(_rightButton);
    
    for(UIViewController *viewController in self.viewControllers.allValues)
        [viewController.view removeFromSuperview];
    
    [self.viewControllers removeAllObjects];
    [super viewDidUnload];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Ask for location right off the bat
    [[LocationTracker sharedInstance] startUpdatingLocation];
}

#pragma mark -
#pragma mark SwitchableViewController

- (CGFloat)switcherButtonTop {
    return 7;
}

- (BOOL)showLeftButtonControllerInitially {
    return YES;
}

- (void)didTouchUpInLeftButton {
    _rightButton.selected = NO;
    _leftButton.selected = YES;
    
    [_leftButton    setImage:self.leftButtonActiveImage      forState:UIControlStateNormal];
    [_rightButton   setImage:self.rightButtonInactiveImage   forState:UIControlStateNormal];
    
    self.rightButtonController.view.hidden = YES;
    self.leftButtonController.view.hidden = NO;
}

- (void)didTouchUpInRightButton {
    _leftButton.selected = NO;    
    _rightButton.selected = YES;
    
    [_leftButton    setImage:self.leftButtonInactiveImage   forState:UIControlStateNormal];
    [_rightButton   setImage:self.rightButtonActiveImage    forState:UIControlStateNormal];
    
    self.leftButtonController.view.hidden = YES;    
    self.rightButtonController.view.hidden = NO;
}

- (UIViewController *)leftButtonController {
    return [self.viewControllers objectForKey:kLeftButtonControllerKey];    
}

- (UIViewController *)rightButtonController {
    return [self.viewControllers objectForKey:kRightButtonControllerKey];
}

- (UIImage *)leftButtonActiveImage {
    return TTIMAGE(@"bundle://findMapButtonActive.png");
}

- (UIImage *)leftButtonInactiveImage {
    return TTIMAGE(@"bundle://findMapButtonInactive.png");
}

- (UIImage *)rightButtonActiveImage {
    return TTIMAGE(@"bundle://findGalleryButtonActive.png");
}

- (UIImage *)rightButtonInactiveImage {
    return TTIMAGE(@"bundle://findGalleryButtonInactive.png");
}

- (UIImage *)backgroundImage {
    return TTIMAGE(@"bundle://galleryBG.png");
}

- (UIViewController *)createLeftButtonController {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIViewController *)createRightButtonController {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end