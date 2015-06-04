//
//  PlaceTableCell.h
//  Lavahound
//
//  Created by Mark Allen on 7/18/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LoadingAwareImageView.h"
#import "Place.h"

@interface PlaceTableItem : TTTableItem
@end


@interface PlaceTableCell : TTTableViewCell {
    UIButton *_placeButton;
    UILabel *_placeNameLabel;
    LoadingAwareImageView *_placeImageView;
    UILabel *_placeProximityDescriptionLabel;
    UILabel *_placeHuntCountLabel;
    Place *_place;
}

@end