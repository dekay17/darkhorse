//
//  ScoreboardController.h
//  Lavahound
//
//  Created by Nathan Russak on 2/22/12.
//  Copyright 2012 LavaHound. All rights reserved.
//

#import "UIViewController+Lavahound.h"
#import "PhotoGalleryDataSource.h"
#import "LocationTracker.h"
#import "Constants.h"
#import "LocalStorage.h"
#import "ScoreboardData.h"

typedef enum
{
    ScoreboardTypeHunt = 0,
    ScoreboardTypePlayer
} ScoreboardType;

@interface ScoreboardController : TTViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NSURLConnectionDelegate>
{
    NSNumber                        *   RequestId;
    TTTableHeaderDragRefreshView    *   RefreshView;
    TTTableHeaderDragRefreshStatus      CurrRefreshStatus;
    IBOutlet UITableView            *   Scoreboard;
    IBOutlet UIView                 *   ErrorView;
    IBOutlet UIView                 *   LoadingView;
    IBOutlet UILabel                *   ErrorTitle;
    IBOutlet UILabel                *   ConterColumnTitle;
    
    ScoreboardType                      m_CurrType;
    NSArray                         *   m_ScoreboardData;
    NSMutableData                   *   m_ResponseData;
    UIImageView                     *   TableFooter;
    
    BOOL                                m_DataLoaded;
}

- (id)initWithHuntId:(NSNumber *)huntId;
- (id)initWithUser;
- (IBAction)EventReloadSelected;
@end