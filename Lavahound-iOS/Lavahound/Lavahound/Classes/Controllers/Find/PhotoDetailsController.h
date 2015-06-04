//
//  PhotoDetailsController.h
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "LoadingAwareImageView.h"
#import "PhotoDetailBackView.h"
#import "ModelViewController.h"
#import "LavahoundMarkPhotoFoundApi.h"
#import "TabBarController.h"

@interface PhotoDetailsController : ModelViewController <LavahoundMarkPhotoFoundApiDelegate, PhotoDetailBackViewDelegate>
{
    NSNumber *_photoId;
    LoadingAwareImageView *_photoDetailFrontView;    
    PhotoDetailBackView *_photoDetailBackView;
    
    BOOL KeepFoundItVisible;
    
    UIView      * FlipView;
    UIButton    * btnPhoto;
    UIButton    * btnInfo;
}

- (id)initWithPhotoId:(NSNumber *)photoId;
- (void) EventFoundItSelected;

@end