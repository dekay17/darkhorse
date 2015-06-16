//
//  MyStuffHomeController.m
//  Lavahound
//
//  Created by Russak Nathan on 2/23/12.
//  Copyright (c) 2012 LavaHound. All rights reserved.
//

#import "MyStuffHomeController.h"
#import "UIViewController+Lavahound.h"
#import "LavahoundEmailer.h"

@implementation MyStuffHomeController

static NSString * const CELL_IDENTIFIER_A   = @"CellIdentifierLight";
static NSString * const CELL_IDENTIFIER_B   = @"CellIdentifierDark";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self initializeLavahoundNavigationBarWithTitle:@"my stuff"];

        self.tabBarItem.image = TTIMAGE(@"bundle://tabBarAbout.png");
        self.tabBarItem.title = @"About";
        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    UITableView * TheTable      = nil;
    UIImageView * TableHeader   = nil,
                * TableFooter   = nil;
    
    [super viewDidLoad];
    
    TheTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    [TheTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [TheTable setDelegate:self];
    [TheTable setDataSource:self];
    
    TableHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, 320.0f, 320.0f)];
    [TableHeader setImage:[UIImage imageNamed:@"LeaderBoardBackgroundLight.png"]];
    TableFooter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 360.0f, 320.0f, 320.0f)];
    [TableFooter setImage:[UIImage imageNamed:@"LeaderBoardBackgroundDark.png"]];
    
    [TheTable addSubview:TableHeader];
    [TheTable addSubview:TableFooter];
    
    [self.view addSubview:TheTable];
    
    [TheTable release];
    [TableHeader release];
    [TableFooter release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * TheCell           = nil;
    UIView          * CellBackground    = nil;
    NSString        * strCellIdentifier = nil;
    
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
        
        [TheCell setBackgroundView:CellBackground];
        [TheCell.textLabel setBackgroundColor:[UIColor clearColor]];
        [TheCell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        
        [CellBackground release];
    }
    
    if (indexPath.row <2)
    {
        [TheCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [TheCell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        if (indexPath.row == 0)
        {
            [TheCell.textLabel setText:@"About Lavahound"];
        }
//        else if (indexPath.row == 1)
//        {
//            [TheCell.textLabel setText:@"My Profile"];
//        }
        
        else if (indexPath.row == 1)
        {
            [TheCell setAccessoryType:UITableViewCellAccessoryNone];
            [TheCell .textLabel setText:@"Logout"];
        }
        
//        if (indexPath.row == 0)
//        {
//            [TheCell.textLabel setText:@"My Points"];
//        }
//        else if (indexPath.row == 1)
//        {
//            [TheCell.textLabel setText:@"My Profile"];
//        }
//        else if (indexPath.row == 2)
//        {
//            [TheCell.textLabel setText:@"About Lavahound"];
//        }
//        else if (indexPath.row == 3)
//        {
//            [TheCell.textLabel setText:@"Admin"];
//        }
//        else if (indexPath.row == 4)
//        {
//            [TheCell setAccessoryType:UITableViewCellAccessoryNone];
//            [TheCell .textLabel setText:@"Logout"];
//        }
    }
    else
    {
        [TheCell.textLabel setText:nil];
        [TheCell setAccessoryType:UITableViewCellAccessoryNone];
        [TheCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return TheCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreboardController * MyPoints = nil;
    AdminController * AdminView = nil;

    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
//        if (indexPath.row == 1)
//        {
//            [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://profile"] applyAnimated:YES]];
//        }
//        else
            if (indexPath.row == 0)
        {
            [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://about"] applyAnimated:YES]];
        }
        else if (indexPath.row == 1)
        {
            UIAlertView * Alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"Really sign out?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Confirm", nil];
    
            [Alert show];
            [Alert release];
        }
    
//    if (indexPath.row == 0)
//    {
//        MyPoints = [[ScoreboardController alloc] initWithUser];
//        
//        [self.navigationController pushViewController:MyPoints animated:TRUE];
//        
//        [MyPoints release];
//    }
//    else if (indexPath.row == 1)
//    {
//        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://profile"] applyAnimated:YES]];
//    }
//    else if (indexPath.row == 2)
//    {
//        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://about"] applyAnimated:YES]];
//    }
//    else if (indexPath.row == 3)
//    {
//        AdminView = [[AdminController alloc] init];
//        [self.navigationController pushViewController:AdminView animated:TRUE];
//    }
//    else if (indexPath.row == 4)
//    {
//        UIAlertView * Alert = [[UIAlertView alloc] initWithTitle:nil
//                                                         message:@"Really sign out?"
//                                                        delegate:self
//                                               cancelButtonTitle:@"Cancel"
//                                               otherButtonTitles:@"Confirm", nil];
//        
//        [Alert show];
//        [Alert release];
//    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [LocalStorage sharedInstance].apiToken = nil;
        [LocalStorage sharedInstance].facebookOAuthToken = nil;
        [[TTNavigator navigator] removeAllViewControllers];
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://welcome"] applyAnimated:NO]];
    }
}

@end
