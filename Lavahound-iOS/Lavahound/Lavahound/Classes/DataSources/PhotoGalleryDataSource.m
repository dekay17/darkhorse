//
//  NearbyPhotosDataSource.m
//  Lavahound
//
//  Created by Mark Allen on 5/12/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoGalleryDataSource.h"
#import "PhotoGalleryTableCell.h"
#import "Photo.h"
#import "NearbyPhotosModel.h"
#import "HuntPhotosModel.h"

static CGFloat const kMaxPhotosPerRow = 3;

@implementation PhotoGalleryDataSource

#pragma mark -
#pragma mark NSObject

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init]))
        _photosModel = [[NearbyPhotosModel alloc] initWithCoordinate:coordinate];
	
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate huntId:(NSNumber *)huntId {
    if ((self = [super init]))
        _photosModel = [[HuntPhotosModel alloc] initWithCoordinate:coordinate huntId:huntId];
	
    return self;    
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photosModel);
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewDataSource

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if([object isKindOfClass:[TTTableItem class]])
        return [PhotoGalleryTableCell class];
    return [super tableView:tableView cellClassForObject:object];
}

- (id<TTModel>)model {
    return _photosModel;
}

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    NSArray *photos = _photosModel.photos;
    NSUInteger photosCount = [photos count];
    NSUInteger itemsCount = ceil(photosCount / kMaxPhotosPerRow);
    
    TTDPRINT(@"There are %d photo[s], which translates into %d row[s]", photosCount, itemsCount);

    // Break the data down into groupings of at most 3 photos per row.
    for(NSUInteger i = 0; i < itemsCount; i++) {
        NSMutableArray *photosForRow = [[[NSMutableArray alloc] initWithCapacity:kMaxPhotosPerRow] autorelease];
        
        for(NSUInteger j = i * kMaxPhotosPerRow; j < i * kMaxPhotosPerRow + kMaxPhotosPerRow && j < photosCount; j++)
            [photosForRow addObject:[photos objectAtIndex:j]];
        
        TTTableItem *item = [[[TTTableItem alloc] init] autorelease];                
        item.userInfo = photosForRow;
        [items addObject:item];  
    }

    self.items = items;
}

- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading photos...";  
}

- (NSString*)titleForEmpty {
	return @"No photos were found.";
}

- (NSString*)subtitleForError:(NSError*)error {
	return @"Sorry, there was an error loading photos.";
}

@end