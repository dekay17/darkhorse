//
//  ScoreboardController.m
//  Lavahound
//
//  Created by Nathan Russak on 2/22/12.
//  Copyright 2012 LavaHound. All rights reserved.
//

#import "ScoreboardController.h"
#import "NSString+Lavahound.h"

@interface ScoreboardController()

- (void) LoadScoreboardData;
- (NSArray*) ParseResponse:(NSData*)ResponseData;
- (ScoreboardData*) ParseRecord:(NSString*)RecordData;
- (void) DisplayErrorMessage:(NSString*)Message;

@end

@implementation ScoreboardController


static NSString * const TAG_MESSAGE_START_HUNT  = @"\"huntscoreboard\":";
static NSString * const TAG_MESSAGE_START_USER  = @"\"userscoreboard\":";
static NSString * const TAG_DATA_PLACE          = @"\"place\":";
static NSString * const TAG_DATA_USERNAME       = @"\"username\":";
static NSString * const TAG_DATA_USERID         = @"\"id\":";
static NSString * const TAG_DATA_POINTS         = @"\"totalpoints\":";
static NSString * const TAG_DATA_HUNT_NAME      = @"\"huntname\":";
static NSString * const TAG_DATA_HUNT_RANK      = @"\"huntrank\":";
static NSString * const TAG_DATA_IS_USER        = @"\"isUser\":";
static NSString * const COMMA                   = @",";
static NSString * const OPEN_BRACKET            = @"{";
static NSString * const CLOSE_BRACKET           = @"}";
static NSString * const EMPTY_DATA              = @"[]";
static NSString * const CELL_IDENTIFIER_A       = @"CellIdentifierLight";
static NSString * const CELL_IDENTIFIER_B       = @"CellIdentifierDark";
static int const TAG_LABEL_RANK                 = 2;
static int const TAG_LABEL_NAME                 = 3;
static int const TAG_LABEL_POINTS               = 4;

static NSString * const REQUEST_URL_HUNT = @"/scoreboard/hunt";
static NSString * const REQUEST_URL_USER = @"/scoreboard/user";

//-------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Life Cycle
//-------------------------------------------------------------------------------------
// Default Constructor
- (id) init
{
    self = [super initWithNibName:@"HuntScoreBoard" bundle:nil];
    
    if(self)
    {
        [self initializeLavahoundNavigationBarWithTitle:@"my points"];
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];
        CurrRefreshStatus   = TTTableHeaderDragRefreshLoading;
        m_DataLoaded        = FALSE;
    }
    
    return self;
}

// Initializes the class to load scoreboard information for the specified hunt
- (id)initWithHuntId:(NSNumber *)huntId
{
    self = [self init];
    
    if (self)
    {
        RequestId = [huntId retain];
        m_CurrType = ScoreboardTypeHunt;
    }
    
    return self;
}

// Initializes the class to load scoreboard information for the specified user
- (id)initWithUser
{
    self = [self init];
    
    if (self)
    {
        m_CurrType = ScoreboardTypePlayer;
    }
    
    return self;    
}

// States that the view has finished loading from the NIB object
- (void) viewDidLoad
{    
    [super viewDidLoad];
    
    RefreshView = [[TTTableHeaderDragRefreshView alloc] initWithFrame:CGRectMake(0.0f, -50.0f, self.view.frame.size.width, 50.0f)];
    [RefreshView setStatus:CurrRefreshStatus];
    
    if (m_CurrType == ScoreboardTypeHunt)
    {
        [ConterColumnTitle setText:@"Name"];
    }
    else
    {
        [ConterColumnTitle setText:@"Hunt"];
        [Scoreboard setFrame:CGRectMake(Scoreboard.frame.origin.x,
                                        Scoreboard.frame.origin.y,
                                        Scoreboard.frame.size.width,
                                        344.0f)];
    }
    
    [Scoreboard addSubview:RefreshView];
    
    [self LoadScoreboardData];
}

// Releases all memory references still retained by the class
- (void)dealloc {
    [RequestId          release];
    [m_ScoreboardData   release];
    [m_ResponseData     release];
    [RefreshView        removeFromSuperview];
    [RefreshView        release];
    [TableFooter        removeFromSuperview];
    [TableFooter        release];
    
    [super dealloc];
}


