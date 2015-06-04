//
//  HuntTableCell.m
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HuntTableCell.h"
#import "NSString+Lavahound.h"

static CGFloat const kRowHeight = 79;

@implementation HuntTableItem

@synthesize hunt = _hunt, place = _place;

#pragma mark -
#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        _hunt = nil;
        _place = nil;
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_hunt);
    TT_RELEASE_SAFELY(_place);    
    [super dealloc];
}

@end


@implementation HuntTableCell

#pragma mark -
#pragma mark NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {    
        _hunt = nil;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *huntButtonBackgroundImage = TTIMAGE(@"bundle://huntHomeHuntsBG.png");
        _huntButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _huntButton.frame = CGRectMake(0, 0, huntButtonBackgroundImage.size.width, huntButtonBackgroundImage.size.height);
        [_huntButton setBackgroundImage:huntButtonBackgroundImage forState:UIControlStateNormal];        
        [_huntButton addTarget:self action:@selector(didTouchUpInsideHuntButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_huntButton];
        
        _huntNameLabel = [[UILabel alloc] init];
        _huntNameLabel.backgroundColor = [UIColor clearColor];        
        _huntNameLabel.font = [UIFont systemFontOfSize:14];
        [_huntButton addSubview:_huntNameLabel];
        
        _huntImageView = [[LoadingAwareImageView alloc] init];
        _huntImageView.userInteractionEnabled = NO;
        [_huntButton addSubview:_huntImageView];
        
        _huntProximityDescriptionLabel = [[UILabel alloc] init];
        _huntProximityDescriptionLabel.backgroundColor = [UIColor clearColor];    
        _huntProximityDescriptionLabel.textColor = [UIColor grayColor];
        _huntProximityDescriptionLabel.font = [UIFont systemFontOfSize:12];
        [_huntButton addSubview:_huntProximityDescriptionLabel];
        
        _huntFoundCountLabel = [[UILabel alloc] init];
        _huntFoundCountLabel.backgroundColor = [UIColor clearColor];        
        _huntFoundCountLabel.font = [UIFont systemFontOfSize:12];
        _huntFoundCountLabel.textAlignment = UITextAlignmentCenter;
        [_huntButton addSubview:_huntFoundCountLabel];
        
        _huntTotalCountLabel = [[UILabel alloc] init];
        _huntTotalCountLabel.backgroundColor = [UIColor clearColor];       
        _huntTotalCountLabel.font = [UIFont systemFontOfSize:12];        
        [_huntButton addSubview:_huntTotalCountLabel];        
        
        _progressBarBackgroundView = [[UIView alloc] init];
        _progressBarBackgroundView.layer.cornerRadius = 5;
        _progressBarBackgroundView.layer.borderColor = [[UIColor grayColor] CGColor];
        _progressBarBackgroundView.layer.borderWidth = 1;
        [_huntButton addSubview:_progressBarBackgroundView];     
               
        _progressBarForegroundView = [[UIView alloc] init];
        _progressBarForegroundView.layer.cornerRadius = 5;
        _progressBarForegroundView.layer.borderColor = [[UIColor grayColor] CGColor];
        _progressBarForegroundView.layer.borderWidth = 1;
        _progressBarForegroundView.backgroundColor = RGBCOLOR(173, 41, 0);
        [_huntButton addSubview:_progressBarForegroundView];          
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_hunt);
    TT_RELEASE_SAFELY(_huntButton);    
    TT_RELEASE_SAFELY(_huntNameLabel);
    TT_RELEASE_SAFELY(_huntImageView);
    TT_RELEASE_SAFELY(_huntProximityDescriptionLabel);
    TT_RELEASE_SAFELY(_huntFoundCountLabel);
    TT_RELEASE_SAFELY(_huntTotalCountLabel);
    TT_RELEASE_SAFELY(_progressBarBackgroundView);
    TT_RELEASE_SAFELY(_progressBarForegroundView);        
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
        
        HuntTableItem *item = object;            
        Hunt *hunt = item.hunt;
        Place *place = item.place;
        
        if(hunt != _hunt) {
            TT_RELEASE_SAFELY(_hunt);
            _hunt = [hunt retain];
        }
        
        if(place != _place) {
            TT_RELEASE_SAFELY(_place);
            _place = [place retain];
        }        
        
        _huntImageView.imageUrl = hunt.imageUrl;
        _huntNameLabel.text = hunt.name;
        _huntProximityDescriptionLabel.text = hunt.proximityDescription;
        _huntFoundCountLabel.text = [hunt.foundCount description];
        _huntTotalCountLabel.text = [hunt.totalCount description];
    }
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    _huntButton.left = floorf((self.contentView.width - _huntButton.width) / 2);    
    _huntImageView.frame = CGRectMake(8, 7, 76, 63);    
    _huntNameLabel.frame = CGRectMake(_huntImageView.right + 8, 10, 180, 18);    
    _huntProximityDescriptionLabel.frame = CGRectMake(_huntNameLabel.left, _huntNameLabel.bottom + 2, _huntNameLabel.width, 16);
    
    CGSize huntFoundCountLabelSize = !_huntFoundCountLabel.text ? CGSizeMake(0, 0) : 
        [_huntFoundCountLabel.text sizeWithFont:_huntFoundCountLabel.font
                            constrainedToSize:CGSizeMake(14, 14) 
                                lineBreakMode:_huntFoundCountLabel.lineBreakMode];
    
    _huntFoundCountLabel.frame = CGRectMake(_huntProximityDescriptionLabel.left, _huntProximityDescriptionLabel.bottom + 4, huntFoundCountLabelSize.width, 14);
    
    _progressBarBackgroundView.frame = CGRectMake(_huntFoundCountLabel.right + 4, _huntFoundCountLabel.top + 3, 138, 8);
    _huntTotalCountLabel.frame = CGRectMake(_progressBarBackgroundView.right + 4, _huntFoundCountLabel.top, 14, _huntFoundCountLabel.height);    
    
    if([_hunt.foundCount intValue] > 0) {
        CGFloat foundPercentage = [_hunt.foundCount floatValue] / [_hunt.totalCount floatValue];
        CGFloat progressBarWidth = floorf(foundPercentage * _progressBarBackgroundView.width);
        _progressBarForegroundView.frame = CGRectMake(_progressBarBackgroundView.left, _progressBarBackgroundView.top, progressBarWidth, _progressBarBackgroundView.height);
        _progressBarForegroundView.hidden = NO;        
    } else {
        _progressBarForegroundView.hidden = YES;
    }
}

#pragma mark -
#pragma mark HuntTableCell

- (void)didTouchUpInsideHuntButton {
    NSString *url = [NSString stringWithFormat:@"lavahound://hunt/%@/%@:%@%@", _hunt.huntId, [_place.name urlEncode], [@" " urlEncode], [_hunt.name urlEncode]];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];
}

@end