//
//  HuntController.h
//  Lavahound
//
//  Created by Mark Allen on 7/20/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "SwitchableThreeViewController.h"

@interface HuntController : SwitchableThreeViewController {
    NSNumber *_huntId;
    NSString *_huntName;
    UILabel *_huntNameLabel;
}

- (id)initWithHuntId:(NSNumber *)huntId huntName:(NSString *)huntName;

@end