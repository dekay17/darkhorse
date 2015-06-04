//
//  HuntPlaceTableCell.h
//  Lavahound
//
//  Created by Mark Allen on 7/19/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LoadingAwareImageView.h"
#import "Place.h"

@interface HuntPlaceTableCell : TTTableViewCell {
    Place *_place;
    UIImageView *_placeBackgroundImageView;
    LoadingAwareImageView *_placeImageView;
    UILabel *_placeDescriptionLabel;
}

@end