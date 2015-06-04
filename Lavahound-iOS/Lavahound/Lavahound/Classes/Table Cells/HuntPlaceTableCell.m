//
//  HuntPlaceTableCell.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "HuntPlaceTableCell.h"

@implementation HuntPlaceTableCell

#pragma mark -
#pragma mark NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _place = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *placeBackgroundImage = TTIMAGE(@"bundle://huntHomePhotoBG.png");
        _placeBackgroundImageView = [[UIImageView alloc] initWithImage:placeBackgroundImage];
        _placeBackgroundImageView.frame = CGRectMake(0, 0, placeBackgroundImage.size.width, placeBackgroundImage.size.height);
        [self.contentView addSubview:_placeBackgroundImageView];
        
        _placeImageView = [[LoadingAwareImageView alloc] init];
        [self.contentView addSubview:_placeImageView];
        
        _placeDescriptionLabel = [[UILabel alloc] init];
        _placeDescriptionLabel.font = [UIFont systemFontOfSize:13];    
        _placeDescriptionLabel.backgroundColor = [UIColor clearColor];
        _placeDescriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _placeDescriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:_placeDescriptionLabel];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_place);
    TT_RELEASE_SAFELY(_placeBackgroundImageView);
    TT_RELEASE_SAFELY(_placeImageView);
    TT_RELEASE_SAFELY(_placeDescriptionLabel);
    [super dealloc];
}

#pragma mark -
#pragma mark TTTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    TTTableItem *item = object;            
    Place *place = item.userInfo;
    
    // TODO: don't hardcode these!
    CGSize placeDescriptionLabelSize = !place.description ? CGSizeMake(0, 0) : 
        [place.description sizeWithFont:[UIFont systemFontOfSize:13]
                      constrainedToSize:CGSizeMake(295, 700)
                          lineBreakMode:UILineBreakModeWordWrap];
    
    return 8 + 197 + 8 + placeDescriptionLabelSize.height;
}

- (void)setObject:(id)object {  
	if (self.object != object) {    
		[super setObject:object]; 
        
        TTTableItem *item = object;            
        Place *place = item.userInfo;
        
        if(place != _place) {
            TT_RELEASE_SAFELY(_place);
            _place = [place retain];
        }
        
        _placeImageView.imageUrl = place.imageUrl;
        _placeDescriptionLabel.text = place.description;
    }
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    _placeBackgroundImageView.frame = CGRectMake(floorf((self.contentView.width - _placeBackgroundImageView.width) / 2), 8, _placeBackgroundImageView.width, _placeBackgroundImageView.height);    
    
    _placeImageView.frame = CGRectMake(_placeBackgroundImageView.left + 3, _placeBackgroundImageView.top + 3,
                                       _placeBackgroundImageView.width - 6, _placeBackgroundImageView.height - 6);
    
    CGSize placeDescriptionLabelSize = !_placeDescriptionLabel.text ? CGSizeMake(0, 0) : 
        [_placeDescriptionLabel.text sizeWithFont:_placeDescriptionLabel.font
                                constrainedToSize:CGSizeMake(_placeBackgroundImageView.width, 700) 
                                    lineBreakMode:_placeDescriptionLabel.lineBreakMode];
    
    _placeDescriptionLabel.frame = CGRectMake(_placeBackgroundImageView.left, _placeBackgroundImageView.bottom + 8, placeDescriptionLabelSize.width, placeDescriptionLabelSize.height);
}

@end