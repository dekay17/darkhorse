//
//  PhotoView.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "Photo.h"

@interface PhotoView : UIView {  
    Photo *_photo;
}

@property(nonatomic, retain) Photo *photo;

// Subclasses should override
- (void)didSetPhoto:(Photo *)photo;

@end