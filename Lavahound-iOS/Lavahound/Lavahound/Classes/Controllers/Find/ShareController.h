//
//  ShareController.h
//  Lavahound
//
//  Created by Mark Allen on 5/13/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "Three20/Three20+Additions.h"
#import "ModelViewController.h"
#import "LavahoundFacebook.h"

typedef enum {
    ShareControllerDismissalBehaviorDefault,
    ShareControllerDismissalBehaviorPopToFindController
} ShareControllerDismissalBehavior;

@interface ShareController : ModelViewController<LavahoundFacebookDelegate> {
    NSNumber *_photoId;
    ShareControllerDismissalBehavior _shareControllerDismissalBehavior;
}

- (id)initWithPhotoId:(NSNumber *)photoId shareControllerDismissalBehavior:(ShareControllerDismissalBehavior)shareControllerDismissalBehavior;

@end