//
//  HuntTableCell.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LoadingAwareImageView.h"
#import "Hunt.h"
#import "Place.h"

@interface HuntTableItem : TTTableItem {
    Hunt *_hunt;
    Place *_place;  
}

@property (nonatomic, retain) Hunt *hunt;
@property (nonatomic, retain) Place *place;

@end


@interface HuntTableCell : TTTableViewCell {
    UIButton *_huntButton;
    UILabel *_huntNameLabel;
    UILabel *_huntProximityDescriptionLabel;
    UILabel *_huntFoundCountLabel;
    UILabel *_huntTotalCountLabel;    
    UIView *_progressBarBackgroundView;
    UIView *_progressBarForegroundView;    
    LoadingAwareImageView *_huntImageView;
    Hunt *_hunt;
    Place *_place;    
}

@end