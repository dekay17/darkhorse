//
//  TableViewController.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "TableViewController.h"
#import "LavahoundTableViewDragRefreshDelegate.h"
#import "TTModelViewController+Lavahound.h"
#import "Constants.h"

@implementation TableViewController

#pragma mark -
#pragma mark NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if((self = [super initWithNibName:nil bundle:nil])) {
        self.tableViewStyle = UITableViewStylePlain;
        self.variableHeightRows = YES;               
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiDataChangedNotification:) 
                                                     name:kLavahoundApiDataChangedNotification
                                                   object:nil];            
    }
    
    return self;  
}

- (void)dealloc {
    TTDPRINT(@"Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark TTModelViewController

- (id<UITableViewDelegate>)createDelegate {
	return [[[LavahoundTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

// Quick hack to add a reload button to the "no data found" view provided by TTTableViewController.
// TODO: should probably roll our own views for no data and error so we have this behavior genericized.
- (void)showEmpty:(BOOL)show {
    [super showEmpty:show];
    
    if(show) {
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        [reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(didTouchUpInReloadButton) forControlEvents:UIControlEventTouchUpInside];
        reloadButton.frame = CGRectMake(100, self.emptyView.bottom - 140, floorf((self.emptyView.width - 100 ) / 2), 40);
        [self.emptyView addSubview:reloadButton];
    }
}

- (void)showError:(BOOL)show {
    [super showError:show];
    
    if(show) {
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        [reloadButton setTitle:@"Retry" forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(didTouchUpInReloadButton) forControlEvents:UIControlEventTouchUpInside];
        reloadButton.frame = CGRectMake(100, self.errorView.bottom - 100, floorf((self.errorView.width - 100 ) / 2), 40);
        [self.errorView addSubview:reloadButton];
    }
}

#pragma mark -
#pragma mark NearbyPhotoGalleryController

- (void)didReceiveLavahoundApiDataChangedNotification:(NSNotification *)notification {
    TTDPRINT(@"Received %@, invalidating model data...", [notification name]);
    [self invalidateModelAndNetworkCache];
}

- (void)didTouchUpInReloadButton {
    [self invalidateModelAndNetworkCache];
}

@end