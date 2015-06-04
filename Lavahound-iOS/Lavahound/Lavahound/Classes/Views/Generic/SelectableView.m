//
//  SelectableView.m
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SelectableView.h"

static const NSTimeInterval kDefaultDeselectDelay = 0.4;
static const NSTimeInterval kSelectPressDetectionDuration = 0.2;
static const CGFloat kSelectPressAllowableMovement = 3;
static const CGFloat kDefaultOverlayAlpha = 0.3;

@implementation SelectableView

@synthesize selectionEnabled = _selectionEnabled, delegate = _delegate;

#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame {
	if((self = [super initWithFrame:frame])) {
        _delegate = nil;
        _selectionEnabled = YES;
        
		_selectedOverlayView = [[UIView alloc] init];    
        _selectedOverlayView.backgroundColor = [UIColor blackColor];
        _selectedOverlayView.alpha = kDefaultOverlayAlpha;
        _selectedOverlayView.hidden = YES;
        [self addSubview:_selectedOverlayView];    
        
        UITapGestureRecognizer *tapGestureRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)] autorelease];
		[self addGestureRecognizer:tapGestureRecognizer];		    
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressView:)] autorelease];    
        longPressGestureRecognizer.minimumPressDuration = kSelectPressDetectionDuration;
        longPressGestureRecognizer.allowableMovement = kSelectPressAllowableMovement;
        [self addGestureRecognizer:longPressGestureRecognizer];    
    }
	
	return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_selectedOverlayView);
	[super dealloc];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [self bringSubviewToFront:_selectedOverlayView];
    _selectedOverlayView.frame = self.bounds;
}

#pragma mark -
#pragma mark SelectableView

- (void)deselectAfterDelay {
    [self performSelector:@selector(deselectAfterDelayCallback:)
               withObject:nil
               afterDelay:kDefaultDeselectDelay];    
}

- (void)deselectAfterDelayCallback:(id)ignored {
    self.selected = NO;
}

- (BOOL)selected {
    return !_selectedOverlayView.hidden;
}

- (void)setSelected:(BOOL)selected {
    _selectedOverlayView.hidden = !selected;
}

- (void)didPressView:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if(!_selectionEnabled) {
        TTDPRINT("Selection disabled, ignoring press event.");
        return;
    }
    
    if(UIGestureRecognizerStateBegan == longPressGestureRecognizer.state) {
        TTDPRINT(@"Press started on %@", self);      
        self.selected = YES;
	} else if(UIGestureRecognizerStateEnded == longPressGestureRecognizer.state) {
        TTDPRINT(@"Press ended on %@", self);
        [_delegate didSelectView:self];
    }
}

- (void)didTapView:(UITapGestureRecognizer *)tapGestureRecognizer {  
    if(!_selectionEnabled) {
        TTDPRINT("Selection disabled, ignoring tap event.");
        return;
    }
    
    if(UIGestureRecognizerStateEnded == tapGestureRecognizer.state) {
        TTDPRINT(@"Tapped %@", self);       
        self.selected = YES;
        [_delegate didSelectView:self];    
    }
}

@end