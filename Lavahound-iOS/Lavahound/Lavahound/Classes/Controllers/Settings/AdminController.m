//
//  AdminController.m
//  Lavahound
//
//  Created by Russak Nathan on 2/28/12.
//  Copyright (c) 2012 LavaHound. All rights reserved.
//

#import "AdminController.h"

@interface AdminController()

@end

@implementation AdminController

- (id) init
{
    self = [super initWithNibName:@"Admin" bundle:nil];
    
    if (self)
    {
        [self initializeLavahoundNavigationBarWithTitle:@"admin"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    UIImageView * TableHeader   = nil,
                * TableFooter   = nil,
                * TableFooter2  = nil;
    
    [super viewDidLoad];
    
    TableHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, 320.0f, 320.0f)];
    [TableHeader setImage:[UIImage imageNamed:@"LeaderBoardBackgroundLight.png"]];
    TableFooter = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 320.0f)];
    [TableFooter setImage:[UIImage imageNamed:@"LeaderBoardBackgroundDark.png"]];
    TableFooter2 = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 360.0f, 320.0f, 320.0f)];
    [TableFooter2 setImage:TableFooter.image];
    
    [TheTable addSubview:TableHeader];
    [TheTable addSubview:TableFooter];
    [TheTable addSubview:TableFooter2];
    
    [TableHeader    release];
    [TableFooter    release];
    [TableFooter2   release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UIView * CellBackground = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        CellBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, 40.0f)];
        [CellBackground setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        if (indexPath.row % 2 == 0)
        {
            [CellBackground setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
        }
        else
        {
            [CellBackground setBackgroundColor:[UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        }
        
        [cell setBackgroundView:CellBackground];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
        
        [CellBackground release];
    }
    
    [cell.textLabel setText:@"Camera"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImagePicker * PickerController = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    PickerController = [[ImagePicker alloc] initWithViewController:self delegate:self];
    [PickerController showFromTabBar:self.tabBarController.tabBar];
    [PickerController release];
}

- (void)imagePicker:(ImagePicker *)imagePicker didPickImage:(UIImage *)image atLocation:(CLLocation *)location
{
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"lavahound://photo-positioning"] applyAnimated:NO]];
}

@end
