//
//  SwitchableThreeViewController.m
//  Lavahound
//
//  Created by Nathan Russak on 2/22/12.
//  Copyright 2012 LavaHound. All rights reserved.
//

#import "SwitchableThreeViewController.h"
#import "UIViewController+Lavahound.h"
#import "UINavigationBar+Lavahound.h"
#import "LocationTracker.h"

NSString * const kThreeLeftButtonControllerKey = @"LeftButtonControllerKey";
NSString * const kThreeCenterButtonControllerKey = @"CenterButtonControllerKey";
NSString * const kThreeRightButtonControllerKey = @"RightButtonControllerKey";

@interface SwitchableThreeViewController(PrivateMethods)

@property(nonatomic, readonly) UIViewController *leftButtonController;
@property(nonatomic, readonly) UIViewController *rightButtonController;
@property(nonatomic, readonly) UIViewController *centerButtonController;

@end


@implementation SwitchableThreeViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {  
        _leftButton = nil;
        _rightButton = nil;
        [self addPointsButtonToNavigationBar];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

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
    _leftButton.frame = CGRectMake(5, self.switcherButtonTop, 103.0f, mapButtonInactiveImage.size.height);
    
//    if(self.showLeftButtonControllerInitially)
//        _leftButton.selected = YES;
    
	[self.view addSubview:_leftButton]; 
    
    
    UIImage *galleryButtonInactiveImage = self.centerButtonInactiveImage;
    UIImage *galleryButtonActiveImage = self.centerButtonActiveImage;
    
    _centerButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_centerButton setImage:galleryButtonActiveImage forState:UIControlStateNormal];
    [_centerButton setImage:galleryButtonActiveImage forState:UIControlStateSelected];
    [_centerButton addTarget:self
                      action:@selector(didTouchUpInCenterButton)
            forControlEvents:UIControlEventTouchUpInside];
    _centerButton.frame = CGRectMake(_leftButton.right, self.switcherButtonTop, 103.0f, galleryButtonInactiveImage.size.height);

	[self.view addSubview:_centerButton];     

    UIImage *scoreboardButtonInactiveImage = self.rightButtonInactiveImage;
    UIImage *scoreboardButtonActiveImage = self.rightButtonActiveImage;
    
    _rightButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];  
    [_rightButton setImage:scoreboardButtonActiveImage forState:UIControlStateSelected];
    [_rightButton setImage:scoreboardButtonInactiveImage forState:UIControlStateNormal];
	[_rightButton addTarget:self
                     action:@selector(didTouchUpInRightButton)
           forControlEvents:UIControlEventTouchUpInside];
	_rightButton.frame = CGRectMake(_centerButton.right, _centerButton.top, 103.0f, galleryButtonInactiveImage.size.height);
    
//    if(!self.showLeftButtonControllerInitially)
//        _centerButton.selected = YES;    
    
	[self.view addSubview:_rightButton];        
    
    UIViewController *leftButtonController = [self createLeftButtonController];
    leftButtonController.view.top = 36 + self.switcherButtonTop;
    leftButtonController.view.height -= 36 + self.switcherButtonTop;   
    
    UIViewController *centerButtonController = [self createCenterButtonController];
    centerButtonController.view.top = 36 + self.switcherButtonTop;
    centerButtonController.view.height -= 36 + self.switcherButtonTop;
    
    UIViewController *rightButtonController = [self createRightButtonController];
    rightButtonController.view.top = 36 + self.switcherButtonTop;
    rightButtonController.view.height -= 36 + self.switcherButtonTop;
    
    if(self.showLeftButtonControllerInitially)
    {
        rightButtonController.view.hidden = YES;     
        centerButtonController.view.hidden = YES;
    }
    else
    {
        leftButtonController.view.hidden = YES;
        rightButtonController.view.hidden = YES;
    }
    
    [self.view addSubview:leftButtonController.view];
    [self.view addSubview:centerButtonController.view];
    [self.view addSubview:rightButtonController.view];        
    
    [self.viewControllers setObject:leftButtonController forKey:kThreeLeftButtonControllerKey];
    [self.viewControllers setObject:centerButtonController forKey:kThreeCenterButtonControllerKey];
    [self.viewControllers setObject:rightButtonController forKey:kThreeRightButtonControllerKey];
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
    _leftButton.selected = YES;
    _centerButton.selected = NO;
    _rightButton.selected = NO;
    
    [_leftButton    setImage:self.leftButtonActiveImage      forState:UIControlStateNormal];
    [_centerButton  setImage:self.centerButtonInactiveImage  forState:UIControlStateNormal];
    [_rightButton   setImage:self.rightButtonInactiveImage   forState:UIControlStateNormal];

    self.leftButtonController.view.hidden = NO;
    self.centerButtonController.view.hidden = YES;
    self.rightButtonController.view.hidden = YES;

}

- (void)didTouchUpInCenterButton
{
    _leftButton.selected = NO;
    _centerButton.selected = YES;
    _rightButton.selected = NO;
    
    [_leftButton    setImage:self.leftButtonInactiveImage   forState:UIControlStateNormal];
    [_centerButton  setImage:self.centerButtonActiveImage   forState:UIControlStateNormal];
    [_rightButton   setImage:self.rightButtonInactiveImage  forState:UIControlStateNormal];
    
    self.leftButtonController.view.hidden = YES;
    self.centerButtonController.view.hidden = NO;
    self.rightButtonController.view.hidden = YES;    
}

- (void)didTouchUpInRightButton {
    _leftButton.selected = NO;    
    _centerButton.selected = NO;
    _rightButton.selected = YES;
    
    [_leftButton    setImage:self.leftButtonInactiveImage   forState:UIControlStateNormal];
    [_centerButton  setImage:self.centerButtonInactiveImage forState:UIControlStateNormal];
    [_rightButton   setImage:self.rightButtonActiveImage    forState:UIControlStateNormal];
    
    self.leftButtonController.view.hidden = YES;
    self.centerButtonController.view.hidden = YES;
    self.rightButtonController.view.hidden = NO;
}

- (UIViewController *)leftButtonController {
    return [self.viewControllers objectForKey:kThreeLeftButtonControllerKey];    
}

- (UIViewController *)centerButtonController {
    return [self.viewControllers objectForKey:kThreeCenterButtonControllerKey];
}

- (UIViewController *)rightButtonController {
    return [self.viewControllers objectForKey:kThreeRightButtonControllerKey];
}

- (UIImage *)leftButtonActiveImage {
    return TTIMAGE(@"bundle://HuntMapActv.png");
}

- (UIImage *)leftButtonInactiveImage {
    return TTIMAGE(@"bundle://HuntMapInactv.png");
}

- (UIImage *)centerButtonActiveImage
{
    return TTIMAGE(@"bundle://HuntGalActv.png");
}

- (UIImage *)centerButtonInactiveImage
{
    return TTIMAGE(@"bundle://HuntGalInactv.png");    
}

- (UIImage *)rightButtonActiveImage
{
    return TTIMAGE(@"bundle://HuntScoreActv.png");
}

- (UIImage *)rightButtonInactiveImage
{
    return TTIMAGE(@"bundle://HuntScoreInactv.png");
}

- (UIImage *)backgroundImage {
    return TTIMAGE(@"bundle://galleryBG.png");
}

- (UIViewController *)createLeftButtonController {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIViewController *)createCenterButtonController {
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