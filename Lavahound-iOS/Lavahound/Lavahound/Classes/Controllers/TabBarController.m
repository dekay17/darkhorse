//
//  TabBarController.m
//  Lavahound
//
//  Created by Mark Allen on 5/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController()

- (void) setFoundItButtonVisibility:(BOOL)Visible;
- (void) EventTabButtonSelected:(UIButton*)sender;
- (void) EventFoundItSelected;

@end

@implementation TabBarController

#pragma mark -
#pragma mark UIViewController

static float    const TAB_BAR_BUFFER        = 3.0f;
static int      const TAB_IDX_HUNTS         = 0;
static int      const TAB_IDX_MY_STUFF      = 1;


- (void)viewDidLoad
{
    UIView              *   vFakeTabBar             = nil;
    UIImageView         *   ivSelectedLeftHunts     = nil,
                        *   ivSelectedRightHunts    = nil,
                        *   ivSelectedCenterHunts   = nil,
                        *   ivSelectedRightStuff    = nil,
                        *   ivSelectedLeftStuff     = nil,
                        *   ivSelectedCenterStuff   = nil,
                        *   ivBarBackground         = nil;
    
    
    
    // Added by DK
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarBackground"] forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [super viewDidLoad];

    // Added by DEK
//    NSLog(@"frame: %@", NSStringFromCGRect(self.view.frame));
//    self.parentViewController.view.frame = CGRectMake(0, 0, 320, 568);
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"lavahound://places",
                      @"lavahound://mystuffhome",
                      nil]];
    

    ivTabIconHunts      = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 62.0f, 44.0f)];
    ivTabIconProfile    = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 62.0f, 44.0f)];
    [ivTabIconHunts     setBackgroundColor:[UIColor clearColor]];
    [ivTabIconProfile   setBackgroundColor:[UIColor clearColor]];
    [ivTabIconHunts     setUserInteractionEnabled:FALSE];
    [ivTabIconProfile   setUserInteractionEnabled:FALSE];
    [ivTabIconHunts     setContentMode:UIViewContentModeCenter];
    [ivTabIconProfile   setContentMode:UIViewContentModeCenter];
    [ivTabIconHunts     setImage:[UIImage imageNamed:@"TabIconHuntsSelected.png"]];
    [ivTabIconProfile   setImage:[UIImage imageNamed:@"TabIconMyStuffDeselected.png"]];
    
    vFakeTabBar = [[UIView alloc] initWithFrame:self.tabBar.frame];
    [vFakeTabBar setBackgroundColor:[UIColor blackColor]];
    
    ivBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.tabBar.frame.size.height)];
    [ivBarBackground setImage:[UIImage imageNamed:@"TabBarBackground.png"]];
    
    btnTabHunts     = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    btnTabMyStuff   = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    btnFoundIt      = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [btnFoundIt setBackgroundImage:[UIImage imageNamed:@"FoundIt.png"] forState:UIControlStateNormal];
    [btnTabHunts    setTag:TAB_IDX_HUNTS];
    [btnTabMyStuff  setTag:TAB_IDX_MY_STUFF];
    [btnTabHunts    addTarget:self action:@selector(EventTabButtonSelected:)    forControlEvents:UIControlEventTouchUpInside];
    [btnTabMyStuff  addTarget:self action:@selector(EventTabButtonSelected:)    forControlEvents:UIControlEventTouchUpInside];
    [btnFoundIt     addTarget:self action:@selector(EventFoundItSelected)       forControlEvents:UIControlEventTouchUpInside];
    

    
    vTabBackgroundHunts     = [[UIView alloc] initWithFrame:CGRectMake(TAB_BAR_BUFFER,
                                                                       TAB_BAR_BUFFER,
                                                                       self.view.frame.size.width * 0.5f - (TAB_BAR_BUFFER*2),
                                                                       self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];
    vTabBackgroundProfile   = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5f + TAB_BAR_BUFFER,
                                                                      TAB_BAR_BUFFER,
                                                                      self.view.frame.size.width * 0.5f - (TAB_BAR_BUFFER*2),
                                                                      self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];
    [vTabBackgroundHunts    setHidden:FALSE];
    [vTabBackgroundProfile  setHidden:TRUE];
    
    
    ivSelectedLeftHunts     = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                            0.0f,
                                                                            4.0f,
                                                                            vTabBackgroundHunts.frame.size.height)];
    ivSelectedRightHunts    = [[UIImageView alloc] initWithFrame:CGRectMake(vTabBackgroundHunts.frame.size.width-4.0f,
                                                                            0.0f,
                                                                            4.0f,
                                                                            vTabBackgroundHunts.frame.size.height)];
    ivSelectedLeftStuff     = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,
                                                                            0.0f,
                                                                            4.0f,
                                                                            vTabBackgroundProfile.frame.size.height)];    
    ivSelectedRightStuff    = [[UIImageView alloc] initWithFrame:CGRectMake(vTabBackgroundProfile.frame.size.width-4.0f,
                                                                            0.0f,
                                                                            4.0f,
                                                                            vTabBackgroundProfile.frame.size.height)];    
    ivSelectedCenterHunts   = [[UIImageView alloc] initWithFrame:CGRectMake(ivSelectedLeftHunts.frame.size.width,
                                                                            0.0f,
                                                                            vTabBackgroundHunts.frame.size.width - ivSelectedLeftHunts.frame.size.width - ivSelectedRightHunts.frame.size.width,
                                                                            vTabBackgroundHunts.frame.size.height)];
    ivSelectedCenterStuff   = [[UIImageView alloc] initWithFrame:CGRectMake(ivSelectedLeftStuff.frame.size.width,
                                                                            0.0f,
                                                                            vTabBackgroundProfile.frame.size.width - ivSelectedLeftStuff.frame.size.width - ivSelectedRightStuff.frame.size.width,
                                                                            vTabBackgroundProfile.frame.size.height)];
    [ivSelectedLeftHunts    setImage:[UIImage imageNamed:@"TabSelectedLeft.png"]];
    [ivSelectedRightHunts   setImage:[UIImage imageNamed:@"TabSelectedRight.png"]];
    [ivSelectedCenterHunts  setImage:[UIImage imageNamed:@"TabSelectedCenter.png"]];    
    [ivSelectedLeftStuff    setImage:[UIImage imageNamed:@"TabSelectedLeft.png"]];    
    [ivSelectedRightStuff 	setImage:[UIImage imageNamed:@"TabSelectedRight.png"]];
    [ivSelectedCenterStuff 	setImage:[UIImage imageNamed:@"TabSelectedCenter.png"]];
    [ivSelectedLeftHunts    setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
    [ivSelectedRightHunts   setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight];
    [ivSelectedCenterHunts  setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [ivSelectedLeftStuff    setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
    [ivSelectedRightStuff   setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight];
    [ivSelectedCenterStuff  setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [vTabBackgroundHunts    addSubview:ivSelectedLeftHunts];
    [vTabBackgroundHunts    addSubview:ivSelectedRightHunts];
    [vTabBackgroundHunts    addSubview:ivSelectedCenterHunts];
    [vTabBackgroundProfile  addSubview:ivSelectedLeftStuff];
    [vTabBackgroundProfile  addSubview:ivSelectedRightStuff];
    [vTabBackgroundProfile  addSubview:ivSelectedCenterStuff];
    
    [self.view      addSubview:vFakeTabBar];
    [self.view      addSubview:btnFoundIt];
    [vFakeTabBar 	addSubview:ivBarBackground];
    [vFakeTabBar    addSubview:vTabBackgroundHunts];
    [vFakeTabBar    addSubview:vTabBackgroundProfile];
    [vFakeTabBar    addSubview:btnTabHunts];
    [vFakeTabBar    addSubview:btnTabMyStuff];
    [vFakeTabBar    addSubview:ivTabIconHunts];
    [vFakeTabBar    addSubview:ivTabIconProfile];

    [self setFoundItButtonVisibility:FALSE];
    
    [ivBarBackground        release];
    [vFakeTabBar            release];
    [ivSelectedLeftHunts    release];
    [ivSelectedRightHunts   release];
    [ivSelectedCenterHunts  release];
    [ivSelectedLeftStuff    release];
    [ivSelectedRightStuff   release];
    [ivSelectedCenterStuff  release];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) dealloc
{
    [btnTabHunts            release];
    [btnTabMyStuff          release];
    [btnFoundIt             release];
    [ivTabIconHunts         release];
    [ivTabIconProfile       release];
    [vTabBackgroundHunts    release];
    [vTabBackgroundProfile  release];
    [super                  dealloc];
}

- (void) EventTabButtonSelected:(UIButton*)sender
{
    UINavigationController * CurrNavController = nil;
    id DisplayedController = nil;
    
    if (sender.tag != self.selectedIndex)
    {
        if (sender.tag == TAB_IDX_HUNTS)
        {
            [btnTabMyStuff          setBackgroundImage:nil forState:UIControlStateNormal];
            [btnTabMyStuff          setBackgroundImage:nil forState:UIControlStateHighlighted];
            
            [ivTabIconHunts         setImage:[UIImage imageNamed:@"TabIconHuntsSelected.png"]];
            [ivTabIconProfile       setImage:[UIImage imageNamed:@"TabIconMyStuffDeselected.png"]];
            [vTabBackgroundHunts    setHidden:FALSE];
            [vTabBackgroundProfile  setHidden:TRUE];
        }
        else if (sender.tag == TAB_IDX_MY_STUFF)
        {
            [btnTabHunts            setBackgroundImage:nil forState:UIControlStateNormal];
            [btnTabHunts            setBackgroundImage:nil forState:UIControlStateHighlighted];

            [ivTabIconHunts         setImage:[UIImage imageNamed:@"TabIconHuntsDeselected.png"]];
            [ivTabIconProfile       setImage:[UIImage imageNamed:@"TabIconMyStuffSelected.png"]];
            [vTabBackgroundHunts    setHidden:TRUE];
            [vTabBackgroundProfile  setHidden:FALSE];
        }

        [self setSelectedIndex:sender.tag];
    }
    else
    {
        [[TTNavigator navigator].visibleViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (sender.tag == TAB_IDX_MY_STUFF)
    {
        [self setFoundItButtonVisibility:FALSE animated:TRUE];
    }
    else if (sender.tag == TAB_IDX_HUNTS)
    {
        CurrNavController = (UINavigationController*) [self.viewControllers objectAtIndex:0];
        DisplayedController = CurrNavController.topViewController;
        
        if ([DisplayedController isKindOfClass:[PhotoDetailsController class]] || [DisplayedController isKindOfClass:[MapItController class]])
        {
            [self setFoundItButtonVisibility:TRUE animated:TRUE];
        }
    }
}

- (void) EventFoundItSelected
{
    UINavigationController * HuntNavController = nil;
    id DisplayedController = nil;
    PhotoDetailsController * HuntDetailView = nil;
    MapItController * MapView = nil;

    HuntNavController = (UINavigationController*) [self.viewControllers objectAtIndex:0];
    
    DisplayedController = HuntNavController.topViewController;
    
    if ([DisplayedController isKindOfClass:[PhotoDetailsController class]])
    {
        HuntDetailView = (PhotoDetailsController*) DisplayedController;
        [HuntDetailView EventFoundItSelected];
    }
    else if ([DisplayedController isKindOfClass:[MapItController class]])
    {
        MapView = (MapItController*) DisplayedController;
        [MapView EventFoundItSelected];
    }
}

- (void) setFoundItButtonVisibility:(BOOL)Visible animated:(BOOL)Animated
{
    BOOL bCurrentVisibility = FALSE;
    
    bCurrentVisibility = (btnFoundIt.frame.origin.y == self.tabBar.frame.origin.y - (65.0f - self.tabBar.frame.size.height));
    
    if (bCurrentVisibility != Visible)
    {
        if (Animated)
        {
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{[self setFoundItButtonVisibility:Visible];}
                             completion:^(BOOL Finished){}];
        }
        else
        {
            [self setFoundItButtonVisibility:Visible];
        }
    }
}

- (void) setFoundItButtonVisibility:(BOOL)Visible
{
    if (Visible)
    {        
        [btnTabHunts    setFrame:CGRectMake(TAB_BAR_BUFFER,
                                            TAB_BAR_BUFFER,
                                            self.tabBar.frame.size.width * 0.25 - (TAB_BAR_BUFFER*2),
                                            self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];
        
        [btnTabMyStuff  setFrame:CGRectMake(self.view.frame.size.width - (self.tabBar.frame.size.width * 0.25 - (TAB_BAR_BUFFER*2)) - TAB_BAR_BUFFER,
                                            TAB_BAR_BUFFER,
                                            self.tabBar.frame.size.width * 0.25 - (TAB_BAR_BUFFER*2),
                                            self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];
        
        [btnFoundIt setFrame:CGRectMake((self.view.frame.size.width/2) - 65.5f,
                                        self.tabBar.frame.origin.y - (65.0f - self.tabBar.frame.size.height),
                                        131.0f,
                                        65.0f)];
    }
    else
    {
        [btnTabHunts    setFrame:CGRectMake(TAB_BAR_BUFFER,
                                            TAB_BAR_BUFFER,
                                            self.view.frame.size.width * 0.5f - (TAB_BAR_BUFFER*2),
                                            self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];
        [btnTabMyStuff  setFrame:CGRectMake(self.view.frame.size.width * 0.5f + TAB_BAR_BUFFER,
                                            TAB_BAR_BUFFER,
                                            self.view.frame.size.width * 0.5f - (TAB_BAR_BUFFER*2),
                                            self.tabBar.frame.size.height - (TAB_BAR_BUFFER*2))];

        [btnFoundIt setFrame:CGRectMake((self.view.frame.size.width/2) - 65.5f,
                                        self.view.frame.size.height,
                                        131.0f,
                                        65.0f)];
    }
    
    [vTabBackgroundHunts    setFrame:btnTabHunts.frame];
    [vTabBackgroundProfile  setFrame:btnTabMyStuff.frame];
    
    [ivTabIconHunts     setCenter:btnTabHunts.center];
    [ivTabIconProfile   setCenter:btnTabMyStuff.center];
}

#pragma mark -
#pragma mark ImagePickerDelegate

- (void)imagePicker:(ImagePicker *)imagePicker didPickImage:(UIImage *)image atLocation:(CLLocation *)location {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://photo-positioning"] applyAnimated:NO]];
}

#pragma mark -
#pragma mark TabBarController

- (void)didTouchUpInCameraButton {
    ImagePicker *imagePicker = [[[ImagePicker alloc] initWithViewController:self delegate:self] autorelease];
    [imagePicker showFromTabBar:self.tabBar];
}

@end 