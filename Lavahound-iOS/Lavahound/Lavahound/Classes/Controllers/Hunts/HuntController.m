//
//  HuntController.m
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntController.h"
#import "UIViewController+Lavahound.h"
#import "HuntPhotosMapController.h"
#import "HuntPhotoGalleryController.h"
#import "ScoreboardController.h"

@implementation HuntController

#pragma mark -
#pragma mark NSObject

- (id)initWithHuntId:(NSNumber *)huntId huntName:(NSString *)huntName {
    if((self = [super initWithNibName:nil bundle:nil])) {        
        _huntNameLabel = nil;
        _huntId = [huntId retain];
        _huntName = [huntName retain];        
        
        [self initializeLavahoundNavigationBarWithTitle:@"hunt"];        
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
    TT_RELEASE_SAFELY(_huntId);
    TT_RELEASE_SAFELY(_huntName);
    TT_RELEASE_SAFELY(_huntNameLabel);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {   
    [super viewDidLoad];    
        
    _huntNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 312, 28)];
    _huntNameLabel.font = [UIFont boldSystemFontOfSize:14];
    _huntNameLabel.textColor = [UIColor whiteColor];
    _huntNameLabel.backgroundColor = [UIColor clearColor];
    _huntNameLabel.contentMode = UIViewContentModeCenter;
    _huntNameLabel.text = _huntName;
    [self.view addSubview:_huntNameLabel];
}

- (void)viewDidUnload {
    [_huntNameLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_huntNameLabel);
    [super viewDidUnload];
}

#pragma mark -
#pragma mark SwitchableViewController

- (UIImage *)backgroundImage {
    return TTIMAGE(@"bundle://huntGalleryBG.png");
}

- (CGFloat)switcherButtonTop {
    return 33;
}

- (BOOL)showLeftButtonControllerInitially {
    return NO;
}

- (UIViewController *)createLeftButtonController {
    return [[[HuntPhotosMapController alloc] initWithHuntId:_huntId] autorelease];
}

- (UIViewController *)createCenterButtonController
{
    return [[[HuntPhotoGalleryController alloc] initWithHuntId:_huntId] autorelease];
}

- (UIViewController *)createRightButtonController {
    return [[[ScoreboardController alloc] initWithHuntId:_huntId] autorelease];    
}

@end