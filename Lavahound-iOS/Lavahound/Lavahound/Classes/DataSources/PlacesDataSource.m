//
//  PlacesDataSource.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PlacesDataSource.h"
#import "PlaceTableCell.h"
#import "Place.h"
#import "SpacerTableCell.h"

@implementation PlacesDataSource

#pragma mark -
#pragma mark NSObject

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init]))
        _nearbyPlacesModel = [[NearbyPlacesModel alloc] initWithCoordinate:coordinate];
	
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_nearbyPlacesModel);
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[SpacerTableItem class]])
        return [SpacerTableCell class];      
    if([object isKindOfClass:[PlaceTableItem class]])
        return [PlaceTableCell class];  
    return [super tableView:tableView cellClassForObject:object];
}

- (id<TTModel>)model {
    return _nearbyPlacesModel;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    NSArray *places = _nearbyPlacesModel.places;
    
    [items addObject:[SpacerTableItem spacerTableItemWithHeight:8]];
    
    for(Place *place in places) {
        PlaceTableItem *item = [[[PlaceTableItem alloc] init] autorelease];                
        item.userInfo = place;
        [items addObject:item];  
        [items addObject:[SpacerTableItem spacerTableItemWithHeight:5]];
    }

    [items addObject:[SpacerTableItem spacerTableItemWithHeight:8]];    
    
    self.items = items;
}

- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading nearby hunts...";  
}

- (NSString*)titleForEmpty {
	return @"No nearby hunts were found.";
}

- (NSString*)subtitleForError:(NSError*)error {
	return @"Sorry, there was an error loading hunts.";
}

@end