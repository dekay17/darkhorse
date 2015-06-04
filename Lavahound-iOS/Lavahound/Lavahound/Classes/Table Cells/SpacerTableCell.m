//
//  SpacerTableCell.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SpacerTableCell.h"

@implementation SpacerTableItem

@synthesize height = _height;

+ (SpacerTableItem *)spacerTableItemWithHeight:(CGFloat)height {
    SpacerTableItem *spacerTableItem = [[[SpacerTableItem alloc] init] autorelease];
    spacerTableItem.height = height;
    return spacerTableItem;
}

@end


@implementation SpacerTableCell

#pragma mark -
#pragma mark TTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    SpacerTableItem *spacerTableItem = (SpacerTableItem *)object;
    return spacerTableItem.height;
}

@end