//-------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Misc Functions
//-------------------------------------------------------------------------------------
// Calls the appropriate webservice to load the data for the scoreboard
- (void) LoadScoreboardData
{
    NSString            * FullRequestUrl    = nil;
    NSURLRequest        * DataRequest       = nil;
    NSURLConnection     * RequestTest       = nil;
    
    [LoadingView setHidden:FALSE];
    
    if (m_ScoreboardData)
    {
        [m_ScoreboardData release];
        m_ScoreboardData = nil;
        [Scoreboard reloadData];
    }
    
    if (m_CurrType == ScoreboardTypeHunt)
    {
        FullRequestUrl = [NSString stringWithFormat:@"%@%@?api_token=%@&hunt_id=%i&udid=%@&version_number=%@",
                          [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix,
                          REQUEST_URL_HUNT,
                          [LocalStorage sharedInstance].apiToken,
                          RequestId.intValue,
                          [NSString GetUUID],
//                          [UIDevice currentDevice].uniqueIdentifier,
                          [Constants sharedInstance].versionNumber];
    }
    else
    {
        FullRequestUrl = [NSString stringWithFormat:@"%@%@?api_token=%@&udid=%@&version_number=%@",
                          [Constants sharedInstance].apiEndpointAbsoluteUrlPrefix,
                          REQUEST_URL_USER,
                          [LocalStorage sharedInstance].apiToken,
                          [NSString GetUUID],
//                          [UIDevice currentDevice].uniqueIdentifier,
                          [Constants sharedInstance].versionNumber];
    }
    

    
    DataRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:FullRequestUrl]];
    RequestTest = [[NSURLConnection alloc] initWithRequest:DataRequest delegate:self startImmediately:TRUE];
    
    if (RequestTest)
    {
        m_ResponseData = [[NSMutableData alloc] init];
    }
    
    [DataRequest release];
    [RequestTest release];
}

- (IBAction)EventReloadSelected
{
    [ErrorView setHidden:TRUE];
    [self LoadScoreboardData];
}

// Parses the scoreboard response message
- (NSArray*) ParseResponse:(NSData*)ResponseData
{
    NSArray         *   ParsedResult        = nil;
    NSMutableArray  *   ParsedResponse      = nil;
    ScoreboardData  *   ParsedRecord        = nil;
    NSString        *   ResponseText        = nil,
                    *   CurrRecordText      = nil,
                    *   MessageHeader       = nil;
    NSRange             DataStart;
    
    ResponseText = [[NSString alloc] initWithData:ResponseData encoding:NSUTF8StringEncoding];
    
    if (m_CurrType == ScoreboardTypeHunt)
    {
        MessageHeader = TAG_MESSAGE_START_HUNT;
    }
    else
    {
        MessageHeader = TAG_MESSAGE_START_USER;
    }
        
    if ([ResponseText rangeOfString:MessageHeader].location !=NSNotFound)
    {
        ParsedResponse = [[NSMutableArray alloc] init];
        
        ResponseText = [ResponseText substringFromIndex:[ResponseText rangeOfString:MessageHeader].location+MessageHeader.length];
        ResponseText = [ResponseText substringToIndex:ResponseText.length-1];
        
        if (![ResponseText isEqualToString:EMPTY_DATA])
        {
            DataStart = [ResponseText rangeOfString:OPEN_BRACKET];
            
            while (DataStart.location != NSNotFound)
            {
                CurrRecordText = [ResponseText substringFromIndex:DataStart.location+1];
                CurrRecordText = [CurrRecordText substringToIndex:[CurrRecordText rangeOfString:CLOSE_BRACKET].location];
                
                ParsedRecord = [self ParseRecord:CurrRecordText];
                
                if (ParsedRecord)
                {
                    [ParsedResponse addObject:ParsedRecord];
                }
                
                ResponseText = [ResponseText substringFromIndex:CurrRecordText.length + DataStart.location + 2];
                DataStart = [ResponseText rangeOfString:OPEN_BRACKET];
            }
            
        }
        
        if (ParsedResponse.count > 0)
        {
            ParsedResult = [NSArray arrayWithArray:ParsedResponse];
        }
        
        [ParsedResponse release];
    }
    else
    {
        [self DisplayErrorMessage:@"Unexpected Error!"];
    }
    
    return ParsedResult;
}

