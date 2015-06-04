//
//  PointsButton.m
//  Lavahound
//
//  Created by Mark Allen on 7/14/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PointsButton.h"
#import "LocalStorage.h"
#import "Constants.h"

@interface PointsButton(PrivateMethods)

- (BOOL)isLargePointsValue;

@property (nonatomic, readonly) UIFont *labelFont;

@end


@implementation PointsButton

- (id)initWithFrame:(CGRect)frame {
    UIImage *backgroundImage = TTIMAGE(@"bundle://scoreBox.png");    
    frame = CGRectMake(frame.origin.x, frame.origin.y, backgroundImage.size.width, backgroundImage.size.height);
    
    if ((self = [super initWithFrame:frame])) {        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        _pointsLabel = [[UILabel alloc] init];
        _pointsLabel.text = [[LocalStorage sharedInstance].totalPoints description];
        _pointsLabel.font = self.labelFont;
        _pointsLabel.backgroundColor = [UIColor clearColor];
        _pointsLabel.textColor = [UIColor whiteColor];
        _pointsLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_pointsLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiPointsChangedNotification:) 
                                                     name:kLavahoundApiPointsChangedNotification
                                                   object:nil];           
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    TT_RELEASE_SAFELY(_pointsLabel);    
    [super dealloc];
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    _pointsLabel.frame = CGRectMake(26, 0, 34, self.height);
}

#pragma mark -
#pragma mark PointsButton

- (UIFont *)labelFont {
    return [UIFont systemFontOfSize:[self isLargePointsValue] ? 12 : 14];   
}

- (BOOL)isLargePointsValue {    
    return true; // [[LocalStorage sharedInstance].totalPoints length] > 2;
}

- (void)didReceiveLavahoundApiPointsChangedNotification:(NSNotification *)notification {
    // TTDPRINT(@"Received %@, updating PointsButton label...", [notification name]);    
    _pointsLabel.font = self.labelFont;        
    _pointsLabel.text = [LocalStorage sharedInstance].totalPoints;
}

@end