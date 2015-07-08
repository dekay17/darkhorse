//
//  ScoreController.m
//  Lavahound
//
//  Created by Mark Allen on 5/11/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "MyPointsController.h"
#import "UIViewController+Lavahound.h"
#import "TTModelViewController+Lavahound.h"
#import "PointsModel.h"
#import "Points.h"
#import "Constants.h"

@implementation MyPointsController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _totalPointsLabel = nil;
        _finderPointsLabel = nil;    
        _hiderPointsLabel =nil;
        _royaltiesPointsLabel = nil;           
        
        _totalLabel = nil;    
        _finderLabel = nil;    
        _hiderLabel = nil;    
        _royaltiesLabel = nil;    
        _rankPercentileLabel = nil;
        _rankDescriptionLabel = nil;        
     
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                                   style:UIBarButtonItemStyleDone
                                                                                  target:self
                                                                                  action:@selector(didTouchUpInDoneButton)] autorelease];
                [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiDataChangedNotification:) 
                                                     name:kLavahoundApiDataChangedNotification
                                                   object:nil];             
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    TT_RELEASE_SAFELY(_totalLabel);
    TT_RELEASE_SAFELY(_finderLabel);
    TT_RELEASE_SAFELY(_hiderLabel);
    TT_RELEASE_SAFELY(_royaltiesLabel);
    TT_RELEASE_SAFELY(_rankPercentileLabel);     
    TT_RELEASE_SAFELY(_rankDescriptionLabel);
    TT_RELEASE_SAFELY(_totalPointsLabel);
    TT_RELEASE_SAFELY(_finderPointsLabel);    
    TT_RELEASE_SAFELY(_hiderPointsLabel);
    TT_RELEASE_SAFELY(_royaltiesPointsLabel);
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *backgroundImageView = [[[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://pointsBG.png")] autorelease];
    [_modelView addSubview:backgroundImageView];        

//   helpful UI options    
//   _finderLabel.backgroundColor = [UIColor grayColor];
//   _finderLabel.textAlignment = UITextAlignmentCenter;
//   _finderLabel.lineBreakMode = UILineBreakModeWordWrap; 
//   _finderLabel.numberOfLines = 0;        
    
    _totalPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 240, 140, 25)]; //12, 180, 140, 28
    _totalPointsLabel.textAlignment = UITextAlignmentCenter;
    _totalPointsLabel.backgroundColor = [UIColor clearColor];
    [_totalPointsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];   
    [_modelView addSubview:_totalPointsLabel];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 267, 140, 15)]; //12, 207, 140, 15
    _totalLabel.textAlignment = UITextAlignmentCenter;
    _totalLabel.backgroundColor = [UIColor clearColor];
    [_totalLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [_modelView addSubview:_totalLabel];
    
    _finderPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 180, 140, 25)];
    _finderPointsLabel.textAlignment = UITextAlignmentCenter;
    _finderPointsLabel.backgroundColor = [UIColor clearColor];
    [_finderPointsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];   
    [_modelView addSubview:_finderPointsLabel];
    
    _finderLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 207, 140, 15)];
    _finderLabel.textAlignment = UITextAlignmentCenter;
    _finderLabel.backgroundColor = [UIColor clearColor];
    [_finderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];    
    [_modelView addSubview:_finderLabel];
    
    _hiderPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 180, 140, 28)]; //12, 240, 140, 25
    _hiderPointsLabel.textAlignment = UITextAlignmentCenter;
    _hiderPointsLabel.backgroundColor = [UIColor clearColor];
    [_hiderPointsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];   
    [_modelView addSubview:_hiderPointsLabel];
    
    _hiderLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 207, 140, 15)]; //12, 267, 140, 15
    _hiderLabel.textAlignment = UITextAlignmentCenter;
    _hiderLabel.backgroundColor = [UIColor clearColor];    
    [_hiderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];    
    [_modelView addSubview:_hiderLabel];    
    
    _royaltiesPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 240, 140, 25)]; //165, 240, 140, 25
    _royaltiesPointsLabel.textAlignment = UITextAlignmentCenter;
    _royaltiesPointsLabel.backgroundColor = [UIColor clearColor];
    [_royaltiesPointsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24]];   
    [_modelView addSubview:_royaltiesPointsLabel];
    
    _royaltiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 267, 140, 15)];//165, 267, 140, 15
    _royaltiesLabel.textAlignment = UITextAlignmentCenter;
    _royaltiesLabel.backgroundColor = [UIColor clearColor];    
    [_royaltiesLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];    
    [_modelView addSubview:_royaltiesLabel];    
    
    _rankPercentileLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 318, 300, 21)];
    _rankPercentileLabel.textAlignment = UITextAlignmentCenter;    
    _rankPercentileLabel.backgroundColor = [UIColor clearColor];    
    [_rankPercentileLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];    
    [_modelView addSubview:_rankPercentileLabel];    
    
    _rankDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _rankPercentileLabel.bottom - 5, 300, 40)];
    _rankDescriptionLabel.textAlignment = UITextAlignmentCenter;    
    _rankDescriptionLabel.backgroundColor = [UIColor clearColor];    
    [_rankDescriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];    
    [_modelView addSubview:_rankDescriptionLabel];     
}

- (void)viewDidUnload {
    [_totalPointsLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_totalPointsLabel);
    [_finderPointsLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_finderPointsLabel);
    [_hiderPointsLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_hiderPointsLabel);
    [_royaltiesPointsLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_royaltiesPointsLabel);    
    
    [_totalLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_totalLabel);
    [_finderLabel removeFromSuperview];
    TT_RELEASE_SAFELY(_finderLabel);
    [_hiderLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_hiderLabel);
    [_royaltiesLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_royaltiesLabel);
    [_rankPercentileLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_rankPercentileLabel); 
    [_rankDescriptionLabel removeFromSuperview];    
    TT_RELEASE_SAFELY(_rankDescriptionLabel);     
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[PointsModel alloc] init] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime {
    Points *points = ((PointsModel *)self.model).points;
    [self setTitleAndKeepCurrentTabBarItemTitle:@"my points"];

    _totalPointsLabel.text = [NSString stringWithFormat:@"%@", points.total];    
    _totalLabel.text = [NSString stringWithFormat:@"Total Points"];

    _finderPointsLabel.text = [NSString stringWithFormat:@"%@", points.finder];    
    _finderLabel.text = [NSString stringWithFormat:@"Finder Points"];

    _hiderPointsLabel.text = [NSString stringWithFormat:@"%@", points.hider];    
    _hiderLabel.text = [NSString stringWithFormat:@"Hider Points"];
    
    _royaltiesPointsLabel.text = [NSString stringWithFormat:@"%@", points.royalties];
    _royaltiesLabel.text = [NSString stringWithFormat:@"Bonus Points"];

    _rankPercentileLabel.text = [NSString stringWithFormat:@"Overall Rank: %@", points.rank]; //points.rankPercentile
    _rankDescriptionLabel.text = points.rankDescription;
}

#pragma mark -
#pragma mark MyPointsController

- (void)didReceiveLavahoundApiDataChangedNotification:(NSNotification *)notification {
    TTDPRINT(@"Received %@, invalidating model data...", [notification name]);
    [self invalidateModelAndNetworkCache];
}

- (void)didTouchUpInDoneButton {
    [self dismissModalViewControllerAnimated:YES]; 
}

@end