// Parses the data for a single record in the response mesasge
- (ScoreboardData*) ParseRecord:(NSString*)RecordData
{
    int             Place       = -1,
                    Points      = -1,
                    Id          = -1;
    NSString    *   Name        = nil,
                *   CurrData    = nil;
    BOOL            IsUser      = FALSE;
    NSRange         DataRange;
    
    if (m_CurrType == ScoreboardTypeHunt)
    {    
        DataRange = [RecordData rangeOfString:TAG_DATA_PLACE];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_PLACE.length];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location];
            Place = [CurrData intValue];
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_USERID];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_USERID.length];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location];
            Id = [CurrData intValue];        
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_USERNAME];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_USERNAME.length + 1];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location - 1];
            
            if (CurrData.length > 0)
            {
                Name = [NSString stringWithString:CurrData];
            }
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_POINTS];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_POINTS.length];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location];
            Points = [CurrData intValue];
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_IS_USER];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_IS_USER.length];
            IsUser = [CurrData boolValue];
        }
    }
    else
    {
        DataRange = [RecordData rangeOfString:TAG_DATA_HUNT_RANK];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_HUNT_RANK.length];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location];
            Place = [CurrData intValue];
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_HUNT_NAME];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_HUNT_NAME.length + 1];
            CurrData = [CurrData substringToIndex:[CurrData rangeOfString:COMMA].location - 1];
            
            if (CurrData.length > 0)
            {
                Name = [NSString stringWithString:CurrData];
            }
        }
        
        DataRange = [RecordData rangeOfString:TAG_DATA_POINTS];
        if (DataRange.location != NSNotFound)
        {
            CurrData = [RecordData substringFromIndex:DataRange.location + TAG_DATA_POINTS.length];
            Points = [CurrData intValue];
        }
    }
    
    return [[[ScoreboardData alloc] initWithPlace:Place andId:Id andName:Name andScore:Points andIsUser:IsUser] autorelease];
}

