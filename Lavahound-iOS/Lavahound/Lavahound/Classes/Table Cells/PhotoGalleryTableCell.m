//
//  PhotoGalleryTableCell.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoGalleryTableCell.h"

static CGFloat const kRowHeight = 120;

@implementation PhotoGalleryTableCell

#pragma mark -
#pragma mark NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {    
        _photoGalleryGroupView = [[PhotoGalleryGroupView alloc] init];
        [self.contentView addSubview:_photoGalleryGroupView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_photoGalleryGroupView);
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
	return kRowHeight;
}

- (void)setObject:(id)object {  
	if (self.object != object) {    
		[super setObject:object]; 
        
        TTTableItem *item = object;
        NSArray *photos = item.userInfo;
        _photoGalleryGroupView.photos = photos;
    }
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    _photoGalleryGroupView.frame = self.contentView.frame;
}

@end