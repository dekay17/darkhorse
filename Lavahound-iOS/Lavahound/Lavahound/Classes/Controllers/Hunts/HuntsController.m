//
//  HuntsController.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntsController.h"
#import "UIViewController+Lavahound.h"
#import "HuntsDataSource.h"

@implementation HuntsController

#pragma mark -
#pragma mark NSObject

- (id)initWithPlaceId:(NSNumber *)placeId {
    if((self = [super initWithNibName:nil bundle:nil])) {        
        _placeNameLabel = nil;
        _placeId = [placeId retain];
        
        [self initializeLavahoundNavigationBarWithTitle:@"hunt"];        
        [self addPointsButtonToNavigationBar];        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:nil
                                                                                 action:nil] autorelease];
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_placeNameLabel);
    TT_RELEASE_SAFELY(_placeId);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {   
    [super viewDidLoad];
    // fix nav bar
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://huntHomeBG.png")] autorelease];    
    [self.view addSubview:backgroundImageView];    
    [self.view sendSubviewToBack:backgroundImageView];
    
    _placeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 312, 28)];
    _placeNameLabel.font = [UIFont boldSystemFontOfSize:14];
    _placeNameLabel.textColor = [UIColor whiteColor];
    _placeNameLabel.backgroundColor = [UIColor clearColor];
    _placeNameLabel.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_placeNameLabel];
    CGFloat heightDiff = 75;
//    if (SYSTEM_VERSION_LESS_THAN(@"4.0")) {
//        heightDiff = 75l
//    }
    self.tableView.frame = CGRectMake(self.tableView.left, self.tableView.top + 27, self.tableView.width, self.tableView.height - heightDiff);
}

- (void)viewDidUnload {
    [_placeNameLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_placeNameLabel);
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.dataSource = [[[HuntsDataSource alloc] initWithPlaceId:_placeId] autorelease];
}

- (void)didShowModel:(BOOL)firstTime {    
    Place *place = ((HuntsModel *)self.model).place;    
    _placeNameLabel.text = place.name;
    [super didShowModel:firstTime];
}

@end