- (void) DisplayErrorMessage:(NSString*)Message
{
    CurrRefreshStatus = TTTableHeaderDragRefreshPullToReload;
    [RefreshView setStatus:CurrRefreshStatus];
    
    if (m_ScoreboardData)
    {
        [m_ScoreboardData release];
        m_ScoreboardData = nil;
    }
    
    [Scoreboard reloadData];
    
    [LoadingView setHidden:TRUE];
    [ErrorView setHidden:FALSE];
    [ErrorTitle setText:Message];
}
//-------------------------------------------------------------------------------------
#pragma mark -
#pragma mark NSURLConnection Delegate
//-------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [m_ResponseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [m_ResponseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [m_ResponseData release];
    m_ResponseData = nil;
    
    [self DisplayErrorMessage:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{    
    m_ScoreboardData = [[self ParseResponse:m_ResponseData] retain];

    CurrRefreshStatus = TTTableHeaderDragRefreshPullToReload;
    [RefreshView setStatus:CurrRefreshStatus];
    [RefreshView setUpdateDate:[NSDate date]];
    
    [LoadingView setHidden:TRUE];
    [Scoreboard reloadData];

    [m_ResponseData release];
    m_ResponseData = nil;
}

//-------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Tableview Delegate/Datasource
//-------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nRowCount = 0;
    
    if (m_ScoreboardData)
    {
        nRowCount = m_ScoreboardData.count;
        [tableView setHidden:FALSE];
        [tableView setScrollEnabled:TRUE];
        m_DataLoaded = TRUE;
        
        if (TableFooter)
        {
            [TableFooter removeFromSuperview];
            [TableFooter release];
            TableFooter = nil;
        }
        
        TableFooter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 40.0f * nRowCount, self.view.frame.size.width, 320.0f)];
        
        if (nRowCount % 2 == 0)
        {
            [TableFooter setImage:[UIImage imageNamed:@"LeaderBoardBackgroundLight.png"]];
        }
        else
        {
            [TableFooter setImage:[UIImage imageNamed:@"LeaderBoardBackgroundDark.png"]];
        }
        
        [Scoreboard addSubview:TableFooter];
    }
    else 
    {
        nRowCount = 5;
        [tableView setHidden:TRUE];
        [tableView setScrollEnabled:FALSE];
        m_DataLoaded = FALSE;
    }
    

    
    return nRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * TheCell           = nil;
    UIView          * CellBackground    = nil;
    UILabel         * lblRank           = nil,
                    * lblName           = nil,
                    * lblPoints         = nil;
    NSString        * strCellIdentifier = nil;
    ScoreboardData  * currData          = nil;
    
    if (indexPath.row % 2 == 0)
    {
        strCellIdentifier = CELL_IDENTIFIER_A;
    }
    else
    {
        strCellIdentifier = CELL_IDENTIFIER_B;
    }
    
    TheCell = [tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
    
    if (!TheCell)
    {
        TheCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier] autorelease];
        
        CellBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, TheCell.frame.size.width, 40.0f)];
        [CellBackground setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        if (indexPath.row % 2 == 0)
        {
            [CellBackground setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        }
        else
        {
            [CellBackground setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        }
        
        lblRank = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 10.0f, 38.0f, 21.0f)];
        [lblRank setBackgroundColor:[UIColor clearColor]];
        [lblRank setAdjustsFontSizeToFitWidth:FALSE];
        [lblRank setTag:TAG_LABEL_RANK];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(73.0f, 10.0f, 175.0f, 21.0f)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setAdjustsFontSizeToFitWidth:FALSE];
        [lblName setTag:TAG_LABEL_NAME];
        
        lblPoints = [[UILabel alloc] initWithFrame:CGRectMake(265.0f, 10.0f, 31.0f, 21.0f)];
        [lblPoints setBackgroundColor:[UIColor clearColor]];
        [lblPoints setAdjustsFontSizeToFitWidth:FALSE];
        [lblPoints setTextAlignment:UITextAlignmentRight];
        [lblPoints setTag:TAG_LABEL_POINTS];        
        
        [TheCell setBackgroundView:CellBackground];
        [TheCell.contentView addSubview:lblRank];
        [TheCell.contentView addSubview:lblPoints];
        [TheCell.contentView addSubview:lblName];
        
        [CellBackground release];
        [lblRank        release];
        [lblName        release];
        [lblPoints      release];
    }
    
    currData = [m_ScoreboardData objectAtIndex:indexPath.row];
    
    lblRank = (UILabel*) [TheCell.contentView viewWithTag:TAG_LABEL_RANK];
    lblName = (UILabel*) [TheCell.contentView viewWithTag:TAG_LABEL_NAME];
    lblPoints = (UILabel*) [TheCell.contentView viewWithTag:TAG_LABEL_POINTS];
    
    if (m_DataLoaded)
    {
        [lblRank setText:[NSString stringWithFormat:@"%i", currData.Place]];
        [lblPoints setText:[NSString stringWithFormat:@"%i", currData.Score]];
        if (currData.Name)
        {
            [lblName setText:currData.Name];
        }
        else 
        {
            [lblName setText:[NSString stringWithFormat:@"Lavahound User %i", currData.Id]];
        }
        
        if (currData.IsUser)
        {
            [lblRank    setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [lblName    setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [lblPoints  setFont:[UIFont boldSystemFontOfSize:14.0f]];
        }
        else
        {
            [lblRank    setFont:[UIFont systemFontOfSize:14.0f]];
            [lblName    setFont:[UIFont systemFontOfSize:14.0f]];
            [lblPoints  setFont:[UIFont systemFontOfSize:14.0f]];
        }
    }
    else 
    {
        [lblRank    setText:nil];
        [lblName    setText:nil];
        [lblPoints  setText:nil];
    }
    
    
    
    return TheCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y <= RefreshView.frame.origin.y) && (CurrRefreshStatus == TTTableHeaderDragRefreshPullToReload))
    {
        CurrRefreshStatus = TTTableHeaderDragRefreshReleaseToReload;
        [RefreshView setStatus:CurrRefreshStatus];
    }
    else if ((scrollView.contentOffset.y >= RefreshView.frame.origin.y) && (CurrRefreshStatus == TTTableHeaderDragRefreshReleaseToReload))
    {
        CurrRefreshStatus = TTTableHeaderDragRefreshPullToReload;
        [RefreshView setStatus:CurrRefreshStatus];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (CurrRefreshStatus == TTTableHeaderDragRefreshReleaseToReload)
    {
        CurrRefreshStatus = TTTableHeaderDragRefreshLoading;
        [RefreshView setStatus:CurrRefreshStatus];
        [self LoadScoreboardData];
    }
}

@end