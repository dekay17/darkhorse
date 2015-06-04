//
//  PhotoGalleryView.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoGalleryView.h"
#import "Three20UI/UINSObjectAdditions.h"

const CGFloat kPhotoGalleryViewStandardWidth = 101;
const CGFloat kPhotoGalleryViewStandardHeight = 111;

@implementation PhotoGalleryView

@synthesize photo = _photo;

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
    // Force the frame to be the size of the image
    frame = CGRectMake(frame.origin.x, frame.origin.y, kPhotoGalleryViewStandardWidth, kPhotoGalleryViewStandardHeight);
    
	if((self = [super initWithFrame:frame])) {
        _photo = nil;
        
        self.backgroundColor = [UIColor clearColor];
        
        // Cheap hack: this view listens for taps on itself so it can navigate to the photo detail page
        self.delegate = self;
        
        UIImageView *backgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPhotoGalleryViewStandardWidth, kPhotoGalleryViewStandardHeight)] autorelease];
        backgroundImageView.image = TTIMAGE(@"bundle://galleryImageBG.png");
        [self addSubview:backgroundImageView];
        
		_imageView = [[LoadingAwareImageView alloc] initWithFrame:CGRectZero contentMode:UIViewContentModeCenter];
        [self addSubview:_imageView];
        
        _foundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _foundImageView.image = TTIMAGE(@"bundle://foundBanner.png");
        _foundImageView.hidden = YES;
        _foundImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_foundImageView];
        
        _proximityDescriptionLabel = [[UILabel alloc] init];
        _proximityDescriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];               
        _proximityDescriptionLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:_proximityDescriptionLabel];    
    }
	
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_proximityDescriptionLabel);  
    TT_RELEASE_SAFELY(_imageView);
	TT_RELEASE_SAFELY(_photo);	
    TT_RELEASE_SAFELY(_foundImageView);
	[super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@)", [self class], [_photo description]];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    static CGFloat BorderWidth = 2;
    static CGFloat ProximityDescriptionLabelHeight = 14;
    CGFloat contentWidth = kPhotoGalleryViewStandardWidth - 2 * BorderWidth;        
    
    CGFloat proximityDescriptionLabelTop = self.height - 2 * BorderWidth - ProximityDescriptionLabelHeight;
    
	_imageView.frame = CGRectMake(BorderWidth, BorderWidth + 1, contentWidth, proximityDescriptionLabelTop - 2 * BorderWidth);
    _foundImageView.frame = CGRectMake(0, -2, self.width, self.height);
    _proximityDescriptionLabel.frame = CGRectMake(BorderWidth + 2, proximityDescriptionLabelTop, contentWidth - 2, ProximityDescriptionLabelHeight);
}

#pragma mark -
#pragma mark SelectableViewDelegate

// Cheap hack: this view listens for taps on itself so it can navigate to the photo detail page.
// The alternative is to have a bunch of delegates that keep forwarding the select event back up the chain from
// this view -> PhotoGalleryGroupView -> DataSource -> Controller, or an event raised via NSNotificationCenter (latter option would be better)
- (void)didSelectView:(SelectableView *)selectableView
{
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[_photo URLValueWithName:@"details"]] applyAnimated:YES]];
    
    [self deselectAfterDelay];
}

#pragma mark -
#pragma mark PhotoView

- (void)setPhoto:(Photo *)photo {
    if(photo == _photo)
        return;
    
    TT_RELEASE_SAFELY(_photo);
    _photo = [photo retain];
    
    _imageView.imageUrl = _photo.imageUrl;
    _proximityDescriptionLabel.text = _photo.proximityDescription;
    
    if ([@"GREEN" isEqualToString:_photo.proximityColor])
        _proximityDescriptionLabel.textColor = RGBCOLOR(0, 102, 17);
    else
        _proximityDescriptionLabel.textColor = [UIColor grayColor];
    
    _foundImageView.hidden = !photo.found;
            
    // [self setNeedsLayout];
}

@end