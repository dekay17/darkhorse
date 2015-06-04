//
//  PlaceTableCell.m
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PlaceTableCell.h"
#import "Place.h"

static CGFloat const kRowHeight = 79;

@implementation PlaceTableItem
@end


@implementation PlaceTableCell

#pragma mark -
#pragma mark NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {    
        _place = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *placeButtonBackgroundImage = TTIMAGE(@"bundle://huntBG.png");
        _placeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _placeButton.frame = CGRectMake(0, 0, placeButtonBackgroundImage.size.width, placeButtonBackgroundImage.size.height);
        [_placeButton setBackgroundImage:placeButtonBackgroundImage forState:UIControlStateNormal];        
        [_placeButton addTarget:self action:@selector(didTouchUpInsidePlaceButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_placeButton];
        
        _placeNameLabel = [[UILabel alloc] init];
        _placeNameLabel.backgroundColor = [UIColor clearColor];  
        _placeNameLabel.font = [UIFont systemFontOfSize:15];
        [_placeButton addSubview:_placeNameLabel];
        
        _placeImageView = [[LoadingAwareImageView alloc] init];
        _placeImageView.userInteractionEnabled = NO;
        [_placeButton addSubview:_placeImageView];
        
        _placeProximityDescriptionLabel = [[UILabel alloc] init];
        _placeProximityDescriptionLabel.font = [UIFont systemFontOfSize:13];
        _placeProximityDescriptionLabel.textColor = [UIColor grayColor];    
        _placeProximityDescriptionLabel.backgroundColor = [UIColor clearColor];
        [_placeButton addSubview:_placeProximityDescriptionLabel];
        
        _placeHuntCountLabel = [[UILabel alloc] init];
        _placeHuntCountLabel.font = [UIFont systemFontOfSize:13];
        _placeHuntCountLabel.textAlignment = UITextAlignmentCenter;
        _placeHuntCountLabel.textColor = [UIColor whiteColor];
        _placeHuntCountLabel.backgroundColor = RGBCOLOR(173, 41, 0);
        _placeHuntCountLabel.layer.cornerRadius = 5;
        [_placeButton addSubview:_placeHuntCountLabel];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_place);
    TT_RELEASE_SAFELY(_placeButton);    
    TT_RELEASE_SAFELY(_placeNameLabel);
    TT_RELEASE_SAFELY(_placeImageView);
    TT_RELEASE_SAFELY(_placeProximityDescriptionLabel);
    TT_RELEASE_SAFELY(_placeHuntCountLabel);
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
        Place *place = item.userInfo;
        
        if(place != _place) {
            TT_RELEASE_SAFELY(_place);
            _place = [place retain];
        }
        
        _placeImageView.imageUrl = place.imageUrl;
        _placeNameLabel.text = place.name;
        _placeProximityDescriptionLabel.text = place.proximityDescription;
        _placeHuntCountLabel.text = [NSString stringWithFormat:@"%@ %@", place.huntCount, [place.huntCount intValue] == 1 ? @"Hunt" : @"Hunts"];
    }
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    _placeButton.left = floorf((self.contentView.width - _placeButton.width) / 2);    
    _placeImageView.frame = CGRectMake(8, 7, 76, 63);    
    _placeNameLabel.frame = CGRectMake(_placeImageView.right + 8, 14, 190, 20);    
    _placeHuntCountLabel.frame = CGRectMake(_placeNameLabel.left, _placeNameLabel.bottom + 6, 58, 22);    
    _placeProximityDescriptionLabel.frame = CGRectMake(_placeHuntCountLabel.right + 10, _placeHuntCountLabel.top, 100, 22);
}

#pragma mark -
#pragma mark PlaceTableCell

- (void)didTouchUpInsidePlaceButton {
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[_place URLValueWithName:@"hunts"]] applyAnimated:YES]];
}

@end