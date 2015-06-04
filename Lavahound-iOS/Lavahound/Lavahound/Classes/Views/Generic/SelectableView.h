//
//  SelectableView.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"

@protocol SelectableViewDelegate;

@interface SelectableView : UIView {
    BOOL _selectionEnabled;
    UIView *_selectedOverlayView;
    id<SelectableViewDelegate> _delegate;
}

- (void)deselectAfterDelay;

@property(nonatomic, assign) BOOL selected;
@property(nonatomic, assign) BOOL selectionEnabled;
@property(nonatomic, assign) id<SelectableViewDelegate> delegate;

@end

@protocol SelectableViewDelegate

- (void)didSelectView:(SelectableView *)selectableView;

@end