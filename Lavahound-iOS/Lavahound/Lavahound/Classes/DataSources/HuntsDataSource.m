//
//  HuntsDataSource.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntsDataSource.h"
#import "Place.h"
#import "Hunt.h"
#import "SpacerTableCell.h"
#import "PlaceTableCell.h"
#import "HuntPlaceTableCell.h"
#import "HuntTableCell.h"

@implementation HuntsDataSource

#pragma mark -
#pragma mark NSObject

- (id)initWithPlaceId:(NSNumber *)placeId {
    if ((self = [super init]))
        _huntsModel = [[HuntsModel alloc] initWithPlaceId:placeId];
	
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_huntsModel);
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[SpacerTableItem class]])
        return [SpacerTableCell class];      
    if([object isKindOfClass:[HuntTableItem class]])
        return [HuntTableCell class];  
    if([object isKindOfClass:[PlaceTableItem class]])
        return [HuntPlaceTableCell class];      
    return [super tableView:tableView cellClassForObject:object];
}

- (id<TTModel>)model {
    return _huntsModel;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    Place *place = _huntsModel.place;
    
    [items addObject:[SpacerTableItem spacerTableItemWithHeight:8]];
    
    PlaceTableItem *item = [[[PlaceTableItem alloc] init] autorelease];                
    item.userInfo = place;
    [items addObject:item];  
    [items addObject:[SpacerTableItem spacerTableItemWithHeight:8]];    
    
    for(Hunt *hunt in _huntsModel.hunts) {
        HuntTableItem *item = [[[HuntTableItem alloc] init] autorelease];                
        item.hunt = hunt;
        item.place = place;        
        [items addObject:item];  
        [items addObject:[SpacerTableItem spacerTableItemWithHeight:5]];
    }
    
    [items addObject:[SpacerTableItem spacerTableItemWithHeight:8]];    
    
    self.items = items;
}

- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading hunts...";  
}

- (NSString*)titleForEmpty {
	return @"No hunts were found.";
}

- (NSString*)subtitleForError:(NSError*)error {
	return @"Sorry, there was an error loading hunts.";
}

@end