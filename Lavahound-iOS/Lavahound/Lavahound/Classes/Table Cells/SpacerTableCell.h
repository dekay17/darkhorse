//
//  SpacerTableCell.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@interface SpacerTableItem : TTTableItem {
    CGFloat _height;
}

+ (SpacerTableItem *)spacerTableItemWithHeight:(CGFloat)height;

@property (nonatomic, assign) CGFloat height;

@end


@interface SpacerTableCell : UITableViewCell
@end